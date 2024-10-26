class_name CPUTestBase
extends GdUnitTestSuite

var cpu := ExampleCPUSubclass.new()
var asm := Assembler.new()

func before():
	asm.logger = StringLogger.new()
	auto_free(cpu)
	auto_free(asm)

func before_test():
	cpu.unload_rom()
	cpu.reset()

## setup_assembly loads the assembly string into the assembler, assembles it, and asserts that the assembly succeeded. It then
## asserts that the assembled bytecode was expected, and loads it into the CPU
func setup_assembly(asm_str: String, expect_bytes: PackedByteArray):
	asm.asm_str = asm_str
	assert_int(asm.assemble()).is_equal(OK)
	assert_int(asm.assembled.size()).is_equal(expect_bytes.size())
	assert_array(asm.assembled).is_equal(expect_bytes)
	cpu.load_rom(asm.assembled)


## assert_flag tests the CPU flag state
func assert_flag(flag: CPU.flag_bit) -> GdUnitBoolAssert:
	return assert_bool(cpu.get_flag_state(flag))


func debug_flags():
	print_debug("A: %02X, X: %02X, Y: %02X, PC: %02X, SP: %02X" % [cpu.A, cpu.X, cpu.Y, cpu.PC, cpu.SP])
