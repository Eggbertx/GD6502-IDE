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

var lsr_accum_assembled := PackedByteArray([
	0xa9, 0x84, 0x4a, 0x4a, 0x4a, 0x4a, 0x4a
])

var lsr_zp_assembled := PackedByteArray([
	0xa9, 0x84, 0x85, 0x42, 0x46, 0x42, 0x46, 0x42, 0x46, 0x42, 0x46, 0x42, 0x46, 0x42
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
