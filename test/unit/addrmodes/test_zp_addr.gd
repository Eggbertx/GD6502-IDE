class_name ZeroPageAddressingTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

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
	assert_int(success).is_equal(OK)
	assert_int(asm.assembled.size()).is_equal(zp_assembled.size())
	assert_array(asm.assembled).is_equal(zp_assembled)

func test_zpx_addressing():
	asm.asm_str = zpx_str
	var success = asm.assemble()
	assert_int(success).is_equal(OK)
	assert_int(asm.assembled.size()).is_equal(zpx_assembled.size())
	assert_array(asm.assembled).is_equal(zpx_assembled)

func test_zpy_addressing():
	asm.asm_str = zpy_str
	var success = asm.assemble()
	assert_int(success).is_equal(OK)
	assert_int(asm.assembled.size()).is_equal(zpy_assembled.size())
	assert_array(asm.assembled).is_equal(zpy_assembled)
	