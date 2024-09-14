class_name CompareOpcodesTest
extends CPUTestBase

const cmp_imm_str = """
lda #$10
cmp #$f
clc
lda #$10
cmp #$10
clc
lda #$10
cmp #$11
"""

const cmp_zp_str = """
lda #$f
sta $aa
lda #$10
sta $ab
lda #$11
sta $ac
lda #$10
cmp $aa
clc
lda #$10
cmp $ab
clc
lda #$10
cmp $ac
"""

const cmp_zpx_str = """
lda #$f
sta $aa
lda #$10
sta $ab
lda #$11
sta $ac
ldx #$0
lda #$10
cmp $aa,x
inx
clc
lda #$10
cmp $aa,x
inx
clc
lda #$10
cmp $aa,x
"""

const cmp_abs_str = """
lda #$f
sta $100
lda #$10
sta $101
lda #$11
sta $102
lda #$10
cmp $100
clc
lda #$10
cmp $101
clc
lda #$10
cmp $102
"""

const cmp_absx_str = """
lda #$f
sta $100
lda #$10
sta $101
lda #$11
sta $102
ldx #$0
lda #$10
cmp $100,x
inx
clc
lda #$10
cmp $100,x
inx
clc
lda #$10
cmp $100,x
"""

const cmp_absy_str = """
lda #$f
sta $100
lda #$10
sta $101
lda #$11
sta $102
ldy #$0
lda #$10
cmp $100,y
iny
clc
lda #$10
cmp $100,y
iny
clc
lda #$10
cmp $100,y
"""

const cmp_indx_str = """
lda #$01
sta $fc
lda #$c1
sta $fb

ldx #$1
lda #$f
sta $1c1
lda #$10
cmp ($fa,x)

ldx #$1
lda #$10
sta $1c1
lda #$10
cmp ($fa,x)

ldx #$1
lda #$11
sta $1c1
lda #$10
cmp ($fa,x)
"""

const cmp_indy_str = """
lda #$01
sta $fb
lda #$c0
sta $fa

ldy #$1
lda #$f
sta $1c1
lda #$10
cmp ($fa),y

ldy #$1
lda #$10
sta $1c1
lda #$10
cmp ($fa),y

ldy #$1
lda #$11
sta $1c1
lda #$10
cmp ($fa),y
"""

const cpx_imm_str = """
ldx #$10
cpx #$f
clc
ldx #$10
cpx #$10
clc
ldx #$10
cpx #$11
"""

const cpx_zp_str = """
ldx #$f
stx $aa
ldx #$10
stx $ab
ldx #$11
stx $ac
ldx #$10
cpx $aa
clc
ldx #$10
cpx $ab
clc
ldx #$10
cpx $ac
"""

const cpx_abs_str = """
ldx #$f
stx $100
ldx #$10
stx $101
ldx #$11
stx $102
ldx #$10
cpx $100
clc
ldx #$10
cpx $101
clc
ldx #$10
cpx $102
"""

const cpy_imm_str = """
ldy #$10
cpy #$f
clc
ldy #$10
cpy #$10
clc
ldy #$10
cpy #$11
"""

const cpy_zp_str = """
ldy #$f
sty $aa
ldy #$10
sty $ab
ldy #$11
sty $ac
ldy #$10
cpy $aa
clc
ldy #$10
cpy $ab
clc
ldy #$10
cpy $ac
"""

const cpy_abs_str = """
ldy #$f
sty $100
ldy #$10
sty $101
ldy #$11
sty $102
ldy #$10
cpy $100
clc
ldy #$10
cpy $101
clc
ldy #$10
cpy $102
"""

var cmp_imm_assembled := PackedByteArray([
	0xa9, 0x10, 0xc9, 0x0f, 0x18, 0xa9, 0x10, 0xc9, 0x10, 0x18, 0xa9, 0x10, 0xc9, 0x11
])

var cmp_zp_assembled := PackedByteArray([
	0xa9, 0x0f, 0x85, 0xaa, 0xa9, 0x10, 0x85, 0xab, 0xa9, 0x11, 0x85, 0xac, 0xa9, 0x10, 0xc5, 0xaa,
	0x18, 0xa9, 0x10, 0xc5, 0xab, 0x18, 0xa9, 0x10, 0xc5, 0xac
])

var cmp_zpx_assembled := PackedByteArray([
	0xa9, 0x0f, 0x85, 0xaa, 0xa9, 0x10, 0x85, 0xab, 0xa9, 0x11, 0x85, 0xac, 0xa2, 0x00, 0xa9, 0x10,
	0xd5, 0xaa, 0xe8, 0x18, 0xa9, 0x10, 0xd5, 0xaa, 0xe8, 0x18, 0xa9, 0x10, 0xd5, 0xaa,
])

var cmp_abs_assembled := PackedByteArray([
	0xa9, 0x0f, 0x8d, 0x00, 0x01, 0xa9, 0x10, 0x8d, 0x01, 0x01, 0xa9, 0x11, 0x8d, 0x02, 0x01, 0xa9,
	0x10, 0xcd, 0x00, 0x01, 0x18, 0xa9, 0x10, 0xcd, 0x01, 0x01, 0x18, 0xa9, 0x10, 0xcd, 0x02, 0x01,
])

