class_name BitwiseOpcodesTest
extends CPUTestBase

const and_str = """
lda #$55
and #$0f

lda #$aa
sta $03
lda #$55
and #$0f

ldx #$1
ldy #$1
lda #$0e
sta $01
lda #$f0
sta $aa
lda #$0f
and $12

lda #$aa
and $00,x

lda #$aa
sta $03
and ($02,x)

lda #$11
sta $a
and ($a),y
"""

const asl_accum_str := """
lda #$1
asl
lda #$80
asl
lda #$7f
asl
"""

const asl_zp_str := """
lda #$1
sta $1
asl $1
lda #$80
sta $1
asl $1
lda #$7f
sta $1
asl $1
"""

const asl_zpx_str := """
lda #$1
ldx #$1
sta $2
asl $1,x
lda #$80
sta $2
asl $1,x
lda #$7f
sta $2
asl $1,x
"""

const asl_abs_str := """
lda #$1
sta $200
asl $200
lda #$80
sta $200
asl $200
lda #$7f
sta $200
asl $200
"""

const asl_absx_str := """
lda #$1
ldx #$1
sta $201
asl $200,x
lda #$80
sta $201
asl $200,x
lda #$7f
sta $201
asl $200,x
"""

const lsr_accum_str := """
lda #$84
lsr
lsr
lsr
lsr
lsr
"""

const lsr_zp_str := """
lda #$84
sta $42
lsr $42
lsr $42
lsr $42
lsr $42
lsr $42
"""

const lsr_accum_carry_str := """
lda #$3
lsr
lsr
lsr
"""

const lsr_zp_carry_str := """
lda #$3
sta $1
lsr $1
lsr $1
lsr $1
"""

const ora_str := """
lda #$55

ora #$aa   ; A = #$55 | #$AA = #$ff

lda #$33
sta $10
lda #$0f
ora $10    ; A = #$0f | #$33 = #$3f

lda #$22
sta $10,x
lda #$11
ora $10,x  ; A = #$11 | #$22 = #$33

lda #$44
sta $0200
lda #$11
ora $0200  ; A = #$11 | #$44 = #$55

lda #$66
sta $0200,x
lda #$11
ora $0200,x; A = #$11 | #$66 = #$77

lda #$88
sta $0200,y
lda #$11
ora $0200,y ; A = #$11 | #$88 = #$99

lda #$55
sta $10
lda #$00
sta $11
lda #$11
ora ($10,x)  ; A = #$11 | #$55 = #$55

lda #$44
sta $20
lda #$00
sta $21
lda #$11
ora ($20),y; A = #$11 | #$44 = #$55
"""

const bit_str := """
; zero-page addressing
lda #$80
sta $10
lda #$0 ; clears N flag
bit $10 ; sets N flag
sta $10
lda #$80
bit $10 ; clear N flag
lda #$40
sta $10
lda #$0
bit $10 ; sets V flag
lda #$c0
sta $10
lda #$0
bit $10 ; sets N, V
lda #$0
sta $10
lda #$1
bit $10 ; sets Z to 0

; absolute addressing
lda #$80
sta $100
lda #$0 ; clears N flag
bit $100 ; sets N flag
sta $100
lda #$80
bit $100 ; clear N flag
lda #$40
sta $100
lda #$0
bit $100 ; sets V flag
lda #$c0
sta $100
lda #$0
bit $100 ; sets N, V
lda #$0
sta $100
lda #$1
bit $100 ; sets Z to 0
"""

var and_assembled := PackedByteArray([
	0xa9, 0x55, 0x29, 0x0f, 0xa9, 0xaa, 0x85, 0x03, 0xa9, 0x55, 0x29, 0x0f, 0xa2, 0x01, 0xa0, 0x01, 
	0xa9, 0x0e, 0x85, 0x01, 0xa9, 0xf0, 0x85, 0xaa, 0xa9, 0x0f, 0x25, 0x12, 0xa9, 0xaa, 0x35, 0x00, 
	0xa9, 0xaa, 0x85, 0x03, 0x21, 0x02, 0xa9, 0x11, 0x85, 0x0a, 0x31, 0x0a 
])

