extends Node

class_name CPU

signal status_changed

# status register bits
const STATUS_NONE = 0
const STATUS_CARRY = 1 
const STATUS_ZERO = 2
const STATUS_INTERRUPT = 4
const STATUS_BCD = 8
const STATUS_BREAK = 16
const STATUS_OVERFLOW = 64
const STATUS_NEGATIVE = 128

const M6502_STOPPED = 0
const M6502_RUNNING = 1
const M6502_PAUSED = 2

const RAM_END = 0x05FF
const PC_START = 0x0600


# registers
var accumulator = 0
var x = 0
var y = 0
var SP = 0
var PC = PC_START
var _status = M6502_STOPPED
var memory = []
var memory_size = 0
var opcode = 0
var logger: Node

func _ready():
	reset()
	logger = null

func get_status() -> int:
	return _status

func set_status(new_status: int):
	if _status == new_status:
		return
	var old = _status
	_status = new_status
	emit_signal("status_changed", _status, old)

func load_bytes(bytes:PoolByteArray):
	memory.resize(PC_START + bytes.size())
	memory_size = memory.size()
	for b in bytes:
		memory[PC_START + b] = bytes[b]

func set_logger(newlogger):
	logger = newlogger

func print_info():
	if logger != null:
		logger.write_line("Accumulator: %x" % accumulator)
		logger.write_line("X: %x" % x)
		logger.write_line("Y: %x" % y)
		logger.write_line("Stack pointer: %x" % SP)
		logger.write_line("PC: %x" % PC)
		logger.write_line("Opcode: %x" % opcode)

func _process(_delta:float):
	execute()

func reset(reset_status:int = _status):
	accumulator = 0
	x = 0
	y = 0
	SP = 0
	PC = PC_START
	set_status(reset_status)

# basic memory operations
func pop_byte():
	if PC >= memory.size():
		return 0
	var popped = memory[PC] & 0xFF
	PC += 1
	return popped

func push_byte(byte:int):
	if PC < memory.size():
		memory[PC] = byte & 0xFF
		PC += 1

func pop_word():
	return pop_byte() + (pop_byte() << 8)

func push_word(byte:int):
	push_byte(byte & 0xFF)
	push_byte((byte >> 8) & 0xFF)

func execute(new_PC = -1):
	if _status != M6502_RUNNING:
		return
	if new_PC > -1:
		PC = new_PC
	#print_info()
	if PC >= memory.size():
		set_status(M6502_STOPPED)

	opcode = pop_byte()
	match opcode:
		0x00: # BRK
			set_status(M6502_STOPPED)
		0x01:
			pass
		0x05:
			pass
		0x06:
			pass
		0x08:
			pass
		0x09:
			pass
		0x0A:
			pass
		0x0D:
			pass
		0x0E:
			pass
		0x10:
			pass
		0x11:
			pass
		0x15:
			pass
		0x16:
			pass
		0x18:
			pass
		0x19:
			pass
		0x1D:
			pass
		0x1E:
			pass
		0x20:
			pass
		0x21:
			pass
		0x24:
			pass
		0x25:
			pass
		0x26:
			pass
		0x28:
			pass
		0x29:
			pass
		0x2A:
			pass
		0x2A:
			pass
		0x2C:
			pass
		0x2D:
			pass
		0x2E:
			pass
		0x30:
			pass
		0x31:
			pass
		0x35:
			pass
		0x36:
			pass
		0x38:
			pass
		0x39:
			pass
		0x3D:
			pass
		0x3E:
			pass
		0x40:
			pass
		0x41:
			pass
		0x45:
			pass
		0x46:
			pass
		0x48:
			pass
		0x49:
			pass
		0x4A:
			pass
		0x4A:
			pass
		0x4C:
			pass
		0x4D:
			pass
		0x4E:
			pass
		0x50:
			pass
		0x51:
			pass
		0x55:
			pass
		0x56:
			pass
		0x58:
			pass
		0x59:
			pass
		0x5D:
			pass
		0x5E:
			pass
		0x60:
			pass
		0x61:
			pass
		0x65:
			pass
		0x66:
			pass
		0x68:
			pass
		0x69:
			pass
		0x6A:
			pass
		0x6A:
			pass
		0x6C:
			pass
		0x6D:
			pass
		0x6E:
			pass
		0x70:
			pass
		0x71:
			pass
		0x75:
			pass
		0x76:
			pass
		0x78:
			pass
		0x79:
			pass
		0x7D:
			pass
		0x7E:
			pass
		0x81:
			pass
		0x84:
			pass
		0x85:
			pass
		0x86:
			pass
		0x88:
			pass
		0x8A:
			pass
		0x8C:
			pass
		0x8D:
			pass
		0x8E:
			pass
		0x90:
			pass
		0x91:
			pass
		0x94:
			pass
		0x95:
			pass
		0x96:
			pass
		0x98:
			pass
		0x99:
			pass
		0x9A:
			pass
		0x9D:
			pass
		0xA0:
			pass
		0xA1:
			pass
		0xA2:
			pass
		0xA4:
			pass
		0xA5:
			pass
		0xA6:
			pass
		0xA8:
			pass
		0xA9:
			pass
		0xAA:
			pass
		0xAC:
			pass
		0xAD:
			pass
		0xAE:
			pass
		0xB0:
			pass
		0xB1:
			pass
		0xB4:
			pass
		0xB5:
			pass
		0xB6:
			pass
		0xB8:
			pass
		0xB9:
			pass
		0xBA:
			pass
		0xBC:
			pass
		0xBD:
			pass
		0xBE:
			pass
		0xC0:
			pass
		0xC1:
			pass
		0xC4:
			pass
		0xC5:
			pass
		0xC6:
			pass
		0xC8:
			pass
		0xC9:
			pass
		0xCA:
			pass
		0xCC:
			pass
		0xCD:
			pass
		0xCE:
			pass
		0xD0:
			pass
		0xD1:
			pass
		0xD5:
			pass
		0xD6:
			pass
		0xD8:
			pass
		0xD9:
			pass
		0xDD:
			pass
		0xDE:
			pass
		0xE0:
			pass
		0xE1:
			pass
		0xE4:
			pass
		0xE5:
			pass
		0xE6:
			pass
		0xE8:
			pass
		0xE9:
			pass
		0xEA:
			pass
		0xEC:
			pass
		0xED:
			pass
		0xEE:
			pass
		0xF0:
			pass
		0xF1:
			pass
		0xF5:
			pass
		0xF6:
			pass
		0xF8:
			pass
		0xF9:
			pass
		0xFD:
			pass
		0xFE:
			pass
