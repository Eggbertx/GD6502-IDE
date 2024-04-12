# Miscellaneous instruction testing

class_name MiscOpcodesTest
extends CPUTestBase

const nop_str := """
nop
nop
nop
nop
"""

var nop_assembled := PackedByteArray([
	0xea, 0xea, 0xea, 0xea
])

func test_nop():
	setup_assembly(nop_str, nop_assembled)
	cpu.step(4)
	assert_int(cpu.PC).is_equal(cpu.pc_start+4)
