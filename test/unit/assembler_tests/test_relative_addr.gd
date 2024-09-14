class_name RelativeAddressingTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

var asm = Assembler.new()

const rel_str = """
lbl:
BPL lbl
BMI lbl
BVC lbl
BVS lbl
BCC lbl
BCS lbl
BNE lbl
BEQ lbl
"""
var rel_assembled = PackedByteArray([
	0x10, 0xfe, 0x30, 0xfc, 0x50, 0xfa, 0x70, 0xf8, 0x90, 0xf6, 0xb0, 0xf4, 0xd0, 0xf2, 0xf0, 0xf0
])

func test_relative_addressing():
	asm.asm_str = rel_str
	var success = asm.assemble()
	assert_int(success).is_equal(OK)
	assert_array(asm.assembled).is_equal(rel_assembled)
	