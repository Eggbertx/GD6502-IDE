class_name ArithmeticOpcodesTest
extends CPUTestBase

const adc_imm_str := """
lda #$1
sec
adc #$1
clc
adc #$2
lda #$8
sed
adc #$1
adc #$1
adc #$10
cld
lda #$fd
adc #$1
adc #$1
adc #$1
"""

const adc_zp_str := """
lda #$10
sta $2
lda #$2
sta $1
lda #$1
sta $0
sec
adc $0
clc
adc $1
lda #$8
sed
adc $0
adc $0
adc $2
cld
lda #$fd
adc $0
adc $0
adc $0
"""

const adc_zpx_str := """
lda #$10
sta $3
lda #$2
sta $2
lda #$1
sta $1
ldx #$1
sec
adc $0,x
clc
adc $1,x
lda #$8
sed
adc $0,x
adc $0,x
adc $2,x
cld
lda #$fd
adc $0,x
adc $0,x
adc $0,x
"""

const adc_abs_str := """
lda #$10
sta $102
lda #$2
sta $101
lda #$1
sta $100
sec
adc $100
clc
adc $101
lda #$8
sed
adc $100
adc $100
adc $102
cld
lda #$fd
adc $100
adc $100
adc $100
"""

const adc_absx_str := """
lda #$10
sta $103
lda #$2
sta $102
lda #$1
sta $101
ldx #$1
sec
adc $100,x
clc
adc $101,x
lda #$8
sed
adc $100,x
adc $100,x
adc $102,x
cld
lda #$fd
adc $100,x
adc $100,x
adc $100,x
"""

const adc_absy_str := """
lda #$10
sta $103
lda #$2
sta $102
lda #$1
sta $101
ldy #$1
sec
adc $100,y
clc
adc $101,y
lda #$8
sed
adc $100,y
adc $100,y
adc $102,y
cld
lda #$fd
adc $100,y
adc $100,y
adc $100,y
"""

const adc_indx_str := """
lda #$1
sta $2
lda #$2
sta $1
ldx #$1
ldy #$1
lda #$1
sta $102
sec
adc ($00,x)
clc
lda #$2
sta $102
adc ($00,x)
lda #$8
sta $102
sed
adc ($00,x)
adc ($00,x)
lda #$10
sta $102
adc ($00,x)
cld
lda #$1
sta $102
lda #$fd
adc ($00,x)
adc ($00,x)
adc ($00,x)
"""

const adc_indy_str := """
lda #$1
sta $1
lda #$1
sta $0
ldx #$1
ldy #$1
lda #$1
sta $102
sec
adc ($00),y
clc
lda #$2
sta $102
adc ($00),y
lda #$8
sta $102
sed
adc ($00),y
adc ($00),y
lda #$10
sta $102
adc ($00),y
cld
lda #$1
sta $102
lda #$fd
adc ($00),y
adc ($00),y
adc ($00),y
"""

const dec_zp_str := """
lda #$2
sta $1
dec $1
dec $1
dec $1
"""

const dec_zpx_str := """
lda #$2
sta $2
ldx #$1
dec $1,x
dec $1,x
dec $1,x
"""

const dec_abs_str := """
lda #$2
sta $100
dec $100
dec $100
dec $100
"""

const dec_absx_str := """
lda #$2
sta $101
ldx #$1
dec $100,x
dec $100,x
dec $100,x
"""

const sbc_imm_str = """
lda #$50
cld
sec
sbc #$20

lda #$50
cld
clc
sbc #$20

lda #$50
sed
sec
sbc #$20

lda #$50
sed
clc
sbc #$20
"""

const sbc_zp_str = """
lda #$15
sta $ff

lda #$30
cld
sec
sbc $ff

lda #$30
cld
clc
sbc $ff

lda #$30
sed
sec
sbc $ff

lda #$30
sed
clc
sbc $ff
"""

const sbc_zpx_str = """
lda #$15
sta $fd
ldx #$1

lda #$30
cld
sec
sbc $fc,x

lda #$30
cld
clc
sbc $fc,x

lda #$30
sed
sec
sbc $fc,x

lda #$30
sed
clc
sbc $fc,x
"""