var cmp_absx_assembled := PackedByteArray([
	0xa9, 0x0f, 0x8d, 0x00, 0x01, 0xa9, 0x10, 0x8d, 0x01, 0x01, 0xa9, 0x11, 0x8d, 0x02, 0x01, 0xa2,
	0x00, 0xa9, 0x10, 0xdd, 0x00, 0x01, 0xe8, 0x18, 0xa9, 0x10, 0xdd, 0x00, 0x01, 0xe8, 0x18, 0xa9,
	0x10, 0xdd, 0x00, 0x01
])

var cmp_absy_assembled := PackedByteArray([
	0xa9, 0x0f, 0x8d, 0x00, 0x01, 0xa9, 0x10, 0x8d, 0x01, 0x01, 0xa9, 0x11, 0x8d, 0x02, 0x01, 0xa0,
	0x00, 0xa9, 0x10, 0xd9, 0x00, 0x01, 0xc8, 0x18, 0xa9, 0x10, 0xd9, 0x00, 0x01, 0xc8, 0x18, 0xa9,
	0x10, 0xd9, 0x00, 0x01
])

var cmp_indx_assembled := PackedByteArray([
	0xa9, 0x01, 0x85, 0xfc, 0xa9, 0xc1, 0x85, 0xfb, 0xa2, 0x01, 0xa9, 0x0f, 0x8d, 0xc1, 0x01, 0xa9,
	0x10, 0xc1, 0xfa, 0xa2, 0x01, 0xa9, 0x10, 0x8d, 0xc1, 0x01, 0xa9, 0x10, 0xc1, 0xfa, 0xa2, 0x01,
	0xa9, 0x11, 0x8d, 0xc1, 0x01, 0xa9, 0x10, 0xc1, 0xfa
])

var cmp_indy_assembled := PackedByteArray([
	0xa9, 0x01, 0x85, 0xfb, 0xa9, 0xc0, 0x85, 0xfa, 0xa0, 0x01, 0xa9, 0x0f, 0x8d, 0xc1, 0x01, 0xa9,
	0x10, 0xd1, 0xfa, 0xa0, 0x01, 0xa9, 0x10, 0x8d, 0xc1, 0x01, 0xa9, 0x10, 0xd1, 0xfa, 0xa0, 0x01,
	0xa9, 0x11, 0x8d, 0xc1, 0x01, 0xa9, 0x10, 0xd1, 0xfa
])

var cpx_imm_assembled := PackedByteArray([
	0xa2, 0x10, 0xe0, 0x0f, 0x18, 0xa2, 0x10, 0xe0, 0x10, 0x18, 0xa2, 0x10, 0xe0, 0x11
])

var cpx_zp_assembled := PackedByteArray([
	0xa2, 0x0f, 0x86, 0xaa, 0xa2, 0x10, 0x86, 0xab, 0xa2, 0x11, 0x86, 0xac, 0xa2, 0x10, 0xe4, 0xaa,
	0x18, 0xa2, 0x10, 0xe4, 0xab, 0x18, 0xa2, 0x10, 0xe4, 0xac
])

var cpx_abs_assembled := PackedByteArray([
	0xa2, 0x0f, 0x8e, 0x00, 0x01, 0xa2, 0x10, 0x8e, 0x01, 0x01, 0xa2, 0x11, 0x8e, 0x02, 0x01, 0xa2,
	0x10, 0xec, 0x00, 0x01, 0x18, 0xa2, 0x10, 0xec, 0x01, 0x01, 0x18, 0xa2, 0x10, 0xec, 0x02, 0x01
])

var cpy_imm_assembled := PackedByteArray([
	0xa0, 0x10, 0xc0, 0x0f, 0x18, 0xa0, 0x10, 0xc0, 0x10, 0x18, 0xa0, 0x10, 0xc0, 0x11
])

var cpy_zp_assembled := PackedByteArray([
	0xa0, 0x0f, 0x84, 0xaa, 0xa0, 0x10, 0x84, 0xab, 0xa0, 0x11, 0x84, 0xac, 0xa0, 0x10, 0xc4, 0xaa,
	0x18, 0xa0, 0x10, 0xc4, 0xab, 0x18, 0xa0, 0x10, 0xc4, 0xac
])

var cpy_abs_assembled := PackedByteArray([
	0xa0, 0x0f, 0x8c, 0x00, 0x01, 0xa0, 0x10, 0x8c, 0x01, 0x01, 0xa0, 0x11, 0x8c, 0x02, 0x01, 0xa0,
	0x10, 0xcc, 0x00, 0x01, 0x18, 0xa0, 0x10, 0xcc, 0x01, 0x01, 0x18, 0xa0, 0x10, 0xcc, 0x02, 0x01
])

func test_cmp_imm():
	setup_assembly(cmp_imm_str, cmp_imm_assembled)
	cpu.step(2)
	assert_int(cpu.A).is_equal(0x10)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_false()
	cpu.step(3)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_true()
	cpu.step(3)
	assert_bool(cpu.carry_flag).is_false()
	assert_bool(cpu.zero_flag).is_false()

