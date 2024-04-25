class_name BitwiseOpcodesTest
extends CPUTestBase

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
ora #$0f

lda #$aa
sta $03
lda #$55
ora #$0f

ldx #$1
ldy #$1
lda #$0e
sta $01
lda #$f0
sta $aa
lda #$0f
sta $12

lda #$aa
ora $00,x

lda #$aa
sta $03
ora ($02,x)

lda #$11
sta $a
ora ($a),y
"""

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
	0xa9, 0x55, 0x09, 0x0f, 0xa9, 0xaa, 0x85, 0x03, 0xa9, 0x55, 0x09, 0x0f, 0xa2, 0x01, 0xa0, 0x01, 
	0xa9, 0x0e, 0x85, 0x01, 0xa9, 0xf0, 0x85, 0xaa, 0xa9, 0x0f, 0x85, 0x12, 0xa9, 0xaa, 0x15, 0x00, 
	0xa9, 0xaa, 0x85, 0x03, 0x01, 0x02, 0xa9, 0x11, 0x85, 0x0a, 0x11, 0x0a 
])

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
	cpu.step()
	assert_int(cpu.A).is_equal(0x55)
	cpu.step()
	assert_int(cpu.A).is_equal(0x5F)
	cpu.step(3)
	assert_int(cpu.A).is_equal(0x55)
	cpu.step()
	assert_int(cpu.A).is_equal(0x5F)
	cpu.step(9)
	assert_int(cpu.A).is_equal(0xAA)
	cpu.step()
	assert_int(cpu.A).is_equal(0xAE)
	cpu.step()
	assert_int(cpu.A).is_equal(0xAA)
	cpu.step(2)
	assert_int(cpu.A).is_equal(0xFA)
	cpu.step()
	assert_int(cpu.A).is_equal(0x11)
	cpu.step(2)
	assert_int(cpu.A).is_equal(0x1F)