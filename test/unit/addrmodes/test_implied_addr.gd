class_name ImpliedAddressingTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

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
var implied_assembled = PackedByteArray([
	0x0a, 0x18, 0x38, 0x58, 0x78, 0xb8, 0xd8, 0xf8, 0x4a, 0xea, 0xaa, 0x8a, 0xca, 0xe8, 0xa8, 0x98,
	0x88, 0xc8, 0x6a, 0x2a, 0x40, 0x60, 0x9a, 0xba, 0x48, 0x68, 0x08, 0x28 
])

func test_implied_addressing():
	asm.asm_str = implied_str
	var success = asm.assemble()
	assert_int(success).is_equal(OK)
	assert_int(asm.assembled.size()).is_equal(implied_assembled.size())
	assert_array(asm.assembled).is_equal(implied_assembled)