const sbc_abs_str = """
lda #$15
sta $100

lda #$30
cld
sec
sbc $100

lda #$30
cld
clc
sbc $100

lda #$30
sed
sec
sbc $100

lda #$30
sed
clc
sbc $100
"""

const sbc_absx_str = """
lda #$15
sta $1c1
ldx #$1

lda #$30
cld
sec
sbc $1c0,x

lda #$30
cld
clc
sbc $1c0,x

lda #$30
sed
sec
sbc $1c0,x

lda #$30
sed
clc
sbc $1c0,x
"""

const sbc_absy_str = """
lda #$15
sta $1c1
ldy #$1

lda #$30
cld
sec
sbc $1c0,y

lda #$30
cld
clc
sbc $1c0,y

lda #$30
sed
sec
sbc $1c0,y

lda #$30
sed
clc
sbc $1c0,y
"""

const sbc_indx_str = """
lda #$01
sta $fc
lda #$c1
sta $fb

ldx #$1
lda #$15
sta $1c1

lda #$30
cld
sec
sbc ($fa,x)

lda #$30
cld
clc
sbc ($fa,x)

lda #$30
sed
sec
sbc ($fa,x)

lda #$30
sed
clc
sbc ($fa,x)
"""

const sbc_indy_str = """
lda #$01
sta $fb
lda #$c0
sta $fa

ldy #$1
lda #$15
sta $1c1

lda #$30
cld
sec
sbc ($fa),y

lda #$30
cld
clc
sbc ($fa),y

lda #$30
sed
sec
sbc ($fa),y

lda #$30
sed
clc
sbc ($fa),y
"""

var adc_imm_assembled = PackedByteArray([
	0xa9, 0x01, 0x38, 0x69, 0x01, 0x18, 0x69, 0x02, 0xa9, 0x08, 0xf8, 0x69, 0x01, 0x69, 0x01, 0x69,
	0x10, 0xd8, 0xa9, 0xfd, 0x69, 0x01, 0x69, 0x01, 0x69, 0x01 
])

var adc_zp_assembled := PackedByteArray([
	0xa9, 0x10, 0x85, 0x02, 0xa9, 0x02, 0x85, 0x01, 0xa9, 0x01, 0x85, 0x00, 0x38, 0x65, 0x00, 0x18, 
	0x65, 0x01, 0xa9, 0x08, 0xf8, 0x65, 0x00, 0x65, 0x00, 0x65, 0x02, 0xd8, 0xa9, 0xfd, 0x65, 0x00, 
	0x65, 0x00, 0x65, 0x00 
])

var adc_zpx_assembled := PackedByteArray([
	0xa9, 0x10, 0x85, 0x03, 0xa9, 0x02, 0x85, 0x02, 0xa9, 0x01, 0x85, 0x01, 0xa2, 0x01, 0x38, 0x75,
	0x00, 0x18, 0x75, 0x01, 0xa9, 0x08, 0xf8, 0x75, 0x00, 0x75, 0x00, 0x75, 0x02, 0xd8, 0xa9, 0xfd,
	0x75, 0x00, 0x75, 0x00, 0x75, 0x00
])

var adc_abs_assembled := PackedByteArray([
	0xa9, 0x10, 0x8d, 0x02, 0x01, 0xa9, 0x02, 0x8d, 0x01, 0x01, 0xa9, 0x01, 0x8d, 0x00, 0x01, 0x38, 
	0x6d, 0x00, 0x01, 0x18, 0x6d, 0x01, 0x01, 0xa9, 0x08, 0xf8, 0x6d, 0x00, 0x01, 0x6d, 0x00, 0x01, 
	0x6d, 0x02, 0x01, 0xd8, 0xa9, 0xfd, 0x6d, 0x00, 0x01, 0x6d, 0x00, 0x01, 0x6d, 0x00, 0x01 
])

var adc_absx_assembled := PackedByteArray([
	0xa9, 0x10, 0x8d, 0x03, 0x01, 0xa9, 0x02, 0x8d, 0x02, 0x01, 0xa9, 0x01, 0x8d, 0x01, 0x01, 0xa2,
	0x01, 0x38, 0x7d, 0x00, 0x01, 0x18, 0x7d, 0x01, 0x01, 0xa9, 0x08, 0xf8, 0x7d, 0x00, 0x01, 0x7d,
	0x00, 0x01, 0x7d, 0x02, 0x01, 0xd8, 0xa9, 0xfd, 0x7d, 0x00, 0x01, 0x7d, 0x00, 0x01, 0x7d, 0x00,
	0x01
])