var asl_accum_assembled := PackedByteArray([
	0xa9, 0x01, 0x0a, 0xa9, 0x80, 0x0a, 0xa9, 0x7f, 0x0a 
])

var asl_zp_assembled := PackedByteArray([
	0xa9, 0x01, 0x85, 0x01, 0x06, 0x01, 0xa9, 0x80, 0x85, 0x01, 0x06, 0x01, 0xa9, 0x7f, 0x85, 0x01, 
	0x06, 0x01 
])

var asl_zpx_assembled := PackedByteArray([
	0xa9, 0x01, 0xa2, 0x01, 0x85, 0x02, 0x16, 0x01, 0xa9, 0x80, 0x85, 0x02, 0x16, 0x01, 0xa9, 0x7f,
	0x85, 0x02, 0x16, 0x01
])

var asl_abs_assembled := PackedByteArray([
	0xa9, 0x01, 0x8d, 0x00, 0x02, 0x0e, 0x00, 0x02, 0xa9, 0x80, 0x8d, 0x00, 0x02, 0x0e, 0x00, 0x02,
	0xa9, 0x7f, 0x8d, 0x00, 0x02, 0x0e, 0x00, 0x02
])

var asl_absx_assembled := PackedByteArray([
	0xa9, 0x01, 0xa2, 0x01, 0x8d, 0x01, 0x02, 0x1e, 0x00, 0x02, 0xa9, 0x80, 0x8d, 0x01, 0x02, 0x1e,
	0x00, 0x02, 0xa9, 0x7f, 0x8d, 0x01, 0x02, 0x1e, 0x00, 0x02
])

var lsr_accum_assembled := PackedByteArray([
	0xa9, 0x84, 0x4a, 0x4a, 0x4a, 0x4a, 0x4a
])

var lsr_zp_assembled := PackedByteArray([
	0xa9, 0x84, 0x85, 0x42, 0x46, 0x42, 0x46, 0x42, 0x46, 0x42, 0x46, 0x42, 0x46, 0x42
])

var lsr_accum_carry_assembled := PackedByteArray([
	0xa9, 0x03, 0x4a, 0x4a, 0x4a 
])

var lsr_zp_carry_assembled := PackedByteArray([
	0xa9, 0x03, 0x85, 0x01, 0x46, 0x01, 0x46, 0x01, 0x46, 0x01 
])


var ora_assembled := PackedByteArray([
	0xa9, 0x55, 0x09, 0xaa, 0xa9, 0x33, 0x85, 0x10, 0xa9, 0x0f, 0x05, 0x10, 0xa9, 0x22, 0x95, 0x10,
	0xa9, 0x11, 0x15, 0x10, 0xa9, 0x44, 0x8d, 0x00, 0x02, 0xa9, 0x11, 0x0d, 0x00, 0x02, 0xa9, 0x66,
	0x9d, 0x00, 0x02, 0xa9, 0x11, 0x1d, 0x00, 0x02, 0xa9, 0x88, 0x99, 0x00, 0x02, 0xa9, 0x11, 0x19,
	0x00, 0x02, 0xa9, 0x55, 0x85, 0x10, 0xa9, 0x00, 0x85, 0x11, 0xa9, 0x11, 0x01, 0x10, 0xa9, 0x44,
	0x85, 0x20, 0xa9, 0x00, 0x85, 0x21, 0xa9, 0x11, 0x11, 0x20
])

