# Miscellaneous instruction testing

class_name MiscOpcodesTest
extends GdUnitTestSuite

var nop_assembled = PackedByteArray([
	0xea, 0xea, 0xea, 0xea
])

var cpu = CPU.new()
var asm = Assembler.new()

func before():
	auto_free(cpu)
	auto_free(asm)

func before_test():
	cpu.unload_rom()
	cpu.reset()

func test_nop():
	asm.asm_str = """
nop
nop
nop
nop
"""
	assert_int(asm.assemble()).is_equal(OK)
	assert_int(asm.assembled.size()).is_equal(nop_assembled.size())
	assert_array(asm.assembled).is_equal(nop_assembled)
	cpu.load_rom(asm.assembled)
	cpu.step(4)
	assert_int(cpu.PC).is_equal(cpu.PC_START+4)
