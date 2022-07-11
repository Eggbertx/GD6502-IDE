extends "res://addons/gut/test.gd"

# Test implied addressing

var asm = Assembler.new()

const implied_str = """
ASL
CLC
SEC
CLI
SEI
CLV
CLD
SED
LSR
NOP
TAX
TXA
DEX
INX
TAY
TYA
DEY
INY
ROR
ROL
RTI
RTS
TXS
TSX
PHA
PLA
PHP
PLP
"""
var implied_assembled = PoolByteArray([
	0x0a, 0x18, 0x38, 0x58, 0x78, 0xb8, 0xd8, 0xf8, 0x4a, 0xea, 0xaa, 0x8a, 0xca, 0xe8, 0xa8, 0x98,
	0x88, 0xc8, 0x6a, 0x2a, 0x40, 0x60, 0x9a, 0xba, 0x48, 0x68, 0x08, 0x28 
])

func test_implied_addressing():
	asm.asm_str = implied_str
	var success = asm.assemble()
	assert_eq(success, OK, "tests to make sure the code for testing implied addressing assembled with no errors")
	assert_eq(asm.assembled.size(), implied_assembled.size(), "assembled bytecode size")
	assert_eq(asm.assembled, implied_assembled, "testing implied addressing")