var bit_assembled = PackedByteArray([
	0xa9, 0x80, 0x85, 0x10, 0xa9, 0x00, 0x24, 0x10, 0x85, 0x10, 0xa9, 0x80, 0x24, 0x10, 0xa9, 0x40,
	0x85, 0x10, 0xa9, 0x00, 0x24, 0x10, 0xa9, 0xc0, 0x85, 0x10, 0xa9, 0x00, 0x24, 0x10, 0xa9, 0x00,
	0x85, 0x10, 0xa9, 0x01, 0x24, 0x10, 0xa9, 0x80, 0x8d, 0x00, 0x01, 0xa9, 0x00, 0x2c, 0x00, 0x01,
	0x8d, 0x00, 0x01, 0xa9, 0x80, 0x2c, 0x00, 0x01, 0xa9, 0x40, 0x8d, 0x00, 0x01, 0xa9, 0x00, 0x2c,
	0x00, 0x01, 0xa9, 0xc0, 0x8d, 0x00, 0x01, 0xa9, 0x00, 0x2c, 0x00, 0x01, 0xa9, 0x00, 0x8d, 0x00,
	0x01, 0xa9, 0x01, 0x2c, 0x00, 0x01
])

func test_and():
	setup_assembly(and_str, and_assembled)
	cpu.step()
	assert_int(cpu.A).is_equal(0x55)
	cpu.step()
	assert_int(cpu.A).is_equal(0x05)
	cpu.step(3)
	assert_int(cpu.A).is_equal(0x55)
	cpu.step()
	assert_int(cpu.A).is_equal(0x05)
	cpu.step(9)
	assert_int(cpu.A).is_equal(0xAA)
	cpu.step()
	assert_int(cpu.A).is_equal(0x0A)
	cpu.step()
	assert_int(cpu.A).is_equal(0xAA)
	cpu.step(2)
	assert_int(cpu.A).is_equal(0xA0)
	cpu.step()
	assert_int(cpu.A).is_equal(0x11)

func test_asl_accumulator():
	setup_assembly(asl_accum_str, asl_accum_assembled)
	cpu.step()
	assert_int(cpu.A).is_equal(0x01)
	cpu.step()
	assert_int(cpu.A).is_equal(0x02)
	cpu.step()
	assert_int(cpu.A).is_equal(0x80)
	cpu.step()
	assert_int(cpu.A).is_equal(0x00)
	assert_bool(cpu.zero_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0x7F)
	assert_bool(cpu.negative_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(0xFE)
	assert_bool(cpu.negative_flag).is_true()

func test_asl_zp():
	setup_assembly(asl_zp_str, asl_zp_assembled)
	cpu.step(2)
	assert_int(cpu.get_byte(0x01)).is_equal(0x01)
	cpu.step()
	assert_int(cpu.get_byte(0x01)).is_equal(0x02)
	cpu.step(2)
	assert_int(cpu.get_byte(0x01)).is_equal(0x80)
	cpu.step()
	assert_int(cpu.get_byte(0x01)).is_equal(0x00)
	assert_bool(cpu.zero_flag).is_true()
	cpu.step(2)
	assert_int(cpu.get_byte(0x01)).is_equal(0x7F)
	assert_bool(cpu.negative_flag).is_false()
	cpu.step()
	assert_int(cpu.get_byte(0x01)).is_equal(0xFE)
	assert_bool(cpu.negative_flag).is_true()

func test_asl_zpx():
	setup_assembly(asl_zpx_str, asl_zpx_assembled)
	cpu.step(3)
	assert_int(cpu.get_byte(0x02)).is_equal(0x01)
	cpu.step()
	assert_int(cpu.get_byte(0x02)).is_equal(0x02)
	cpu.step(2)
	assert_int(cpu.get_byte(0x02)).is_equal(0x80)
	cpu.step()
	assert_int(cpu.get_byte(0x02)).is_equal(0x00)
	assert_bool(cpu.zero_flag).is_true()
	cpu.step(2)
	assert_int(cpu.get_byte(0x02)).is_equal(0x7F)
	assert_bool(cpu.negative_flag).is_false()
	cpu.step()
	assert_int(cpu.get_byte(0x02)).is_equal(0xFE)
	assert_bool(cpu.negative_flag).is_true()

func test_asl_abs():
	setup_assembly(asl_abs_str, asl_abs_assembled)
	cpu.step(2)
	assert_int(cpu.get_byte(0x200)).is_equal(0x01)
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x02)
	cpu.step(2)
	assert_int(cpu.get_byte(0x200)).is_equal(0x80)
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x00)
	assert_bool(cpu.zero_flag).is_true()
	cpu.step(2)
	assert_int(cpu.get_byte(0x200)).is_equal(0x7F)
	assert_bool(cpu.negative_flag).is_false()
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0xFE)
	assert_bool(cpu.negative_flag).is_true()

