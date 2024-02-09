class_name Opcodes

# addressing modes
enum {
	IMPLIED_ADDR,
	ACCUMULATOR_ADDR,
	ABSOLUTE_ADDR,
	ZERO_PAGE_ADDR,
	IMMEDIATE_ADDR,
	ABSOLUTE_X_ADDR,
	ABSOLUTE_Y_ADDR,
	INDIRECT_X_ADDR,
	INDIRECT_Y_ADDR,
	ZERO_PAGE_X_ADDR,
	ZERO_PAGE_Y_ADDR,
	RELATIVE_ADDR,
	INDIRECT_ADDR
}
const INVALID_ADDRESS_MODE = -1
const UNDEFINED_OPCODE = -2

static func get_opcode_byte(opcode:String, mode:int):
	opcode = opcode.to_upper()
	if !dict.has(opcode):
		return UNDEFINED_OPCODE
	if dict[opcode].size() <= mode:
		return INVALID_ADDRESS_MODE
	return dict[opcode][mode]

# Returns true if the specified opcode string refers to an instruction that uses relative addressing,
# otherwise 16-bit addresses passed to it are stored as the 8-bit difference between that address and
# the current PC
static func is_relative_instruction(opcode: String):
	return dict.has(opcode.to_upper()) and dict[opcode.to_upper()][RELATIVE_ADDR] > -1

# dictionary used for basic assembly
const dict = {
#  Opcode   IMP    ACC  ABS   ZP    IMM   ABSX  ABSY  INDX  INDY  ZPX   ZPY   REL  IND
	"ADC": [-1,    -1,  0x6D, 0x65, 0x69, 0x7D, 0x79, 0x61, 0x71, 0x75, -1,   -1,   -1],
	"AND": [-1,    -1,  0x2D, 0x25, 0x29, 0x3D, 0x39, 0x21, 0x31, 0x35, -1,   -1,   -1],
	"ASL": [-1,   0x0A, 0x0E, 0x06, -1,   0x1E, -1,   -1,   -1,   0x16, -1,   -1,   -1],
	"BCC": [-1,    -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   0x90, -1],
	"BCS": [-1,    -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   0xB0, -1],
	"BEQ": [-1,    -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   0xF0, -1],
	"BIT": [-1,    -1,  0x2C, 0x24, -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"BMI": [-1,    -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   0x30, -1],
	"BNE": [-1,    -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   0xD0, -1],
	"BPL": [-1,    -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   0x10, -1],
	"BRK": [0x00,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"BVC": [-1,    -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   0x50, -1],
	"BVS": [-1,    -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   0x70, -1],
	"CLC": [0x18,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"CLD": [0xD8,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"CLI": [0x58,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"CLV": [0xB8,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"CMP": [-1,    -1,  0xCD, 0xC5, 0xC9, 0xDD, 0xD9, 0xC1, 0xD1, 0xD5, -1,   -1,   -1],
	"CPX": [-1,    -1,  0xEC, 0xE4, 0xE0, -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"CPY": [-1,    -1,  0xCC, 0xC4, 0xC0, -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"DEC": [-1,    -1,  0xCE, 0xC6, -1,   0xDE, -1,   -1,   -1,   0xD6, -1,   -1,   -1],
	"DEX": [0xCA,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"DEY": [0x88,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"EOR": [-1,    -1,  0x4D, 0x45, 0x49, 0x5D, 0x59, 0x41, 0x51, 0x55, -1,   -1,   -1],
	"INC": [-1,    -1,  0xEE, 0xE6, -1,   0xFE, -1,   -1,   -1,   0xF6, -1,   -1,   -1],
	"INX": [0xE8,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"INY": [0xC8,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"JMP": [-1,    -1,  0x4C, -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  0x6C],
	"JSR": [-1,    -1,  0x20, -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"LDA": [-1,    -1,  0xAD, 0xA5, 0xA9, 0xBD, 0xB9, 0xA1, 0xB1, 0xB5, -1,   -1,   -1],
	"LDX": [-1,    -1,  0xAE, 0xA6, 0xA2, -1,   0xBE, -1,   -1,   -1,   0xB6, -1,   -1],
	"LDY": [-1,    -1,  0xAC, 0xA4, 0xA0, 0xBC, -1,   -1,   -1,   0xB4, -1,   -1,   -1],
	"LSR": [0x4A, 0x4A, 0x4E, 0x46, -1,   0x5E, -1,   -1,   -1,   0x56, -1,   -1,   -1],
	"NOP": [0xEA,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"ORA": [-1,    -1,  0x0D, 0x05, 0x09, 0x1D, 0x19, 0x01, 0x11, 0x15, -1,   -1,   -1],
	"PHA": [0x48,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"PHP": [0x08,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"PLA": [0x68,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"PLP": [0x28,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"ROL": [0x2A, 0x2A, 0x2E, 0x26, -1,   0x3E, -1,   -1,   -1,   0x36, -1,   -1,   -1],
	"ROR": [0x6A, 0x6A, 0x6E, 0x66, -1,   0x7E, -1,   -1,   -1,   0x76, -1,   -1,   -1],
	"RTI": [0x40,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"RTS": [0x60,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"SBC": [-1,    -1,  0xED, 0xE5, 0xE9, 0xFD, 0xF9, 0xE1, 0xF1, 0xF5, -1,   -1,   -1],
	"SEC": [0x38,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"SED": [0xF8,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"SEI": [0x78,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"STA": [-1,    -1,  0x8D, 0x85, -1,   0x9D, 0x99, 0x81, 0x91, 0x95, -1,   -1,   -1],
	"STX": [-1,    -1,  0x8E, 0x86, -1,   -1,   -1,   -1,   -1,   -1,   0x96, -1,   -1],
	"STY": [-1,    -1,  0x8C, 0x84, -1,   -1,   -1,   -1,   -1,   0x94, -1,   -1,   -1],
	"TAX": [0xAA,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"TAY": [0xA8,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"TSX": [0xBA,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"TXA": [0x8A,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"TXS": [0x9A,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"TYA": [0x98,  -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
}
