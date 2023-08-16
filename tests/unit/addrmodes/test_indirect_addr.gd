extends "res://addons/gut/test.gd"

# Test indexed indirect ($nn,x) and indirect indexed ($nn),y addressing modes

var asm = Assembler.new()

const indx_str = """
ADC ($12,x)
AND ($12,x)
CMP ($12,x)
EOR ($12,x)
LDA ($12,x)
ORA ($12,x)
SBC ($12,x)
STA ($12,x)
"""
var indx_assembled = PackedByteArray([
	0x61, 0x12, 0x21, 0x12, 0xc1, 0x12, 0x41, 0x12, 0xa1, 0x12, 0x01, 0x12, 0xe1, 0x12, 0x81, 0x12
])

const indy_str = """
ADC ($ab),y
AND ($ab),y
CMP ($ab),y
EOR ($ab),y
LDA ($ab),y
ORA ($ab),y
SBC ($ab),y
STA ($ab),y
"""
var indy_assembled = PackedByteArray([
	0x71, 0xab, 0x31, 0xab, 0xd1, 0xab, 0x51, 0xab, 0xb1, 0xab, 0x11, 0xab, 0xf1, 0xab, 0x91, 0xab
])

func test_indx_addressing():
	asm.asm_str = indx_str
	var success = asm.assemble()
	assert_eq(success, OK, "tests to make sure the code for testing indexed indirect addressing assembled with no errors")
	assert_eq(asm.assembled.size(), indx_assembled.size(), "assembled bytecode size")
	assert_eq(asm.assembled, indx_assembled, "testing indexed indirect addressing")

func test_indy_addressing():
	asm.asm_str = indy_str
	var success = asm.assemble()
	assert_eq(success, OK, "tests to make sure the code for testing indirect indexed addressing assembled with no errors")
	assert_eq(asm.assembled.size(), indy_assembled.size(), "assembled bytecode size")
	assert_eq(asm.assembled, indy_assembled, "testing indirect indexed addressing")