func test_asl_absx():
	setup_assembly(asl_absx_str, asl_absx_assembled)
	cpu.step(3)
	assert_int(cpu.get_byte(0x201)).is_equal(0x01)
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x02)
	cpu.step(2)
	assert_int(cpu.get_byte(0x201)).is_equal(0x80)
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x00)
	assert_bool(cpu.zero_flag).is_true()
	cpu.step(2)
	assert_int(cpu.get_byte(0x201)).is_equal(0x7F)
	assert_bool(cpu.negative_flag).is_false()
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0xFE)
	assert_bool(cpu.negative_flag).is_true()

func test_lsr_accumulator():
	setup_assembly(lsr_accum_str, lsr_accum_assembled)
	cpu.step()
	assert_int(cpu.A).is_equal(0x84)
	cpu.step()
	assert_int(cpu.A).is_equal(0x42)
	cpu.step()
	assert_int(cpu.A).is_equal(0x21)
	cpu.step()
	assert_int(cpu.A).is_equal(0x10)
	cpu.step()
	assert_int(cpu.A).is_equal(0x8)
	cpu.step()
	assert_int(cpu.A).is_equal(0x4)

func test_lsr_zp():
	setup_assembly(lsr_zp_str, lsr_zp_assembled)
	cpu.step(2)
	assert_int(cpu.get_byte(0x42)).is_equal(0x84)
	cpu.step()
	assert_int(cpu.get_byte(0x42)).is_equal(0x42)
	cpu.step()
	assert_int(cpu.get_byte(0x42)).is_equal(0x21)
	cpu.step()
	assert_int(cpu.get_byte(0x42)).is_equal(0x10)
	cpu.step()
	assert_int(cpu.get_byte(0x42)).is_equal(0x8)
	cpu.step()
	assert_int(cpu.get_byte(0x42)).is_equal(0x4)

func test_lsr_accum_carry():
	setup_assembly(lsr_accum_carry_str, lsr_accum_carry_assembled)
	cpu.set_flag(CPU.flag_bit.CARRY, false)
	cpu.step()
	assert_int(cpu.A).is_equal(0x3)
	cpu.step()
	assert_flag(CPU.flag_bit.CARRY).is_true()
	cpu.step()
	assert_flag(CPU.flag_bit.CARRY).is_true()
	cpu.step()
	assert_flag(CPU.flag_bit.CARRY).is_false()
	assert_flag(CPU.flag_bit.ZERO).is_true()

func test_lsr_zp_carry():
	setup_assembly(lsr_zp_carry_str, lsr_zp_carry_assembled)
	cpu.set_flag(CPU.flag_bit.CARRY, false)
	cpu.step(2)
	assert_int(cpu.get_byte(0x1)).is_equal(0x3)
	cpu.step()
	assert_flag(CPU.flag_bit.CARRY).is_true()
	cpu.step()
	assert_flag(CPU.flag_bit.CARRY).is_true()
	cpu.step()
	assert_flag(CPU.flag_bit.CARRY).is_false()
	assert_flag(CPU.flag_bit.ZERO).is_true()

func test_ora():
	setup_assembly(ora_str, ora_assembled)
	cpu.memory[0x55] = 0x55
	cpu.memory[0x44] = 0x44
	cpu.step()
	assert_int(cpu.A).is_equal(0x55)
	cpu.step()
	assert_int(cpu.A).is_equal(0xFF)
	cpu.step(4)
	assert_int(cpu.A).is_equal(0x3F)
	cpu.step(4)
	assert_int(cpu.A).is_equal(0x33)
	cpu.step(4)
	assert_int(cpu.A).is_equal(0x55)
	cpu.step(4)
	assert_int(cpu.A).is_equal(0x77)
	cpu.step(4)
	assert_int(cpu.A).is_equal(0x99)
	cpu.step(6)
	assert_int(cpu.A).is_equal(0x55)
	cpu.step()
	assert_int(cpu.A).is_equal(0x44)
	cpu.step(5)
	assert_int(cpu.A).is_equal(0x55)

