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
; indirect,x => $102
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