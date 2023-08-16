extends "res://addons/gut/test.gd"

# Test immediate addressing

var asm = Assembler.new()

const immediate_str = """
ADC #$12
AND #34
CMP #$56
CPX #$78
CPY #$9a
EOR #$bc
LDA #$de
LDX #$f0
LDY #$12
ORA #$34
SBC #$56
"""
var immediate_assembled = PackedByteArray([
	0x69, 0x12, 0x29, 0x22, 0xc9, 0x56, 0xe0, 0x78, 0xc0, 0x9a, 0x49, 0xbc, 0xa9, 0xde, 0xa2, 0xf0,
	0xa0, 0x12, 0x09, 0x34, 0xe9, 0x56 
])

func test_immediate_addressing():
	asm.asm_str = immediate_str
	var success = asm.assemble()
	assert_eq(success, OK, "make sure the code for testing immediate addresssing assembled with no errors")
	assert_eq(asm.assembled.size(), immediate_assembled.size(), "assembled bytecode size")
	assert_eq(asm.assembled, immediate_assembled, "testing immediate addressing")
