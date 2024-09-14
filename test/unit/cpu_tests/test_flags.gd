class_name FlagsTest
extends CPUTestBase
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

const negative_dec_str := """
ldy #$82
dey ; $81, negative
dey ; $80
dey ; $7f, positive
iny ; $80, negative
"""

const and_str := """
lda #$55
and #$f0
and $0
lda #$55
ldx #$1
"""

var negative_dec_assembled := PackedByteArray([
	0xa0, 0x82, 0x88, 0x88, 0x88, 0xc8 
])

var and_assembled := PackedByteArray([
	0xa9, 0x55, 0x29, 0xf0, 0x25, 0x00, 0xa9, 0x55, 0xa2, 0x01
])

func test_flag_on():
	cpu.set_flag(CPU.flag_bit.OVERFLOW, true)
	assert_flag(CPU.flag_bit.OVERFLOW).is_true()

	cpu.set_flag(CPU.flag_bit.BCD, true)
	assert_flag(CPU.flag_bit.BCD).is_true()

	cpu.set_flag(CPU.flag_bit.OVERFLOW, false)
	assert_flag(CPU.flag_bit.OVERFLOW).is_false()

func test_negative_dec():
	setup_assembly(negative_dec_str, negative_dec_assembled)
	cpu.step()
	assert_int(cpu.Y).is_equal(0x82)
	assert_flag(CPU.flag_bit.NEGATIVE).is_true()
	cpu.step()
	assert_int(cpu.Y).is_equal(0x81)
	assert_flag(CPU.flag_bit.NEGATIVE).is_true()
	cpu.step()
	assert_int(cpu.Y).is_equal(0x80)
	assert_flag(CPU.flag_bit.NEGATIVE).is_true()
	cpu.step()
	assert_int(cpu.Y).is_equal(0x7F)
	assert_flag(CPU.flag_bit.NEGATIVE).is_false()

func test_and():
	setup_assembly(and_str, and_assembled)
	cpu.step()
	assert_int(cpu.A).is_equal(0x55)
	cpu.step()
	assert_int(cpu.A).is_equal(0x50)
	cpu.step()
	assert_int(cpu.A).is_equal(0x00)
