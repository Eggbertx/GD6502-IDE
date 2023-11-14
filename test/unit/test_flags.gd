class_name FlagsTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

var cpu := CPU.new()
var asm := Assembler.new()

func before():
	auto_free(cpu)
	auto_free(asm)

func before_test():
	cpu.unload_rom()
	cpu.reset()

func debug_flags():
	print_debug("A: %02X, X: %02X, Y: %02X, PC: %02X, SP: %02X" % [cpu.A, cpu.X, cpu.Y, cpu.PC, cpu.SP])

func test_flag_on():
	cpu.set_flag(CPU.flag_bit.OVERFLOW, true)
	assert_bool(cpu.get_flag_state(CPU.flag_bit.OVERFLOW)).is_true()
	assert_int(cpu.flags).is_equal(0b01000000)

	cpu.set_flag(CPU.flag_bit.BCD, true)
	assert_bool(cpu.get_flag_state(CPU.flag_bit.BCD)).is_true()
	assert_int(cpu.flags).is_equal(0b01001000)

	cpu.set_flag(CPU.flag_bit.OVERFLOW, false)
	assert_bool(cpu.get_flag_state(CPU.flag_bit.OVERFLOW)).is_false()
	assert_int(cpu.flags).is_equal(0b00001000)

func test_negative_dec():
	asm.asm_str = """
ldy #$82
dey ; $81, negative
dey ; $80
dey ; $7f, positive
iny ; $80, negative
"""
	assert_int(asm.assemble()).is_equal(OK)
	cpu.load_rom(asm.assembled)
	cpu.execute(true)
	assert_int(cpu.Y).is_equal(0x82)
	assert_bool(cpu.get_flag_state(CPU.flag_bit.NEGATIVE)).is_true()
	cpu.execute(true)
	assert_int(cpu.Y).is_equal(0x81)
	assert_bool(cpu.get_flag_state(CPU.flag_bit.NEGATIVE)).is_true()
	cpu.execute(true)
	assert_int(cpu.Y).is_equal(0x80)
	assert_bool(cpu.get_flag_state(CPU.flag_bit.NEGATIVE)).is_true()
	cpu.execute(true)
	assert_int(cpu.Y).is_equal(0x7F)
	assert_bool(cpu.get_flag_state(CPU.flag_bit.NEGATIVE)).is_false()

func test_and():
	asm.asm_str = """
lda #$55
and #$f0
and $0
lda #$55
ldx #$1
"""
	assert_int(asm.assemble()).is_equal(OK)
	cpu.load_rom(asm.assembled)
	cpu.execute(true)
	assert_int(cpu.A).is_equal(0x55)
	cpu.execute(true)
	assert_int(cpu.A).is_equal(0x50)
	cpu.execute(true)
	assert_int(cpu.A).is_equal(0x00)
