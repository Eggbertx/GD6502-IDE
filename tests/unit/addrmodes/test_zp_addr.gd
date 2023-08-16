extends "res://addons/gut/test.gd"

var asm = Assembler.new()

const zp_str = """
ADC $ab
AND $ab
ASL $ab
BIT $ab
CMP $ab
CPX $ab
CPY $ab
DEC $ab
EOR $ab
INC $ab
LDA $ab
LDX $ab
LDY $ab
LSR $ab
ORA $ab
ROR $ab
ROL $ab
SBC $ab
STA $ab
STX $ab
STY $ab
"""
var zp_assembled = PackedByteArray([
	0x65, 0xab, 0x25, 0xab, 0x06, 0xab, 0x24, 0xab, 0xc5, 0xab, 0xe4, 0xab, 0xc4, 0xab, 0xc6, 0xab,
	0x45, 0xab, 0xe6, 0xab, 0xa5, 0xab, 0xa6, 0xab, 0xa4, 0xab, 0x46, 0xab, 0x05, 0xab, 0x66, 0xab,
	0x26, 0xab, 0xe5, 0xab, 0x85, 0xab, 0x86, 0xab, 0x84, 0xab
])

const zpx_str = """
ADC $ab,x
AND $ab,x
ASL $ab,x
CMP $ab,x
DEC $ab,x
EOR $ab,x
INC $ab,x
LDA $ab,x
LDY $ab,x
LSR $ab,x
ORA $ab,x
ROR $ab,x
ROL $ab,x
SBC $ab,x
STA $ab,x
STY $ab,x
"""
var zpx_assembled = PackedByteArray([
	0x75, 0xab, 0x35, 0xab, 0x16, 0xab, 0xd5, 0xab, 0xd6, 0xab, 0x55, 0xab, 0xf6, 0xab, 0xb5, 0xab,
	0xb4, 0xab, 0x56, 0xab, 0x15, 0xab, 0x76, 0xab, 0x36, 0xab, 0xf5, 0xab, 0x95, 0xab, 0x94, 0xab
])

const zpy_str = """
LDX $ab,y
STX $ab,y
"""
var zpy_assembled = PackedByteArray([0xb6, 0xab, 0x96, 0xab])


func test_zp_addressing():
	asm.asm_str = zp_str
	var success = asm.assemble()
	assert_eq(success, OK, "tests to make sure the code for testing zero-page addressing assembled with no errors")
	assert_eq(asm.assembled.size(), zp_assembled.size(), "assembled bytecode size")
	assert_eq(asm.assembled, zp_assembled, "testing zero-page addressing")

func test_zpx_addressing():
	asm.asm_str = zpx_str
	var success = asm.assemble()
	assert_eq(success, OK, "tests to make sure the code for testing zero-page,x addressing assembled with no errors")
	assert_eq(asm.assembled.size(), zpx_assembled.size(), "assembled bytecode size")
	assert_eq(asm.assembled, zpx_assembled, "testing zero-page,x addressing")

func test_zpy_addressing():
	asm.asm_str = zpy_str
	var success = asm.assemble()
	assert_eq(success, OK, "tests to make sure the code for testing zero-page,y addressing assembled with no errors")
	assert_eq(asm.assembled.size(), zpy_assembled.size(), "assembled bytecode size")
	assert_eq(asm.assembled, zpy_assembled, "testing zero-page,y addressing")
	