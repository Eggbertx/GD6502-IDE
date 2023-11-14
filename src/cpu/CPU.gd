extends Node

class_name CPU

signal status_changed
signal cpu_reset
signal rom_loaded
signal rom_unloaded

# status register bits
enum flag_bit {
	CARRY = 1,
	ZERO = 2,
	INTERRUPT = 4,
	BCD = 8,
	BREAK = 16,
	# no flag in 6th bit
	OVERFLOW = 64,
	NEGATIVE = 128
}

enum status {
	STOPPED, RUNNING, PAUSED, END
}

const RAM_END := 0x05FF
const PC_START := 0x0600

# registers
var A := 0
var X := 0
var Y := 0
var PC := PC_START
var SP := 0
var _status := status.STOPPED
var memory := []
var memory_size := 0
var opcode := 0
var flags := 0
var logger: Node

func _ready():
	reset()
	logger = null

func get_status() -> status:
	return _status

func get_flag_state(flag: flag_bit) -> bool:
	return (flags & flag) == flag

func set_flag(flag: flag_bit, state: bool):
	if state:
		flags |= flag
	else:
		flags &= (~flag)

func set_status(new_status: status, no_reset = false):
	if new_status == status.STOPPED and !no_reset:
		reset()
	if _status == new_status:
		return
	var old = _status
	_status = new_status
	status_changed.emit(_status, old)

func load_rom(bytes:PackedByteArray):
	memory.resize(PC_START + bytes.size())
	memory_size = memory.size()
	for b in range(bytes.size()):
		memory[PC_START + b] = bytes.decode_u8(b)
	rom_loaded.emit(bytes.size())

func unload_rom():
	memory.resize(PC_START)
	memory_size = PC_START
	for b in range(memory_size):
		memory[b] = 0
	rom_unloaded.emit()

func set_logger(newlogger):
	logger = newlogger

func reset(reset_status:status = _status):
	A = 0
	X = 0
	Y = 0
	PC = PC_START
	SP = 0
	flags = 0
	set_status(reset_status, true)
	cpu_reset.emit()

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

func _update_zero(register: int):
	set_flag(flag_bit.ZERO, register == 0)

func _update_negative(register: int):
	set_flag(flag_bit.NEGATIVE, (register & 0x80) > 0)

