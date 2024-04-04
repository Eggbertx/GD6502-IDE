class_name StackTest
extends GdUnitTestSuite

const jsr_str := """
jsr lbl
brk

lbl:
brk
"""

const jsr_stack_filled_str := """
lbl:
jsr lbl
"""

const rts_str := """
jsr lbl
lda #$1

lbl:
ldx #$1
rts
ldy #$1
"""

var jsr_assembled := PackedByteArray([
	0x20,  0x04,  0x06, 0x00, 00
])

var jsr_stack_filled_assembled := PackedByteArray([
	0x20, 0x00, 0x06
])


var asm := Assembler.new()
var cpu := CPU.new()
var filled := false

func on_filled():
	filled = true

func before():
	auto_free(asm)
	auto_free(cpu)
	cpu.stack_filled.connect(on_filled)

func before_test():
	filled = false
	cpu.unload_rom()
	cpu.reset()


func test_jsr():
	asm.asm_str = jsr_str
	assert_int(asm.assemble()).is_equal(OK)
	assert_int(asm.assembled.size()).is_equal(jsr_assembled.size())
	assert_array(asm.assembled).is_equal(jsr_assembled)
	cpu.load_rom(jsr_assembled)
	cpu.step()
	assert_int(cpu.memory[0x1ff]).is_equal(0x06)
	assert_int(cpu.memory[0x1fe]).is_equal(0x05)
	assert_int(cpu.PC).is_equal(0x604)

func test_jsr_wrap():
	asm.asm_str = jsr_stack_filled_str
	assert_int(asm.assemble()).is_equal(OK)
	assert_int(asm.assembled.size()).is_equal(jsr_stack_filled_assembled.size())
	assert_array(asm.assembled).is_equal(jsr_stack_filled_assembled)
	cpu.load_rom(jsr_stack_filled_assembled)

	cpu.step(128)
	assert_bool(filled).is_false()
	cpu.step(1)
	assert_bool(filled).is_true()
