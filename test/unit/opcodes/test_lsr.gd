# Testing LSR instruction

class_name LSRTest
extends CPUTestBase

const lsr_accum_str := """
lda #$84
lsr
lsr
lsr
lsr
lsr
"""

const lsr_zp_str := """
lda #$84
sta $42
lsr $42
lsr $42
lsr $42
lsr $42
lsr $42
"""

const lsr_accum_carry_str := """
lda #$3
lsr
lsr
lsr
"""

const lsr_zp_carry_str := """
lda #$3
sta $1
lsr $1
lsr $1
lsr $1
"""

var lsr_accum_assembled := PackedByteArray([
	0xa9, 0x84, 0x4a, 0x4a, 0x4a, 0x4a, 0x4a
])

var lsr_zp_assembled := PackedByteArray([
	0xa9, 0x84, 0x85, 0x42, 0x46, 0x42, 0x46, 0x42, 0x46, 0x42, 0x46, 0x42, 0x46, 0x42
])

var lsr_accum_carry_assembled := PackedByteArray([
	0xa9, 0x03, 0x4a, 0x4a, 0x4a 
])

var lsr_zp_carry_assembled := PackedByteArray([
	0xa9, 0x03, 0x85, 0x01, 0x46, 0x01, 0x46, 0x01, 0x46, 0x01 
])

func test_lsr_accumulator():
	setup_assembly(lsr_accum_str, lsr_accum_assembled)
	cpu.step()
	assert_int(cpu.A).is_equal(0x84)
	cpu.step()
	assert_int(cpu.A).is_equal(0x42)
	cpu.step()
	assert_int(cpu.A).is_equal(0x21)
	cpu.step()
	assert_int(cpu.A).is_equal(0x10)
	cpu.step()
	assert_int(cpu.A).is_equal(0x8)
	cpu.step()
	assert_int(cpu.A).is_equal(0x4)

func test_lsr_zp():
	setup_assembly(lsr_zp_str, lsr_zp_assembled)
	cpu.step(2)
	assert_int(cpu.get_byte(0x42)).is_equal(0x84)
	cpu.step()
	assert_int(cpu.get_byte(0x42)).is_equal(0x42)
	cpu.step()
	assert_int(cpu.get_byte(0x42)).is_equal(0x21)
	cpu.step()
	assert_int(cpu.get_byte(0x42)).is_equal(0x10)
	cpu.step()
	assert_int(cpu.get_byte(0x42)).is_equal(0x8)
	cpu.step()
	assert_int(cpu.get_byte(0x42)).is_equal(0x4)

func test_lsr_accum_carry():
	setup_assembly(lsr_accum_carry_str, lsr_accum_carry_assembled)
	cpu.set_flag(CPU.flag_bit.CARRY, false)
	cpu.step()
	assert_int(cpu.A).is_equal(0x3)
	cpu.step()
	assert_flag(CPU.flag_bit.CARRY).is_true()
	cpu.step()
	assert_flag(CPU.flag_bit.CARRY).is_true()
	cpu.step()
	assert_flag(CPU.flag_bit.CARRY).is_false()
	assert_flag(CPU.flag_bit.ZERO).is_true()

func test_lsr_zp_carry():
	setup_assembly(lsr_zp_carry_str, lsr_zp_carry_assembled)
	cpu.set_flag(CPU.flag_bit.CARRY, false)
	cpu.step(2)
	assert_int(cpu.get_byte(0x1)).is_equal(0x3)
	cpu.step()
	assert_flag(CPU.flag_bit.CARRY).is_true()
	cpu.step()
	assert_flag(CPU.flag_bit.CARRY).is_true()
	cpu.step()
	assert_flag(CPU.flag_bit.CARRY).is_false()
	assert_flag(CPU.flag_bit.ZERO).is_true()