var adc_absy_assembled := PackedByteArray([
	0xa9, 0x10, 0x8d, 0x03, 0x01, 0xa9, 0x02, 0x8d, 0x02, 0x01, 0xa9, 0x01, 0x8d, 0x01, 0x01, 0xa0,
	0x01, 0x38, 0x79, 0x00, 0x01, 0x18, 0x79, 0x01, 0x01, 0xa9, 0x08, 0xf8, 0x79, 0x00, 0x01, 0x79,
	0x00, 0x01, 0x79, 0x02, 0x01, 0xd8, 0xa9, 0xfd, 0x79, 0x00, 0x01, 0x79, 0x00, 0x01, 0x79, 0x00,
	0x01
])

var adc_indx_assembled := PackedByteArray([
	0xa9, 0x01, 0x85, 0x02, 0xa9, 0x02, 0x85, 0x01, 0xa2, 0x01, 0xa0, 0x01, 0xa9, 0x01, 0x8d, 0x02,
	0x01, 0x38, 0x61, 0x00, 0x18, 0xa9, 0x02, 0x8d, 0x02, 0x01, 0x61, 0x00, 0xa9, 0x08, 0x8d, 0x02,
	0x01, 0xf8, 0x61, 0x00, 0x61, 0x00, 0xa9, 0x10, 0x8d, 0x02, 0x01, 0x61, 0x00, 0xd8, 0xa9, 0x01,
	0x8d, 0x02, 0x01, 0xa9, 0xfd, 0x61, 0x00, 0x61, 0x00, 0x61, 0x00
])

var adc_indy_assembled := PackedByteArray([
	0xa9, 0x01, 0x85, 0x01, 0xa9, 0x01, 0x85, 0x00, 0xa2, 0x01, 0xa0, 0x01, 0xa9, 0x01, 0x8d, 0x02,
	0x01, 0x38, 0x71, 0x00, 0x18, 0xa9, 0x02, 0x8d, 0x02, 0x01, 0x71, 0x00, 0xa9, 0x08, 0x8d, 0x02,
	0x01, 0xf8, 0x71, 0x00, 0x71, 0x00, 0xa9, 0x10, 0x8d, 0x02, 0x01, 0x71, 0x00, 0xd8, 0xa9, 0x01,
	0x8d, 0x02, 0x01, 0xa9, 0xfd, 0x71, 0x00, 0x71, 0x00, 0x71, 0x00
])

var dec_zp_assembled := PackedByteArray([
	0xa9, 0x02, 0x85, 0x01, 0xc6, 0x01, 0xc6, 0x01, 0xc6, 0x01
])

var dec_zpx_assembled := PackedByteArray([
	0xa9, 0x02, 0x85, 0x02, 0xa2, 0x01, 0xd6, 0x01, 0xd6, 0x01, 0xd6, 0x01
])

var dec_abs_assembled := PackedByteArray([
	0xa9, 0x02, 0x8d, 0x00, 0x01, 0xce, 0x00, 0x01, 0xce, 0x00, 0x01, 0xce, 0x00, 0x01
])

var dec_absx_assembled := PackedByteArray([
	0xa9, 0x02, 0x8d, 0x01, 0x01, 0xa2, 0x01, 0xde, 0x00, 0x01, 0xde, 0x00, 0x01, 0xde, 0x00, 0x01
])

var sbc_imm_assembled := PackedByteArray([
	0xa9, 0x50, 0xd8, 0x38, 0xe9, 0x20, 0xa9, 0x50, 0xd8, 0x18, 0xe9, 0x20, 0xa9, 0x50, 0xf8, 0x38, 
	0xe9, 0x20, 0xa9, 0x50, 0xf8, 0x18, 0xe9, 0x20 
])

