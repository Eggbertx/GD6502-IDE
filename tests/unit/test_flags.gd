extends GutTest

class TestFlags:
	extends GutTest
	
	var cpu := CPU.new()
	var asm := Assembler.new()
	var logger = get_logger()

	func before_each():
		cpu.unload_rom()
		cpu.reset()
	
	func after_all():
		cpu.free()

	func debug_flags():
		logger.debug("A: %02X, X: %02X, Y: %02X, PC: %02X, SP: %02X" % [cpu.A, cpu.X, cpu.Y, cpu.PC, cpu.SP])

	func test_flag_on():
		cpu.set_flag(CPU.flag_bit.OVERFLOW, true)
		assert_true(cpu.get_flag_state(CPU.flag_bit.OVERFLOW), "Expected true, got %s, flags: $%x" % [cpu.get_flag_state(CPU.flag_bit.OVERFLOW), cpu.flags])
		assert_eq(cpu.flags, 0b01000000)

		cpu.set_flag(CPU.flag_bit.BCD, true)
		assert_true(cpu.get_flag_state(CPU.flag_bit.BCD))
		assert_eq(cpu.flags, 0b01001000)

		cpu.set_flag(CPU.flag_bit.OVERFLOW, false)
		assert_false(cpu.get_flag_state(CPU.flag_bit.OVERFLOW))
		assert_eq(cpu.flags, 0b00001000)

	func test_flag_changes():
		asm.asm_str = """
ldy #$82
dey ; $81, negative
dey ; $80
dey ; $7f, positive
iny ; $80, negative
"""
		assert_eq(asm.assemble(), OK, "Successful assembly")
		cpu.load_rom(asm.assembled)
		cpu.execute(true)
		debug_flags()
		assert_eq(cpu.Y, 0x82, "making sure LDY #$82 worked")
		assert_true(cpu.get_flag_state(CPU.flag_bit.NEGATIVE), "making sure negative flag was set")