func execute(force = false, new_PC = -1):
	if _status != status.RUNNING and !force:
		return
	if new_PC > -1:
		PC = new_PC

	if PC >= memory.size():
		set_status(status.END)
		return

	opcode = pop_byte()
	match opcode:
		0x00: # BRK, implied
			set_status(status.STOPPED, true)
			set_flag(flag_bit.BREAK, true)
		0x01:
			pass
		0x05: # ORA, zero page
			var zp = pop_byte()
			A |= memory[zp]
			_update_negative(A)
			_update_zero(A)
		0x06:
			pass
		0x08:
			pass
		0x09: # ORA, immediate
			var num = pop_byte()
			A |= num
			_update_negative(A)
			_update_zero(A)
		0x0A:
			pass
		0x0D: # ORA, absolute
			A |= memory[pop_word()]
			_update_negative(A)
			_update_zero(A)
		0x0E:
			pass
		0x10:
			pass
		0x11:
			pass
		0x15: # ORA, zero page, x
			var zp = (pop_byte() + X) % 0xFF
			A |= memory[zp]
			_update_negative(A)
			_update_zero(A)
		0x16:
			pass
		0x18: #$ CLC, implied
			set_flag(flag_bit.CARRY, false)
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
		0x25: # AND, zero page
			var num = memory[pop_byte()]
			A &= num
			_update_negative(A)
			_update_zero(A)
		0x26:
			pass
		0x28:
			pass
		0x29: # AND, immediate
			var imm = pop_byte()
			A &= imm
			_update_negative(A)
			_update_zero(A)
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
		0x35: # AND, zero page, x
			var zp = (pop_byte() + X) % 0xFF
			A &= memory[zp]
			_update_negative(A)
			_update_zero(A)
		0x36:
			pass
		0x38: # SEC, implied
			set_flag(flag_bit.CARRY, true)
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
		0x58: # CLI, implied
			set_flag(flag_bit.INTERRUPT, false)
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
		0x78: # SEI, implied
			set_flag(flag_bit.INTERRUPT, true)
		0x79:
			pass
		0x7D:
			pass
		0x7E:
			pass
		0x81: # STA, indexed indirect
			var zp = (pop_byte() + X) % 0xFF
			var addr = memory[zp] + (memory[zp] << 8) & 0xFF
			memory[addr] = A
		0x84:
			pass
		0x85: # STA, zero page
			var zp = pop_byte()
			memory[zp] = A
		0x86:
			pass
		0x88: # DEY, implied
			Y = (Y - 1) & 0xFF
			_update_negative(Y)
			_update_zero(Y)
		0x8A: # TXA, implied
			A = X
			_update_negative(A)
			_update_zero(A)
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
		0x95: # STA, zero page, x
			var zp = (pop_byte() + X) % 0xFF
			memory[zp] = X
		0x96:
			pass
		0x98: # TYA, implied
			A = Y
			_update_zero(A)
			_update_negative(A)
		0x99: # STA, absolute, y
			memory[pop_word() + Y] = A
		0x9A:
			pass
		0x9D: # STA, absolute,  x
			memory[pop_word() + X] = A
		0xA0: # LDY, immediate
			Y = pop_byte()
			_update_zero(Y)
			_update_negative(Y)
		0xA1: # LDA, indexed indirect
			var zp = (pop_byte() + X) % 0xFF
			var addr = memory[zp] + (memory[zp] << 8) & 0xFF
			A = memory[addr]
			_update_zero(A)
			_update_negative(A)
		0xA2: # LDX, immediate
			X = pop_byte()
			_update_zero(X)
			_update_negative(X)
		0xA4: # LDY, zero page
			Y = memory[pop_byte()]
			_update_zero(Y)
			_update_negative(Y)
		0xA5: # LDA, zero page
			A = memory[pop_byte()]
			_update_zero(A)
			_update_negative(A)
		0xA6: # LDX, zero page
			X = memory[pop_byte()]
			_update_zero(X)
			_update_negative(X)
		0xA8: # TAY, implied
			Y = A
			_update_zero(Y)
			_update_negative(Y)
		0xA9: # LDA, immediate
			A = pop_byte()
			_update_zero(A)
			_update_negative(A)
		0xAA: # TAX, implied
			X = A
			_update_zero(X)
			_update_negative(X)
		0xAC: # LDY, absolute
			Y = memory[pop_word()]
			_update_zero(Y)
			_update_negative(Y)
		0xAD: # LDA, absolute
			A = memory[pop_word()]
			_update_zero(A)
			_update_negative(A)
		0xAE: # LDX, absolute
			X = memory[pop_word()]
			_update_zero(X)
			_update_negative(X)
		0xB0:
			pass
		0xB1: # LDA, 
			pass
		0xB4: # LDY, zero page, x
			var zp = (pop_byte() + X) % 0xFF
			Y = memory[zp]
			_update_zero(Y)
			_update_negative(Y)
		0xB5: # LDA, zero page, x
			var zp = (pop_byte() + X) % 0xFF
			A = memory[zp]
			_update_zero(A)
			_update_negative(A)
		0xB6: # LDX, zero page, y
			var zp = (pop_byte() + Y) % 0xFF
			X = memory[zp]
			_update_zero(X)
			_update_negative(X)
		0xB8: # CLV, implied
			set_flag(flag_bit.OVERFLOW, false)
		0xB9: # LDA, absolute, y
			A = memory[pop_word() + Y]
			_update_zero(A)
			_update_negative(A)
		0xBA:
			pass
		0xBC: # LDY, absolute, x
			Y = memory[pop_word() + X]
			_update_zero(Y)
			_update_negative(Y)
		0xBD: # LDA, absolute, x
			A = memory[pop_word() + X]
			_update_zero(A)
			_update_negative(A)
		0xBE: # LDX, absolute, y
			X = memory[pop_word()]
			_update_zero(Y)
			_update_negative(Y)
		0xC0:
			pass
		0xC1:
			pass
		0xC4:
			pass
		0xC5:
			pass
		0xC6: #DEC, zero page
			var zp = pop_byte()
			memory[zp] = (memory[zp] - 1) & 0xFF
			_update_zero(memory[zp])
			_update_negative(memory[zp])
		0xC8: # INY, implied
			Y = (Y + 1) & 0xFF
			_update_zero(Y)
			_update_negative(Y)
		0xC9:
			pass
		0xCA: # DEX, implied
			X = (X - 1) & 0xFF
			_update_zero(X)
			_update_negative(X)
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
		0xD8: # CLD
			set_flag(flag_bit.BCD, false)
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
		0xE8: # INX, implied
			X = (X + 1) & 0xFF
			_update_zero(X)
			_update_negative(X)
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