func test_cmp_zp():
	setup_assembly(cmp_zp_str, cmp_zp_assembled)
	cpu.step(8)
	assert_int(cpu.A).is_equal(0x10)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_false()
	cpu.step(3)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_true()
	cpu.step(3)
	assert_bool(cpu.carry_flag).is_false()
	assert_bool(cpu.zero_flag).is_false()

func test_cmp_zpx():
	setup_assembly(cmp_zpx_str, cmp_zpx_assembled)
	cpu.step(9)
	assert_int(cpu.A).is_equal(0x10)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_false()
	cpu.step(4)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_true()
	cpu.step(4)
	assert_bool(cpu.carry_flag).is_false()
	assert_bool(cpu.zero_flag).is_false()

func test_cmp_abs():
	setup_assembly(cmp_abs_str, cmp_abs_assembled)
	cpu.step(8)
	assert_int(cpu.A).is_equal(0x10)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_false()
	cpu.step(3)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_true()
	cpu.step(3)
	assert_bool(cpu.carry_flag).is_false()
	assert_bool(cpu.zero_flag).is_false()

func test_cmp_absx():
	setup_assembly(cmp_absx_str, cmp_absx_assembled)
	cpu.step(9)
	assert_int(cpu.A).is_equal(0x10)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_false()
	cpu.step(4)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_true()
	cpu.step(4)
	assert_bool(cpu.carry_flag).is_false()
	assert_bool(cpu.zero_flag).is_false()

func test_cmp_absy():
	setup_assembly(cmp_absy_str, cmp_absy_assembled)
	cpu.step(9)
	assert_int(cpu.A).is_equal(0x10)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_false()
	cpu.step(4)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_true()
	cpu.step(4)
	assert_bool(cpu.carry_flag).is_false()
	assert_bool(cpu.zero_flag).is_false()

func test_cmp_indx():
	setup_assembly(cmp_indx_str, cmp_indx_assembled)
	cpu.step(8)
	assert_int(cpu.A).is_equal(0x10)
	cpu.step()
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_false()

	cpu.step(4)
	assert_int(cpu.A).is_equal(0x10)
	cpu.step()
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_true()

	cpu.step(4)
	assert_int(cpu.A).is_equal(0x10)
	cpu.step()
	assert_bool(cpu.carry_flag).is_false()
	assert_bool(cpu.zero_flag).is_false()

func test_cmp_indy():
	setup_assembly(cmp_indy_str, cmp_indy_assembled)
	cpu.step(8)
	assert_int(cpu.A).is_equal(0x10)
	cpu.step()
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_false()

	cpu.step(4)
	assert_int(cpu.A).is_equal(0x10)
	cpu.step()
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_true()

	cpu.step(4)
	assert_int(cpu.A).is_equal(0x10)
	cpu.step()
	assert_bool(cpu.carry_flag).is_false()
	assert_bool(cpu.zero_flag).is_false()

func test_cpx_imm():
	setup_assembly(cpx_imm_str, cpx_imm_assembled)
	cpu.step(2)
	assert_int(cpu.X).is_equal(0x10)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_false()
	cpu.step(3)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_true()
	cpu.step(3)
	assert_bool(cpu.carry_flag).is_false()
	assert_bool(cpu.zero_flag).is_false()

func test_cpx_zp():
	setup_assembly(cpx_zp_str, cpx_zp_assembled)
	cpu.step(8)
	assert_int(cpu.X).is_equal(0x10)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_false()
	cpu.step(3)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_true()
	cpu.step(3)
	assert_bool(cpu.carry_flag).is_false()
	assert_bool(cpu.zero_flag).is_false()

func test_cpx_abs():
	setup_assembly(cpx_abs_str, cpx_abs_assembled)
	cpu.step(8)
	assert_int(cpu.X).is_equal(0x10)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_false()
	cpu.step(3)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_true()
	cpu.step(3)
	assert_bool(cpu.carry_flag).is_false()
	assert_bool(cpu.zero_flag).is_false()

func test_cpy_imm():
	setup_assembly(cpy_imm_str, cpy_imm_assembled)
	cpu.step(2)
	assert_int(cpu.Y).is_equal(0x10)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_false()
	cpu.step(3)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_true()
	cpu.step(3)
	assert_bool(cpu.carry_flag).is_false()
	assert_bool(cpu.zero_flag).is_false()

func test_cpy_zp():
	setup_assembly(cpy_zp_str, cpy_zp_assembled)
	cpu.step(8)
	assert_int(cpu.Y).is_equal(0x10)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_false()
	cpu.step(3)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_true()
	cpu.step(3)
	assert_bool(cpu.carry_flag).is_false()
	assert_bool(cpu.zero_flag).is_false()

func test_cpy_abs():
	setup_assembly(cpy_abs_str, cpy_abs_assembled)
	cpu.step(8)
	assert_int(cpu.Y).is_equal(0x10)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_false()
	cpu.step(3)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_true()
	cpu.step(3)
	assert_bool(cpu.carry_flag).is_false()
	assert_bool(cpu.zero_flag).is_false()
