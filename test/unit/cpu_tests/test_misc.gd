# Miscellaneous instruction testing

class_name MiscOpcodesTest
extends CPUTestBase

const nop_str := """
nop
nop
nop
nop
"""

const jmp_ind_str := """
lda #$6
sta $101
jmp ($100)
"""

var nop_assembled := PackedByteArray([
	0xea, 0xea, 0xea, 0xea
])

var jmp_ind_assembled := PackedByteArray([
	0xa9, 0x06, 0x8d, 0x01, 0x01, 0x6c, 0x00, 0x01
])

func test_nop():
	setup_assembly(nop_str, nop_assembled)
	cpu.step(4)
	assert_int(cpu.PC).is_equal(cpu.pc_start+4)

func test_jmp_ind():
	setup_assembly(jmp_ind_str, jmp_ind_assembled)
	cpu.step(2)
	assert_int(cpu.A).is_equal(6)
	cpu.step()
	assert_int(cpu.PC).is_equal(0x600)
