class_name Assembler

const INVALID_SYNTAX = -3
const unset_label = 0xFFFF # uses this as a memory address if a referenced label doesn't exist
const start_pc = 0x600
var current_pc = start_pc

var logger: Node

var assembled: PoolByteArray
var operand_re = RegEx.new()
var whitespace_re = RegEx.new()
var labeldef_re = RegEx.new()
var program_offset_re = RegEx.new()
var high_byte_re = RegEx.new()
var low_byte_re = RegEx.new()

var asm_file = ""
var asm_str = ""

# Used for storing label locations in the assembled[] to be given
# the correct address when the assembling is complete
# unset labels are $FFFF by default
var labels = {
	# "labelname": 0xFFFF
}

# appended to on lines like jmp labelname, with "location" referring to the position in the byte array
# that the request was made
var label_refs = [
	# {"name": "labelname", "location": 0}
]

func _init():
	operand_re.compile("(\\()?(#)?(\\$)?(\\w+)(\\))?(,[xXyY])?(\\))?$")
	whitespace_re.compile("\\s+")
	labeldef_re.compile("^(\\w+):(.*)")
	program_offset_re.compile("^\\*=(\\$?\\w+)$")
	high_byte_re.compile("^#>(\\w+)$")
	low_byte_re.compile("^#<(\\w+)$")
	assembled = PoolByteArray()
	logger = null

func debug_print(debug_str):
	if logger == null or !logger.has_method("write_line"):
		return
	logger.write_line(debug_str)

func get_label_addr(labelname:String):
	return labels.get(labelname, unset_label)

# Get the given number as a little-endian byte array, capping it at 16 bits.
# If is_word is true, it forces the result to be a 16-bit address (returning two bytes) even if num < 0xFF
func get_bytes(num:int, is_word = false):
	if num < 256 and not is_word:
		return [num]
	return [num & 0x00FF, (num & 0xFF00) >> 8]

# Returns an Array. The first element is the success (anything < 0 is invalid), the rest are bytes
func get_instruction_bytes(opcode:String, addr_mode:int, arg:int = -1):
	var op_byte = Opcodes.get_opcode_byte(opcode, addr_mode)
	if op_byte < 0:
		# 6502asm.com's assembler uses some nonstandard addressing
		if addr_mode == Opcodes.ABSOLUTE_ADDR:
			addr_mode = Opcodes.RELATIVE_ADDR
		elif addr_mode == Opcodes.IMPLIED_ADDR:
			addr_mode = Opcodes.ACCUMULATOR_ADDR
		op_byte = Opcodes.get_opcode_byte(opcode, addr_mode)

	if op_byte < 0:
		return []
	var bytes = [op_byte]
	if arg > -1:
		bytes.append_array(get_bytes(arg))
	return bytes

func load_asm(asm_path:String):
	asm_file = asm_path
	var file = File.new()
	var err = file.open(asm_path, File.READ)
	if err:
		return err
	asm_str = file.get_as_text()
	file.close()

func set_logger(new_logger):
	if new_logger.has_method("write_line"):
		self.logger = new_logger

# remove comments and clean excess whitespace from the given line
func clean_line(line:String):
	var comment_split = line.split(";", true, 1)
	var cleaned = comment_split[0].strip_edges(true, true)
	if cleaned == "":
		return cleaned

	cleaned = whitespace_re.sub(cleaned, " ") # remove excess whitespace
	var parts = cleaned.split(" ", true)
	var opcode = parts[0].strip_edges(true, true)

	if parts.size() == 1:
		return opcode # no operands

	parts.remove(0)
	cleaned = opcode + " " + whitespace_re.sub(parts.join(" "), " ", true)
	return cleaned