var sbc_zp_assembled := PackedByteArray([
	0xa9, 0x15, 0x85, 0xff, 0xa9, 0x30, 0xd8, 0x38, 0xe5, 0xff, 0xa9, 0x30, 0xd8, 0x18, 0xe5, 0xff,
	0xa9, 0x30, 0xf8, 0x38, 0xe5, 0xff, 0xa9, 0x30, 0xf8, 0x18, 0xe5, 0xff
])

var sbc_zpx_assembled := PackedByteArray([
	0xa9, 0x15, 0x85, 0xfd, 0xa2, 0x01, 0xa9, 0x30, 0xd8, 0x38, 0xf5, 0xfc, 0xa9, 0x30, 0xd8, 0x18,
	0xf5, 0xfc, 0xa9, 0x30, 0xf8, 0x38, 0xf5, 0xfc, 0xa9, 0x30, 0xf8, 0x18, 0xf5, 0xfc
])

var sbc_abs_assembled := PackedByteArray([
	0xa9, 0x15, 0x8d, 0x00, 0x01, 0xa9, 0x30, 0xd8, 0x38, 0xed, 0x00, 0x01, 0xa9, 0x30, 0xd8, 0x18,
	0xed, 0x00, 0x01, 0xa9, 0x30, 0xf8, 0x38, 0xed, 0x00, 0x01, 0xa9, 0x30, 0xf8, 0x18, 0xed, 0x00,
	0x01 
])

var sbc_absx_assembled := PackedByteArray([
	0xa9, 0x15, 0x8d, 0xc1, 0x01, 0xa2, 0x01, 0xa9, 0x30, 0xd8, 0x38, 0xfd, 0xc0, 0x01, 0xa9, 0x30,
	0xd8, 0x18, 0xfd, 0xc0, 0x01, 0xa9, 0x30, 0xf8, 0x38, 0xfd, 0xc0, 0x01, 0xa9, 0x30, 0xf8, 0x18,
	0xfd, 0xc0, 0x01
])

var sbc_absy_assembled := PackedByteArray([
	0xa9, 0x15, 0x8d, 0xc1, 0x01, 0xa0, 0x01, 0xa9, 0x30, 0xd8, 0x38, 0xf9, 0xc0, 0x01, 0xa9, 0x30,
	0xd8, 0x18, 0xf9, 0xc0, 0x01, 0xa9, 0x30, 0xf8, 0x38, 0xf9, 0xc0, 0x01, 0xa9, 0x30, 0xf8, 0x18,
	0xf9, 0xc0, 0x01
])

var sbc_indx_assembled := PackedByteArray([
	0xa9, 0x01, 0x85, 0xfc, 0xa9, 0xc1, 0x85, 0xfb, 0xa2, 0x01, 0xa9, 0x15, 0x8d, 0xc1, 0x01, 0xa9,
	0x30, 0xd8, 0x38, 0xe1, 0xfa, 0xa9, 0x30, 0xd8, 0x18, 0xe1, 0xfa, 0xa9, 0x30, 0xf8, 0x38, 0xe1,
	0xfa, 0xa9, 0x30, 0xf8, 0x18, 0xe1, 0xfa
])

var sbc_indy_assembled := PackedByteArray([
	0xa9, 0x01, 0x85, 0xfb, 0xa9, 0xc0, 0x85, 0xfa, 0xa0, 0x01, 0xa9, 0x15, 0x8d, 0xc1, 0x01, 0xa9,
	0x30, 0xd8, 0x38, 0xf1, 0xfa, 0xa9, 0x30, 0xd8, 0x18, 0xf1, 0xfa, 0xa9, 0x30, 0xf8, 0x38, 0xf1,
	0xfa, 0xa9, 0x30, 0xf8, 0x18, 0xf1, 0xfa
])

func test_adc_op():
	# regular (non-decimal) mode
	cpu.A = 1
	cpu.carry_flag = true
	cpu._adc(1)
	assert_int(cpu.A).is_equal(3)
	cpu.carry_flag = false
	cpu._adc(2)
	assert_int(cpu.A).is_equal(5)
	# decimal mode
	cpu.A = 8
	cpu.decimal_flag = true
	cpu._adc(1)
	assert_int(cpu.A).is_equal(9)
	cpu._adc(1)
	assert_int(cpu.A).is_equal(0x10)
	cpu._adc(10)
	assert_int(cpu.A).is_equal(0x20)
	cpu.decimal_flag = false
	cpu.A = 0xFD
	cpu._adc(1)
	assert_int(cpu.A).is_equal(0xFE)
	cpu._adc(1)
	assert_int(cpu.A).is_equal(0xFF)
	cpu._adc(1)
	assert_int(cpu.A).is_equal(0)

