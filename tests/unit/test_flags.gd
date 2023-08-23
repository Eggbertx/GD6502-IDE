extends "res://addons/gut/test.gd"

var cpu := CPU.new()

func test_flag_on():
	cpu.flags = 0b000000

	cpu.set_flag(CPU.flag_bit.OVERFLOW, true)
	assert_true(cpu.get_flag_state(CPU.flag_bit.OVERFLOW), "Expected true, got %s, flags: $%x" % [cpu.get_flag_state(CPU.flag_bit.OVERFLOW), cpu.flags])
	assert_eq(cpu.flags, 0b01000000)

	cpu.set_flag(CPU.flag_bit.BCD, true)
	assert_true(cpu.get_flag_state(CPU.flag_bit.BCD))
	assert_eq(cpu.flags, 0b01001000)

	cpu.set_flag(CPU.flag_bit.OVERFLOW, false)
	assert_false(cpu.get_flag_state(CPU.flag_bit.OVERFLOW))
	assert_eq(cpu.flags, 0b00001000)
	cpu.free()