func dcb_to_bytes(operands:String):
	var bytes = []
	var cleaned = whitespace_re.sub(operands, "", true)
	if cleaned == "":
		return bytes
	var bytes_in = cleaned.split(",", true)

	for byte in bytes_in:
		var b = 0
		if byte == "":
			continue
		if byte[0] == '$':
			if !byte.substr(1).is_valid_hex_number(false):
				return null
			b = ("0x" + byte.substr(1)).hex_to_int()
		else:
			if !byte.is_valid_integer():
				return null
			b = byte.to_int()
		bytes.append(b & 0xFF)
	return bytes

func append_bytes(bytes: Array, on_invalid = INVALID_SYNTAX):
	if bytes != null and bytes.size() > 0:
		assembled.append_array(bytes)
		current_pc += bytes.size()
		return OK
	return on_invalid

# Cleans and compiles `line` into 6502 bytecode. If `log_info` is set, info about each line
# (addressing mode, data scraped from regular expressions, etc) to the status log and can
# cause serious slowdown fo large assembly files so it is disabled by default
func assemble_line(line: String):
	if assembled == null:
		assembled = PoolByteArray()

	var cleaned = clean_line(line)
	if cleaned == "":
		return OK

	var matched = program_offset_re.search(cleaned)
	if matched != null:
		# line has a program offset, example "*=128"
		var addr = -1
		if matched.strings[1][0] == "$" and matched.strings[1].substr(1).is_valid_hex_number(false):
			# hexadecimal address, ex: *=$0600
			addr = ("0x" + matched.strings[1].substr(1)).hex_to_int() 
		elif matched.strings[1].is_valid_integer():
			# decimal address, ex: *=1536
			addr = matched.strings[1].to_int()
		if addr < 0 or addr > 0xFFFF:
			# address is an invalid number or is out of bounds
			return INVALID_SYNTAX
		current_pc = addr
		return OK

	matched = labeldef_re.search(cleaned)
	var label = ""
	if matched != null:
		# line contains a new label, store it and continue
		label = matched.strings[1]
		if not labels.has(label):
			labels[label] = current_pc

		cleaned = clean_line(matched.strings[2])
		if cleaned == "": # check if there was anything else on that line since `labelname: nop` is valid
			return OK
	
	var parts = cleaned.split(" ", true, 1)
	var opcode = parts[0]
	var operands = cleaned.substr(opcode.length() + 1)

	if parts.size() == 1:
		# line uses implied addressing (nop, clc, etc)
		return append_bytes(get_instruction_bytes(parts[0], Opcodes.IMPLIED_ADDR), Opcodes.UNDEFINED_OPCODE)

	if parts[0] == "dcb":
		# line has a dcb, example "dcb $01, $02, $15"
		return append_bytes(dcb_to_bytes(operands), INVALID_SYNTAX)

	matched = high_byte_re.search(operands)
	if matched != null:
		return append_bytes(get_instruction_bytes(opcode, Opcodes.ZERO_PAGE_ADDR), INVALID_SYNTAX)

	matched = low_byte_re.search(operands)
	if matched != null:
		return append_bytes(get_instruction_bytes(opcode, Opcodes.ZERO_PAGE_ADDR), INVALID_SYNTAX)


	matched = operand_re.search(operands)
	if matched == null:
		return INVALID_SYNTAX

	var strings = matched.strings
	if strings[2] == "#":
		# immediate value, load the following byte directly into memory
		var value = 0
		if strings[3] == "$":
			value = ("0x" + strings[4]).hex_to_int()
		else:
			value = strings[4].to_int()
		return append_bytes(get_instruction_bytes(opcode, Opcodes.IMMEDIATE_ADDR, value))

	var is_label = (not strings[4].is_valid_integer()) and strings[3] != "$"
	var num: int
	if is_label:
		num = unset_label
	elif strings[3] == "$":
		num = ("0x" + strings[4]).hex_to_int()
	else:
		num = strings[4].to_int()

	if num > 0xFFFF:
		# fail if number is a memory address > 16 bits
		print_debug("invalid number %s" % strings[4])
		return INVALID_SYNTAX

	var mode = Opcodes.INVALID_ADDRESS_MODE
	if strings[1] == "(" and strings[5] == ")":
		if strings[6].to_lower() == ",y":
			if (strings[3] == "$" and num > 0xFF) or is_label:
				mode = INVALID_SYNTAX
			else:
				# indirect indexed, ex: ($00),y
				mode = Opcodes.INDIRECT_Y_ADDR
		elif num <= 0xFF and (not is_label):
			mode = INVALID_SYNTAX
		else:
			# indirect, ex ($ff00)
			mode = Opcodes.INDIRECT_ADDR
	elif strings[1] == "(" and strings[6].to_lower() == ",x" and strings[7] == ")":
		if num > 0xFF or is_label:
			mode = INVALID_SYNTAX
		else:
			# indexed indirect, ex: ($00,x)
			mode = Opcodes.INDIRECT_X_ADDR
	elif strings[6].to_lower() == ",x":
		if num > 0xFF or is_label:
			# ex: $1234,x
			mode = Opcodes.ABSOLUTE_X_ADDR
		else:
			# ex: $ab,x
			print_debug("%s has a zero page x" % line)
			mode = Opcodes.ZERO_PAGE_X_ADDR
	elif strings[6].to_lower() == ",y":
		if num > 0xFF or is_label:
			# ex: $1234,y
			mode = Opcodes.ABSOLUTE_Y_ADDR
		else:
			# ex: $ab,y
			mode = Opcodes.ZERO_PAGE_Y_ADDR
	elif num > 0xFF or is_label:
		# ex: $ff00
		mode = Opcodes.ABSOLUTE_ADDR
	else:
		# ex: $ab
		mode = Opcodes.ZERO_PAGE_ADDR
	
	if mode < 0:
		print_debug("Error code %d on line: %s" % [mode, cleaned])
		return mode

	var status = append_bytes(get_instruction_bytes(opcode, mode, num), Opcodes.INVALID_ADDRESS_MODE)
	if status < 0:
		print_debug("Invalid addressing mode on line: %s" % line)
		return status

	if is_label:
		label_refs.append(
			{"name": strings[4], "location": assembled.size() - 2}
		)
	return OK

