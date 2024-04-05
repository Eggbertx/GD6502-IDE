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

const rts_stack_empty_str := """
jsr lbl
rts

lbl:
rts
"""

const pha_pla_str = """
lda #$4
pha
pha
lda #$0
pla
pla
pla
"""

const txs_tsx_str = """
ldx #$4
txs
ldx #$0
tsx
"""

const php_plp_str := """
lda #$0
php
php
lda #$1
plp
plp
plp
"""

var jsr_assembled := PackedByteArray([
	0x20,  0x04,  0x06, 0x00, 0x00
])

var jsr_stack_filled_assembled := PackedByteArray([
	0x20, 0x00, 0x06
])

var rts_assembled := PackedByteArray([
	0x20, 0x05, 0x06, 0xa9, 0x01, 0xa2, 0x01, 0x60, 0xa0, 0x01 
])

var rts_stack_empty_assembled := PackedByteArray([
	0x20, 0x04, 0x06, 0x60, 0x60 
])

var pha_pla_assembled := PackedByteArray([
	0xa9, 0x04, 0x48, 0x48, 0xa9, 0x00, 0x68, 0x68, 0x68 
])

var txs_tsx_assembled := PackedByteArray([
	0xa2, 0x04, 0x9a, 0xa2, 0x00, 0xba 
])

var php_plp_assembled := PackedByteArray([
	0xa9, 0x00, 0x08, 0x08, 0xa9, 0x01, 0x28, 0x28, 0x28 
])

var asm := Assembler.new()
var cpu := CPU.new()
var filled := false
var emptied := false

func on_filled():
	filled = true

func on_emptied():
	emptied = true

func before():
	auto_free(asm)
	auto_free(cpu)
	cpu.stack_filled.connect(on_filled)
	cpu.stack_emptied.connect(on_emptied)

func before_test():
	filled = false
	emptied = false
	cpu.unload_rom()
	cpu.reset()


func test_jsr():
	asm.asm_str = jsr_str
	assert_int(asm.assemble()).is_equal(OK)
	assert_int(asm.assembled.size()).is_equal(jsr_assembled.size())
	assert_array(asm.assembled).is_equal(jsr_assembled)
	cpu.load_rom(asm.assembled)
	cpu.step()
	assert_int(cpu.memory[0x1ff]).is_equal(0x06)
	assert_int(cpu.memory[0x1fe]).is_equal(0x02)
	assert_int(cpu.PC).is_equal(0x604)

func test_jsr_wrap():
	asm.asm_str = jsr_stack_filled_str
	assert_int(asm.assemble()).is_equal(OK)
	assert_int(asm.assembled.size()).is_equal(jsr_stack_filled_assembled.size())
	assert_array(asm.assembled).is_equal(jsr_stack_filled_assembled)
	cpu.load_rom(asm.assembled)

	cpu.step(127)
	assert_bool(filled).is_false()
	cpu.step()
	assert_bool(filled).is_true()
	
func test_rts():
	asm.asm_str = rts_str
	assert_int(asm.assemble()).is_equal(OK)
	assert_int(asm.assembled.size()).is_equal(rts_assembled.size())
	assert_array(asm.assembled).is_equal(rts_assembled)
	cpu.load_rom(asm.assembled)
	cpu.step()
	assert_int(cpu.PC).is_equal(0x605)
	cpu.step()
	assert_int(cpu.A).is_equal(0)
	assert_int(cpu.X).is_equal(1)
	cpu.step()
	assert_int(cpu.PC).is_equal(0x603)
	assert_int(cpu.memory[0x1ff]).is_equal(0x06)
	assert_int(cpu.memory[0x1fe]).is_equal(0x02)

func test_rts_empty():
	asm.asm_str = rts_stack_empty_str
	assert_int(asm.assemble()).is_equal(OK)
	assert_int(asm.assembled.size()).is_equal(rts_stack_empty_assembled.size())
	assert_array(asm.assembled).is_equal(rts_stack_empty_assembled)
	cpu.load_rom(asm.assembled)
	cpu.step()
	assert_int(cpu.PC).is_equal(0x604)
	cpu.step()
	assert_bool(emptied).is_false()
	cpu.step()
	assert_bool(emptied).is_true()

func test_pha_pla():
	asm.asm_str = pha_pla_str
	assert_int(asm.assemble()).is_equal(OK)
	assert_int(asm.assembled.size()).is_equal(pha_pla_assembled.size())
	assert_array(asm.assembled).is_equal(pha_pla_assembled)
	cpu.load_rom(asm.assembled)
	cpu.step(3)
	assert_int(cpu.A).is_equal(4)
	assert_int(cpu.SP).is_equal(0xfd)
	assert_int(cpu.memory[0x1ff]).is_equal(4)
	assert_int(cpu.memory[0x1fe]).is_equal(4)
	cpu.step()
	assert_int(cpu.A).is_equal(0)
	cpu.step()
	assert_int(cpu.A).is_equal(4)
	assert_int(cpu.SP).is_equal(0xfe)
	cpu.step()
	assert_bool(emptied).is_false()
	cpu.step()
	assert_bool(emptied).is_true()

func test_txs_tsx():
	asm.asm_str = txs_tsx_str
	assert_int(asm.assemble()).is_equal(OK)
	assert_int(asm.assembled.size()).is_equal(txs_tsx_assembled.size())
	assert_array(asm.assembled).is_equal(txs_tsx_assembled)
	cpu.load_rom(asm.assembled)
	cpu.step()
	assert_int(cpu.X).is_equal(4)
	cpu.step()
	assert_int(cpu.SP).is_equal(4)
	cpu.step()
	assert_int(cpu.X).is_equal(0)
	cpu.step()
	assert_int(cpu.X).is_equal(4)

func test_php_plp():
	asm.asm_str = php_plp_str
	assert_int(asm.assemble()).is_equal(OK)
	assert_int(asm.assembled.size()).is_equal(php_plp_assembled.size())
	assert_array(asm.assembled).is_equal(php_plp_assembled)
	cpu.load_rom(asm.assembled)
	cpu.step(3)
	assert_int(cpu.memory[0x1ff]).is_equal(0x32)
	assert_int(cpu.memory[0x1fe]).is_equal(0x32)
	cpu.step()
	assert_bool(cpu.get_flag_state(cpu.flag_bit.ZERO)).is_false()
	cpu.step()
	assert_bool(cpu.get_flag_state(cpu.flag_bit.ZERO)).is_true()
	assert_bool(emptied).is_false()
	cpu.step(2)
	assert_bool(emptied).is_true()