func test_bit():
	setup_assembly(bit_str, bit_assembled)
	# for i in range(2): # code used is repeated
	cpu.step(2)
	assert_int(cpu.A).is_equal(0x80)
	assert_bool(cpu.get_flag_state(CPU.flag_bit.NEGATIVE)).is_true()
	assert_bool(cpu.get_flag_state(CPU.flag_bit.OVERFLOW)).is_false()
	cpu.step()
	assert_bool(cpu.get_flag_state(CPU.flag_bit.NEGATIVE)).is_false()
	assert_int(cpu.A).is_equal(0)
	cpu.step()
	assert_bool(cpu.get_flag_state(CPU.flag_bit.NEGATIVE)).is_true()
	cpu.step(2)
	assert_int(cpu.A).is_equal(0x80)
	cpu.step()
	assert_bool(cpu.get_flag_state(CPU.flag_bit.NEGATIVE)).is_false()
	cpu.step(3)
	assert_bool(cpu.get_flag_state(CPU.flag_bit.OVERFLOW)).is_false()
	cpu.step()
	assert_bool(cpu.get_flag_state(CPU.flag_bit.OVERFLOW)).is_true()
	cpu.step(3)
	assert_bool(cpu.get_flag_state(CPU.flag_bit.NEGATIVE)).is_false()
	assert_bool(cpu.get_flag_state(CPU.flag_bit.OVERFLOW)).is_true()
	cpu.step()
	assert_bool(cpu.get_flag_state(CPU.flag_bit.NEGATIVE)).is_true()
	assert_bool(cpu.get_flag_state(CPU.flag_bit.OVERFLOW)).is_true()
	cpu.step(3)
	assert_int(cpu.A).is_equal(1)
	assert_bool(cpu.get_flag_state(CPU.flag_bit.ZERO)).is_false()
	cpu.step()
	assert_bool(cpu.get_flag_state(CPU.flag_bit.ZERO)).is_false()

	# absolute addressing, copied instead of using a for loop to make debugging easier
	cpu.step(2)
	assert_int(cpu.A).is_equal(0x80)
	assert_bool(cpu.get_flag_state(CPU.flag_bit.NEGATIVE)).is_true()
	assert_bool(cpu.get_flag_state(CPU.flag_bit.OVERFLOW)).is_false()
	cpu.step()
	assert_bool(cpu.get_flag_state(CPU.flag_bit.NEGATIVE)).is_false()
	assert_int(cpu.A).is_equal(0)
	cpu.step()
	assert_bool(cpu.get_flag_state(CPU.flag_bit.NEGATIVE)).is_true()
	cpu.step(2)
	assert_int(cpu.A).is_equal(0x80)
	cpu.step()
	assert_bool(cpu.get_flag_state(CPU.flag_bit.NEGATIVE)).is_false()
	cpu.step(3)
	assert_bool(cpu.get_flag_state(CPU.flag_bit.OVERFLOW)).is_false()
	cpu.step()
	assert_bool(cpu.get_flag_state(CPU.flag_bit.OVERFLOW)).is_true()
	cpu.step(3)
	assert_bool(cpu.get_flag_state(CPU.flag_bit.NEGATIVE)).is_false()
	assert_bool(cpu.get_flag_state(CPU.flag_bit.OVERFLOW)).is_true()
	cpu.step()
	assert_bool(cpu.get_flag_state(CPU.flag_bit.NEGATIVE)).is_true()
	assert_bool(cpu.get_flag_state(CPU.flag_bit.OVERFLOW)).is_true()
	cpu.step(3)
	assert_int(cpu.A).is_equal(1)
	assert_bool(cpu.get_flag_state(CPU.flag_bit.ZERO)).is_false()
	cpu.step()
	assert_bool(cpu.get_flag_state(CPU.flag_bit.ZERO)).is_false()

