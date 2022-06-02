class_name Opcodes

const ADC_ABS = 0x6D	# Add with carry - Absolute
const ADC_ZP = 0x65		# Add with carry - Zero-Page
const ADC_IMM = 0x69	# Add with carry - Immediate
const ADC_ABSX = 0x7D	# Add with carry - Absolute, X
const ADC_ABSY = 0x79	# Add with carry - Absolute, Y
const ADC_INDX = 0x61	# Add with carry - (Indirect, X)
const ADC_INDY = 0x71	# Add with carry - (Indirect), Y
const ADC_ZPX = 0x75	# Add with carry - Zero-Page, X
const AND_ABS = 0x2D	# Logical AND - Absolute
const AND_ZP = 0x25		# Logical AND - Zero-Page
const AND_IMM = 0x29	# Logical AND - Immediate
const AND_ABSX = 0x3D	# Logical AND - Absolute, X
const AND_ABSY = 0x39	# Logical AND - Absolute, Y
const AND_INDX = 0x21	# Logical AND - (Indirect, X)
const AND_INDY = 0x31	# Logical AND - (Indirect), Y
const AND_ZPX = 0x35	# Logical AND - Zero-Page, X
const ASL_ACC = 0x0A	# Arithmetic shift left - Accumulator
const ASL_ABS = 0x0E	# Arithmetic shift left - Absolute
const ASL_ZP = 0x06		# Arithmetic shift left - Zero-Page
const ASL_ABSX = 0x1E	# Arithmetic shift left - Absolute, X
const ASL_ZPX = 0x16	# Arithmetic shift left - Zero-Page, X
const BCC = 0x90		# Branch on carry clear
const BCS = 0xB0		# Branch on carry set
const BEQ = 0xF0		# Branch if equal to zero, Relative
const BIT_ABS = 0x2C	# Compare memory bits with accumulator - Absolute
const BIT_ZP = 0x24		# Compare memory bits with accumulator - Zero-Page
const BMI = 0x30		# Branch on minus
const BNE = 0xD0		# Branch on not equal to zero
const BPL = 0x10		# Branch on plus
const BRK = 0x00		# Break
const BVC = 0x50		# Break on overflow clear
const BVS = 0x70		# Branch on overflow set
const CLC = 0x18		# Clear carry
const CLD = 0xD8		# Clear decimal flag
const CLI = 0x58		# Clear interrupt mask
const CLV = 0xB8		# Clear overflow flag
const CMP_ABS = 0xCD	# Compare to accumulator - Absolute
const CMP_ZP = 0xC5		# Compare to accumulator - Zero-Page
const CMP_IMM = 0xC9	# Compare to accumulator - Immediate
const CMP_ABSX = 0xD0	# Compare to accumulator - Absolute, X
const CMP_ABSY = 0xD9	# Compare to accumulator - Absolute, Y
const CMP_INDX = 0xC1	# Compare to accumulator - (Indirect, X)
const CMP_INDY = 0xD1	# Compare to accumulator - (Indirect), Y
const CMP_ZPX = 0xD5	# Compare to accumulator - Zero-Page, X
const CPX_ABS = 0xEC	# Compare to X - Absolute
const CPX_ZP = 0xE4		# Compare to X - Zero-Page
const CPX_IMM = 0xE0	# Compare to X - Immediate
const CPY_ABS = 0xCC	# Compare to Y - Absolute
const CPY_ZP = 0xC4		# Compare to Y - Zero-Page
const CPY_IMM = 0xC0	# Compare to Y - Immediate
const DEC_ABS = 0xCE	# Decrement specified address - Absolute
const DEC_ZP = 0xC6		# Decrement specified address - Zero-Page
const DEC_ABSX = 0xDE	# Decrement specified address - Absolute, X
const DEC_ZPX = 0xDC	# Decrement specified address - Zero-Page, X
const DEX = 0xCA		# Decrement X
const DEY = 0x88		# Decrement Y
const EOR_ABS = 0x4D	# Exclusive OR with accumulator - Absolute
const EOR_ZP = 0x45		# Exclusive OR with accumulator - Zero-Page
const EOR_IMM = 0x49	# Exclusive OR with accumulator - Immediate
const EOR_ABSX = 0x5D	# Exclusive OR with accumulator - Absolute, X
const EOR_ABSY = 0x59	# Exclusive OR with accumulator - Absolute, Y
const EOR_INDX = 0x41	# Exclusive OR with accumulator - (Indirect, X)
const EOR_INDY = 0x51	# Exclusive OR with accumulator - (Indirect), Y
const EOR_ZPX = 0x55	# Exclusive OR with accumulator - Zero-Page, X
const INC_ABS = 0xEE	# Increment memory - Absolute
const INC_ZP = 0xE6		# Increment memory - Zero-Page
const INC_ABSX = 0xFE	# Increment memory - Absolute, X
const INC_ZPX = 0xF6	# Increment memory - Zero-Page, X
const INX = 0xE8		# Increment X
const INY = 0xC8		# Increment Y
const JMP = 0x4C		# Jump to address - Absolute
const JMP_IND = 0x6C	# Jump to address - Indirect
const JSR = 0x20		# Jump to subroutine
const LDA_ABS = 0xAD	# Load accumulator - Absolute
const LDA_ZP = 0xA5		# Load accumulator - Zero-Page
const LDA_IMM = 0xA9	# Load accumulator - Immediate
const LDA_ABSX = 0xBD	# Load accumulator - Absolute, X
const LDA_ABSY = 0xB9	# Load accumulator - Absolute, Y
const LDA_INDX = 0xA1	# Load accumulator - (Indirect, X)
const LDA_INDY = 0xB1	# Load accumulator - (Indirect), Y
const LDA_ZPX = 0xB5	# Load accumulator - Zero-Page, X
const LDX_ABS = 0xAE	# Load X - Absolute
const LDX_ZP = 0xA6		# Load X - Zero-Page
const LDX_IMM = 0xA2	# Load X - Immediate
const LDX_ABSY = 0xBE	# Load X - Absolute, Y
const LDX_ZPY = 0xB6	# Load X - Zero-Page, Y
const LDY_ABS = 0xAC	# Load Y - Absolute
const LDY_ZP = 0xA4		# Load Y - Zero-Page
const LDY_IMM = 0xA0	# Load Y - Immediate
const LDY_ABSX = 0xBC	# Load Y - Absolute, X
const LDY_ZPX = 0xB4	# Load Y - Zero-Page, X
const LSR_ACC = 0x4A	# Logical shift right - Accumulator
const LSR_ABS = 0x4E	# Logical shift right - Absolute
const LSR_ZP = 0x46		# Logical shift right - Zero-Page
const LSR_ABSX = 0x5E	# Logical shift right - Absolute, X
const LSR_ZPX = 0x56	# Logical shift right - Zero-Page, X
const NOP = 0xEA		# No operation
const ORA_ABS = 0x0D	# Inclusive OR with accumulator - Absolute
const ORA_ZP = 0x05		# Inclusive OR with accumulator - Zero-Page
const ORA_IMM = 0x09	# Inclusive OR with accumulator - Immediate
const ORA_ABSX = 0x1D	# Inclusive OR with accumulator - Absolute, X
const ORA_ABSY = 0x19	# Inclusive OR with accumulator - Absolute, Y
const ORA_INDX = 0x01	# Inclusive OR with accumulator - (Indirect, X)
const ORA_INDY = 0x11	# Inclusive OR with accumulator - (Indirect), Y
const ORA_ZPX = 0x15	# Inclusive OR with accumulator - Zero-Page, X
const PHA = 0x48		# Push accumulator onto stack
const PHP = 0x08		# Push processor status onto stack
const PLA = 0x68		# Pull accumulator into accumulator
const PLP = 0x28		# Pull processor status from stack
const ROL_ACC = 0x2A	# Rotate left one bit - Accumulator
const ROL_ABS = 0x2E	# Rotate left one bit - Absolute
const ROL_ZP = 0x26		# Rotate left one bit - Zero-Page
const ROL_ABSX = 0x3E	# Rotate left one bit - Absolute, X
const ROL_ZPX = 0x36	# Rotate left one bit - Zero-Page, X
const ROR_ACC = 0x6A	# Rotate right one bit - Accumulator
const ROR_ABS = 0x6E	# Rotate right one bit - Absolute
const ROR_ZP = 0x66		# Rotate right one bit - Zero-Page
const ROR_ABSX = 0x7E	# Rotate right one bit - Absolute, X
const ROR_ZPX = 0x76	# Rotate right one bit - Zero-Page, X
const RTI = 0x40		# Return from interrupt
const RTS = 0x60		# Return from subroutine
const SBC_ABS = 0xED	# Subtract with carry - Absolute
const SBC_ZP = 0xE5		# Subtract with carry - Zero-Page
const SBC_IMM = 0xE9	# Subtract with carry - Immediate
const SBC_ABSX = 0xFD	# Subtract with carry - Absolute, X
const SBC_ABSY = 0xF9	# Subtract with carry - Absolute, Y
const SBC_INDX = 0xE1	# Subtract with carry - (Indirect, X)
const SBC_INDY = 0xF1	# Subtract with carry - (Indirect), Y
const SBC_ZPX = 0xF5	# Subtract with carry - Zero-Page, X
const SEC = 0x38		# Set carry flag
const SED = 0xF8		# Set decimal flag
const SEI = 0x78		# Set interrupt disable flag
const STA_ABS = 0x8D	# Store accumulator in memory - Absolute
const STA_ZP = 0x85		# Store accumulator in memory - Zero-Page
const STA_ABSX = 0x9D	# Store accumulator in memory - Absolute, X
const STA_ABSY = 0x99	# Store accumulator in memory - Absolute, Y
const STA_INDX = 0x81	# Store accumulator in memory - (Indirect, X)
const STA_INDY = 0x91	# Store accumulator in memory - (Indirect), Y
const STA_ZPX = 0x95	# Store accumulator in memory - Zero-Page, X
const STX_ABS = 0xBE	# Store X in memory - Absolute
const STX_ZP = 0x86		# Store X in memory - Zero-Page
const STX_ZPY = 0x96	# Store X in memory - Zero-Page, Y
const STY_ABS = 0x8C	# Store Y in memory - Absolute
const STY_ZP = 0x84		# Store Y in memory - Zero-Page
const STY_ZPX = 0x94	# Store Y in memory - Zero-Page, X
const TAX = 0xAA		# Transfer accumulator into X
const TAY = 0xA8		# Transfer accumulator into Y
const TSX = 0xBA		# Transfer stack pointer into X
const TXA = 0x8A		# Transfer X into accumulator
const TXS = 0x9A		# Transfer X into stack pointer
const TYA = 0x98		# Transfer Y into accumulator