func test_adc_imm():
	setup_assembly(adc_imm_str, adc_imm_assembled)
	cpu.step(2)
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(3)
	cpu.step()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(5)
	cpu.step(2)
	assert_bool(cpu.decimal_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(9)
	cpu.step()
	assert_int(cpu.A).is_equal(0x10)
	cpu.step()
	assert_int(cpu.A).is_equal(0x20)
	cpu.step()
	assert_bool(cpu.decimal_flag).is_false()
	cpu.step(2)
	assert_int(cpu.A).is_equal(0xfe)
	cpu.step()
	assert_int(cpu.A).is_equal(0xff)
	cpu.step()
	assert_int(cpu.A).is_equal(0)

func _do_basic_memory_tests(asm_str:String, asm_bytes:PackedByteArray):
	setup_assembly(asm_str, asm_bytes)
	cpu.step(7)
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(3)
	cpu.step()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(5)
	cpu.step(2)
	assert_bool(cpu.decimal_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(9)
	cpu.step()
	assert_int(cpu.A).is_equal(0x10)
	cpu.step()
	assert_int(cpu.A).is_equal(0x20)
	cpu.step()
	assert_bool(cpu.decimal_flag).is_false()
	cpu.step(2)
	assert_int(cpu.A).is_equal(0xfe)
	cpu.step()
	assert_int(cpu.A).is_equal(0xff)
	cpu.step()
	assert_int(cpu.A).is_equal(0)


func test_adc_zp():
	setup_assembly(adc_zp_str, adc_zp_assembled)
	cpu.step(7)
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(3)
	cpu.step()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(5)
	cpu.step(2)
	assert_bool(cpu.decimal_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(9)
	cpu.step()
	assert_int(cpu.A).is_equal(0x10)
	cpu.step()
	assert_int(cpu.A).is_equal(0x20)
	cpu.step()
	assert_bool(cpu.decimal_flag).is_false()
	cpu.step(2)
	assert_int(cpu.A).is_equal(0xfe)
	cpu.step()
	assert_int(cpu.A).is_equal(0xff)
	cpu.step()
	assert_int(cpu.A).is_equal(0)

func test_adc_zpx():
	setup_assembly(adc_zpx_str, adc_zpx_assembled)
	cpu.step(8)
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(3)
	cpu.step()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(5)
	cpu.step(2)
	assert_bool(cpu.decimal_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(9)
	cpu.step()
	assert_int(cpu.A).is_equal(0x10)
	cpu.step()
	assert_int(cpu.A).is_equal(0x20)
	cpu.step()
	assert_bool(cpu.decimal_flag).is_false()
	cpu.step(2)
	assert_int(cpu.A).is_equal(0xfe)
	cpu.step()
	assert_int(cpu.A).is_equal(0xff)
	cpu.step()
	assert_int(cpu.A).is_equal(0)

func test_adc_abs():
	setup_assembly(adc_abs_str, adc_abs_assembled)
	cpu.step(7)
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(3)
	cpu.step()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(5)
	cpu.step(2)
	assert_bool(cpu.decimal_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(9)
	cpu.step()
	assert_int(cpu.A).is_equal(0x10)
	cpu.step()
	assert_int(cpu.A).is_equal(0x20)
	cpu.step()
	assert_bool(cpu.decimal_flag).is_false()
	cpu.step(2)
	assert_int(cpu.A).is_equal(0xfe)
	cpu.step()
	assert_int(cpu.A).is_equal(0xff)
	cpu.step()
	assert_int(cpu.A).is_equal(0)

func test_adc_absx():
	setup_assembly(adc_absx_str, adc_absx_assembled)
	cpu.step(8)
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(3)
	cpu.step()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(5)
	cpu.step(2)
	assert_bool(cpu.decimal_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(9)
	cpu.step()
	assert_int(cpu.A).is_equal(0x10)
	cpu.step()
	assert_int(cpu.A).is_equal(0x20)
	cpu.step()
	assert_bool(cpu.decimal_flag).is_false()
	cpu.step(2)
	assert_int(cpu.A).is_equal(0xfe)
	cpu.step()
	assert_int(cpu.A).is_equal(0xff)
	cpu.step()
	assert_int(cpu.A).is_equal(0)

func test_adc_absy():
	setup_assembly(adc_absy_str, adc_absy_assembled)
	cpu.step(8)
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(3)
	cpu.step()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(5)
	cpu.step(2)
	assert_bool(cpu.decimal_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(9)
	cpu.step()
	assert_int(cpu.A).is_equal(0x10)
	cpu.step()
	assert_int(cpu.A).is_equal(0x20)
	cpu.step()
	assert_bool(cpu.decimal_flag).is_false()
	cpu.step(2)
	assert_int(cpu.A).is_equal(0xfe)
	cpu.step()
	assert_int(cpu.A).is_equal(0xff)
	cpu.step()
	assert_int(cpu.A).is_equal(0)

func test_adc_indx():
	setup_assembly(adc_indx_str, adc_indx_assembled)
	cpu.step(9)
	assert_bool(cpu.carry_flag).is_true()
	assert_int(cpu.A).is_equal(1)
	cpu.step()
	assert_int(cpu.A).is_equal(3)
	cpu.step()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step(3)
	assert_int(cpu.A).is_equal(4)
	cpu.step(3)
	assert_bool(cpu.decimal_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0x16)
	cpu.step()
	assert_int(cpu.A).is_equal(0x24)
	cpu.step(3)
	assert_int(cpu.A).is_equal(0x20)
	cpu.step()
	assert_bool(cpu.decimal_flag).is_false()
	cpu.step(3)
	assert_int(cpu.A).is_equal(0xfd)
	cpu.step()
	assert_int(cpu.A).is_equal(0xfe)
	cpu.step()
	assert_int(cpu.A).is_equal(0xff)
	cpu.step()
	assert_int(cpu.A).is_equal(0)

func test_adc_indy():
	setup_assembly(adc_indy_str, adc_indy_assembled)
	cpu.step(9)
	assert_bool(cpu.carry_flag).is_true()
	assert_int(cpu.A).is_equal(1)
	cpu.step()
	assert_int(cpu.A).is_equal(3)
	cpu.step()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step(3)
	assert_int(cpu.A).is_equal(3)
	cpu.step(3)
	assert_bool(cpu.decimal_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0x9)
	cpu.step()
	assert_int(cpu.A).is_equal(0x10)
	cpu.step(3)
	assert_int(cpu.A).is_equal(0x11)
	cpu.step()
	assert_bool(cpu.decimal_flag).is_false()
	cpu.step(3)
	assert_int(cpu.A).is_equal(0xfd)
	cpu.step()
	assert_int(cpu.A).is_equal(0xfe)
	cpu.step()
	assert_int(cpu.A).is_equal(0xff)
	cpu.step()
	assert_int(cpu.A).is_equal(0)

func test_dec_zp():
	setup_assembly(dec_zp_str, dec_zp_assembled)
	cpu.step(2)
	assert_int(cpu.get_byte(1)).is_equal(0x2)
	cpu.step()
	assert_int(cpu.get_byte(1)).is_equal(0x1)
	cpu.step()
	assert_int(cpu.get_byte(1)).is_equal(0)
	assert_bool(cpu.zero_flag).is_true()
	cpu.step()
	assert_int(cpu.get_byte(1)).is_equal(0xff)
	assert_bool(cpu.zero_flag).is_false()

func test_dec_zpx():
	setup_assembly(dec_zpx_str, dec_zpx_assembled)
	cpu.step(3)
	assert_int(cpu.get_byte(2)).is_equal(0x2)
	cpu.step()
	assert_int(cpu.get_byte(2)).is_equal(0x1)
	cpu.step()
	assert_int(cpu.get_byte(2)).is_equal(0)
	assert_bool(cpu.zero_flag).is_true()
	cpu.step()
	assert_int(cpu.get_byte(2)).is_equal(0xff)
	assert_bool(cpu.zero_flag).is_false()

func test_dec_abs():
	setup_assembly(dec_abs_str, dec_abs_assembled)
	cpu.step(2)
	assert_int(cpu.get_byte(0x100)).is_equal(0x2)
	cpu.step()
	assert_int(cpu.get_byte(0x100)).is_equal(0x1)
	cpu.step()
	assert_int(cpu.get_byte(0x100)).is_equal(0)
	assert_bool(cpu.zero_flag).is_true()
	cpu.step()
	assert_int(cpu.get_byte(0x100)).is_equal(0xff)
	assert_bool(cpu.zero_flag).is_false()

func test_dec_absx():
	setup_assembly(dec_absx_str, dec_absx_assembled)
	cpu.step(3)
	assert_int(cpu.get_byte(0x101)).is_equal(0x2)
	cpu.step()
	assert_int(cpu.get_byte(0x101)).is_equal(0x1)
	cpu.step()
	assert_int(cpu.get_byte(0x101)).is_equal(0)
	assert_bool(cpu.zero_flag).is_true()
	cpu.step()
	assert_int(cpu.get_byte(0x101)).is_equal(0xff)
	assert_bool(cpu.zero_flag).is_false()

func test_sbc_imm():
	setup_assembly(sbc_imm_str, sbc_imm_assembled)
	cpu.step()
	assert_int(cpu.A).is_equal(0x50)
	cpu.step(2)
	assert_bool(cpu.decimal_flag).is_false()
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0x30)

	cpu.step()
	assert_int(cpu.A).is_equal(0x50)
	cpu.step(2)
	assert_bool(cpu.decimal_flag).is_false()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(0x2F)

	cpu.step()
	assert_int(cpu.A).is_equal(0x50)
	cpu.step(2)
	assert_bool(cpu.decimal_flag).is_true()
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0x30)
	
	cpu.step()
	assert_int(cpu.A).is_equal(0x50)
	cpu.step(2)
	assert_bool(cpu.decimal_flag).is_true()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(0x29)

func test_sbc_zp():
	setup_assembly(sbc_zp_str, sbc_zp_assembled)
	cpu.step(5)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_false()
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0x1b)

	cpu.step(3)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_false()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(0x1a)

	cpu.step(3)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_true()
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0x15)

	cpu.step(3)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_true()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(0x14)

func test_sbc_zpx():
	setup_assembly(sbc_zpx_str, sbc_zpx_assembled)
	cpu.step(6)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_false()
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0x1b)

	cpu.step(3)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_false()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(0x1a)

	cpu.step(3)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_true()
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0x15)

	cpu.step(3)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_true()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(0x14)

func test_sbc_abs():
	setup_assembly(sbc_abs_str, sbc_abs_assembled)
	cpu.step(5)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_false()
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0x1b)

	cpu.step(3)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_false()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(0x1a)

	cpu.step(3)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_true()
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0x15)

	cpu.step(3)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_true()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(0x14)

