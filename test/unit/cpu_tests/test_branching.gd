class_name BranchingTest
extends CPUTestBase

const beq_label_after_str = """
ldx #$01
beq loop
dex
beq loop
jmp $600
loop:
nop
"""

const beq_label_before_str = """
jmp main

loop:
ldy #$ab
jmp loop

main:
ldx #$2
beq loop
dex
beq loop
dex
beq loop

loop2:
ldy #$12
jmp loop2
"""

const bne_str = """
ldx #$0
bne loop
inx
bne loop
lda #$2
loop:
lda #$1
jmp loop
"""

const bcc_str = """
sec
bcc loop
clc
bcc loop
jmp $600
loop:
lda #$01
jmp loop
"""

const bcs_str = """
clc
bcs loop
sec
bcs loop
jmp $600
loop:
lda #$01
jmp loop
"""

var beq_label_after_assembled := PackedByteArray([
	0xa2, 0x01, 0xf0, 0x06, 0xca, 0xf0, 0x03, 0x4c, 0x00, 0x06, 0xea
])

var beq_label_before_assembled := PackedByteArray([
	0x4c, 0x08, 0x06, 0xa0, 0xab, 0x4c, 0x03, 0x06, 0xa2, 0x02, 0xf0, 0xf7, 0xca, 0xf0, 0xf4, 0xca,
	0xf0, 0xf1, 0xa0, 0x12, 0x4c, 0x12, 0x06
])

var bne_assembled := PackedByteArray([
	0xa2, 0x00, 0xd0, 0x05, 0xe8, 0xd0, 0x02, 0xa9, 0x02, 0xa9, 0x01, 0x4c, 0x09, 0x06
])

var bcc_assembled := PackedByteArray([
	0x38, 0x90, 0x06, 0x18, 0x90, 0x03, 0x4c, 0x00, 0x06, 0xa9, 0x01, 0x4c, 0x09, 0x06
])

var bcs_assembled := PackedByteArray([
	0x18, 0xb0, 0x06, 0x38, 0xb0, 0x03, 0x4c, 0x00, 0x06, 0xa9, 0x01, 0x4c, 0x09, 0x06
])

func test_beq_label_after():
	setup_assembly(beq_label_after_str, beq_label_after_assembled)
	assert_int(cpu.PC).is_equal(0x600)
	cpu.step()
	assert_int(cpu.PC).is_equal(0x602)
	cpu.step()
	assert_int(cpu.PC).is_equal(0x604)
	cpu.step()
	assert_int(cpu.PC).is_equal(0x605)
	cpu.step()
	assert_int(cpu.PC).is_equal(0x60a)

func test_beq_label_before():
	setup_assembly(beq_label_before_str, beq_label_before_assembled)
	cpu.step(2)
	assert_int(cpu.PC).is_equal(0x60a)
	assert_int(cpu.X).is_equal(0x02)
	cpu.step()
	assert_int(cpu.PC).is_equal(0x60c)
	cpu.step()
	assert_int(cpu.X).is_equal(0x01)
	cpu.step()
	assert_int(cpu.PC).is_equal(0x60f)
	cpu.step()
	assert_bool(cpu.zero_flag).is_true()
	cpu.step()
	assert_int(cpu.PC).is_equal(0x603)

func test_bne():
	setup_assembly(bne_str, bne_assembled)
	cpu.step(2)
	assert_bool(cpu.zero_flag).is_true()
	cpu.step()
	assert_bool(cpu.zero_flag).is_false()
	cpu.step(2)
	assert_int(cpu.PC).is_equal(0x60b)
	cpu.step()
	assert_int(cpu.A).is_equal(0x01)

func test_bcc():
	setup_assembly(bcc_str, bcc_assembled)
	cpu.step(2)
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step(2)
	assert_int(cpu.PC).is_equal(0x60b)
	cpu.step()
	assert_int(cpu.A).is_equal(0x01)

func test_bcs():
	setup_assembly(bcs_str, bcs_assembled)
	cpu.step(2)
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_bool(cpu.carry_flag).is_true()
	cpu.step(2)
	assert_int(cpu.PC).is_equal(0x60b)
	cpu.step()
	assert_int(cpu.A).is_equal(0x01)