# addressing modes
enum {
	IMPLIED_ADDR
	ACCUMULATOR_ADDR
	ABSOLUTE_ADDR
	ZERO_PAGE_ADDR
	IMMEDIATE_ADDR
	ABSOLUTE_X_ADDR
	ABSOLUTE_Y_ADDR
	INDIRECT_X_ADDR
	INDIRECT_Y_ADDR
	ZERO_PAGE_X_ADDR
	ZERO_PAGE_Y_ADDR
	RELATIVE_ADDR
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

# dictionary used for basic assembly
const dict = {
#  opcode   IMP  ACC   ABS   ZP    IMM   ABSX  ABSY  INDX  INDY  ZPX   ZPY   REL   IND
	"ADC": [-1,   -1,  0x6D, 0x65, 0x69, 0x7D, 0x79, 0x61, 0x71, 0x75, -1,   -1,   -1],
	"AND": [-1,   -1,  0x2D, 0x25, 0x29, 0x3D, 0x39, 0x21, 0x31, 0x35, -1,   -1,   -1],
	"ASL": [-1,  0x0A, 0x0E, 0x06, -1,   0x1E, -1,   -1,   -1,   0x16, -1,   -1,   -1],
	"BCC": [-1,   -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   0x90, -1],
	"BCS": [-1,   -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   0xB0, -1],
	"BEQ": [-1,   -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   0xF0, -1],
	"BIT": [-1,   -1,  0x2C, 0x24, -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"BMI": [-1,   -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   0x30, -1],
	"BNE": [-1,   -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   0xD0, -1],
	"BPL": [-1,   -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   0x10, -1],
	"BRK": [0x00, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"BVC": [-1,   -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   0x50, -1],
	"BVS": [-1,   -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   0x70, -1],
	"CLC": [0x18, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"CLD": [0xD8, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"CLI": [0x58, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"CLV": [0xB8, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"CMP": [-1,   -1,  0xCD, 0xC5, 0xC9, 0xD0, 0xD9, 0xC1, 0xD1, 0xD5, -1,   -1,   -1],
	"CPX": [-1,   -1,  0xEC, 0xE4, 0xE0, -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"CPY": [-1,   -1,  0xCC, 0xC4, 0xC0, -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"DEC": [-1,   -1,  -1,   0xCE, 0xC6, -1,  0xDE,  -1,   -1,   0xD6, -1,   -1,   -1],
	"DEX": [0xCA, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"DEY": [0x88, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"EOR": [-1,   -1,  0x4D, 0x45, 0x49, 0x5D, 0x59, 0x41, 0x51, 0x55, -1,   -1,   -1],
	"INC": [-1,   -1,  0xEE, 0xE6, -1,   0xFE, -1,   -1,   -1,   0xF6, -1,   -1,   -1],
	"INX": [0xE8, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"INY": [0xC8, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"JMP": [-1,   -1,  0x4C, -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   0x6C],
	"JSR": [-1,   -1,  0x20, -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"LDA": [-1,   -1,  0xAD, 0xA5, 0xA9, 0xBD, 0xB9, 0xA1, 0xB1, 0xB5, -1,   -1,   -1],
	"LDX": [-1,   -1,  0xAE, 0xA6, 0xA2, -1,   0xBE, -1,   -1,   -1,   0xB6, -1,   -1],
	"LDY": [-1,   -1,  0xAC, 0xA4, 0xAD, 0xBC, -1,   -1,   -1,   0xB4, -1,   -1,   -1],
	"LSR": [-1,  0x4A, 0x4E, 0x46, -1,   0x5E, -1,   -1,   -1,   0x56, -1,   -1,   -1],
	"NOP": [0xEA, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"ORA": [-1,   -1,  0x0D, 0x05, 0x09, 0x1D, 0x19, 0x01, 0x11, 0x15, -1,   -1,   -1],
	"PHA": [0x48, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"PHP": [0x08, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"PLA": [0x68, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"PLP": [0x28, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"ROL": [-1,  0x2A, 0x2E, 0x26, -1,   0x3E, -1,   -1,   -1,   0x36, -1,   -1,   -1],
	"ROR": [-1,  0x6A, 0x6E, 0x66, -1,   0x7E, -1,   -1,   -1,   0x76, -1,   -1,   -1],
	"RTI": [0x40, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"RTS": [0x60, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"SBC": [-1,   -1,  0xED, 0xE5, 0xE9, 0xFD, 0xF9, 0xE1, 0xF1, 0xF5, -1,   -1,   -1],
	"SEC": [0x38, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"SED": [0xF8, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"SEI": [0x78, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"STA": [-1,   -1,  0x8D, 0x85, -1,   0x9D, 0x99, 0x81, 0x91, 0x95, -1,   -1,   -1],
	"STX": [-1,   -1,  0x8E, 0x86, -1,   -1,   -1,   -1,   -1,   -1,   0x96, -1,   -1],
	"STY": [-1,   -1,  0x8C, 0x84, -1,   -1,   -1,   -1,   -1,   0x94, -1,   -1,   -1],
	"TAX": [0xAA, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"TAY": [0xA8, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"TSX": [0xBA, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"TXA": [0x8A, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"TXS": [0x9A, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
	"TYA": [0x98, -1,  -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1],
}

func _ready() -> void:
	pass
