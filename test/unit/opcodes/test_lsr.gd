# Testing LSR instruction

class_name LSRTest
extends GdUnitTestSuite

var lsr_accum_assembled = PackedByteArray([
	0xa9, 0x84, 0x4a, 0x4a, 0x4a, 0x4a, 0x4a
])

var cpu := CPU.new()
var asm := Assembler.new()

func before():
	auto_free(cpu)
	auto_free(asm)

func before_test():
	cpu.unload_rom()
	cpu.reset()

func test_lsr_accumulator():
	asm.asm_str = """
lda #$84
lsr
lsr
lsr
lsr
lsr
"""
	assert_int(asm.assemble()).is_equal(OK)
	assert_int(asm.assembled.size()).is_equal(lsr_accum_assembled.size())
	assert_array(asm.assembled).is_equal(lsr_accum_assembled)
	cpu.load_rom(asm.assembled)
	cpu.step()
	assert_int(cpu.A).is_equal(132)
	cpu.step()
	assert_int(cpu.A).is_equal(66)
	cpu.step()
	assert_int(cpu.A).is_equal(33)
	cpu.step()
	assert_int(cpu.A).is_equal(144)
	cpu.step()
	assert_int(cpu.A).is_equal(72)
	cpu.step()
	assert_int(cpu.A).is_equal(36)
