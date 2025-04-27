# Testing LDA, LDX, and LDY instructions

class_name LDAXYTest
extends CPUTestBase
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

const lda_str := """
lda #$44
lda $44
ldx #$1
lda $44,X
lda $0123
lda $0123,X
lda $0123,Y
lda ($44,X)
lda ($44),Y
"""

var lda_assembled := PackedByteArray([
	0xa9, 0x44, 0xa5, 0x44, 0xa2, 0x01, 0xb5, 0x44, 0xad, 0x23, 0x01, 0xbd, 0x23, 0x01, 0xb9, 0x23,
	0x01, 0xa1, 0x44, 0xb1, 0x44 
])

func test_lda():
	setup_assembly(lda_str, lda_assembled)

	# load values for testing into memory manually since it's easier than a bunch of STr calls,
	# even if it's a bit hacky
	cpu.memory[0x44] = 0x01
	cpu.memory[0x45] = 0x02
	cpu.memory[0x46] = 0x03
	cpu.memory[0x0123] = 0x04

	assert_int(cpu.A).is_zero()
	assert_int(cpu.X).is_zero()
	cpu.step()
	assert_int(cpu.A).is_equal(0x44)
	cpu.step()
	assert_int(cpu.A).is_equal(0x1)
	cpu.step()
	assert_int(cpu.X).is_equal(0x01)
	cpu.step()
	assert_int(cpu.A).is_equal(0x02)
	cpu.step()
	assert_int(cpu.A).is_equal(0x04)