func update_labels():
	debug_print("Updating label addresses")
	for label in label_refs:
		var labelname = label["name"]
		if not labels.has(labelname):
			continue
		var location = label["location"]
		var bytes = get_bytes(labels[labelname], true)
		assembled[location] = bytes[0]
		assembled[location + 1] = bytes[1]

func print_hexdump():
	debug_print("Hexdump:")
	var dump_pc = start_pc
	var dump = ""
	for a in range(assembled.size()):
		if (a % 16 == 0):
			if a > 0:
				dump += "\n"
			dump += "%04x: " % dump_pc
		dump += "%02x " % assembled[a]
		dump_pc += 1
	debug_print(dump)

func assemble():
	assembled.resize(0)
	labels.clear()
	label_refs.clear()

	if asm_str == "":
		debug_print("No code to assemble")
		return OK
	var lines = asm_str.split("\n")
	current_pc = start_pc
	for l in range(lines.size()):
		var line_str = lines[l]
		var success = assemble_line(line_str)
		match success:
			INVALID_SYNTAX:
				debug_print("Invalid syntax on line #%d: %s" % [l+1, line_str])
				return INVALID_SYNTAX
			Opcodes.INVALID_ADDRESS_MODE:
				debug_print("Invalid addressing mode on line #%d: %s" % [l+1, line_str])
				return Opcodes.INVALID_ADDRESS_MODE
			Opcodes.UNDEFINED_OPCODE:
				debug_print("Unrecognized opcode on line #%d: %s" % [l+1, line_str])
				return Opcodes.UNDEFINED_OPCODE

	update_labels()
	if logger != null and logger.has_method("write_linebreak"):
		logger.write_linebreak()
	print_hexdump()
	return OK