func test_sbc_absx():
	setup_assembly(sbc_absx_str, sbc_absx_assembled)
	cpu.step(6)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_false()
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0x1b)

	cpu.step(3)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_false()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(0x1a)

	cpu.step(3)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_true()
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0x15)

	cpu.step(3)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_true()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(0x14)

func test_sbc_absy():
	setup_assembly(sbc_absy_str, sbc_absy_assembled)
	cpu.step(6)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_false()
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0x1b)

	cpu.step(3)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_false()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(0x1a)

	cpu.step(3)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_true()
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0x15)

	cpu.step(3)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_true()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(0x14)

func test_sbc_indx():
	setup_assembly(sbc_indx_str, sbc_indx_assembled)
	cpu.step(10)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_false()
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0x1b)

	cpu.step(3)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_false()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(0x1a)

	cpu.step(3)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_true()
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0x15)

	cpu.step(3)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_true()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(0x14)


func test_sbc_indy():
	setup_assembly(sbc_indy_str, sbc_indy_assembled)
	cpu.step(10)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_false()
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0x1b)

	cpu.step(3)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_false()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(0x1a)

	cpu.step(3)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_true()
	assert_bool(cpu.carry_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0x15)

	cpu.step(3)
	assert_int(cpu.A).is_equal(0x30)
	assert_bool(cpu.decimal_flag).is_true()
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(0x14)
