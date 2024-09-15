class_name BitwiseOpcodesTest
extends CPUTestBase

const and_imm_str = """
lda #$55
and #$0f
"""

const and_zp_str = """
lda #$f
sta $1
lda #$55
and $1
"""

const and_zpx_str = """
lda #$f
ldx #$1
sta $2
lda #$55
and $1,x
"""

const and_abs_str = """
lda #$f
sta $100
lda #$55
and $100
"""

const and_absx_str = """
lda #$f
ldx #$1
sta $101
lda #$55
and $100,x
"""

const and_absy_str = """
lda #$f
ldy #$1
sta $101
lda #$55
and $100,y
"""

const and_indx_str = """
lda #$1
sta $52
lda #$f
sta $100
ldx #$1
lda #$55
and ($50,x)
"""

const and_indy_str = """
lda #$1
sta $51
lda #$f
sta $101
ldy #$1
lda #$55
and ($50),y
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

const lsr_zpx_str := """
lda #$84
ldx #$1
sta $42
lsr $41,x
lsr $41,x
lsr $41,x
lsr $41,x
lsr $41,x
"""

const lsr_abs_str := """
lda #$84
sta $200
lsr $200
lsr $200
lsr $200
lsr $200
lsr $200
"""

const lsr_absx_str := """
lda #$84
ldx #$1
sta $201
lsr $200,x
lsr $200,x
lsr $200,x
lsr $200,x
lsr $200,x
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

const rol_acc_str := """
lda #$1
rol ; 2
rol ; 4
rol ; 8
rol ; 16
rol ; 32
rol ; 64
rol ; 128, N
rol ; 0, C, Z
rol ; 1
"""

const rol_zp_str := """
lda #$1
sta $1
rol $1 ; 2
rol $1 ; 4
rol $1 ; 8
rol $1 ; 16
rol $1 ; 32
rol $1 ; 64
rol $1 ; 128, N
rol $1 ; 0, C, Z
rol $1 ; 1
"""

const rol_zpx_str := """
lda #$1
ldx #$1
sta $2
rol $1,x ; 2
rol $1,x ; 4
rol $1,x ; 8
rol $1,x ; 16
rol $1,x ; 32
rol $1,x ; 64
rol $1,x ; 128, N
rol $1,x ; 0, C, Z
rol $1,x ; 1
"""

const rol_abs_str := """
lda #$1
sta $200
rol $200 ; 2
rol $200 ; 4
rol $200 ; 8
rol $200 ; 16
rol $200 ; 32
rol $200 ; 64
rol $200 ; 128, N
rol $200 ; 0, C, Z
rol $200 ; 1
"""

const rol_absx_str := """
lda #$1
ldx #$1
sta $201
rol $200,x ; 2
rol $200,x ; 4
rol $200,x ; 8
rol $200,x ; 16
rol $200,x ; 32
rol $200,x ; 64
rol $200,x ; 128, N
rol $200,x ; 0, C, Z
rol $200,x ; 1
"""

const ror_acc_str := """
lda #$80
ror ; 64
ror ; 32
ror ; 16
ror ; 8
ror ; 4
ror ; 2
ror ; 1
ror ; 0, Z, C
ror ; 80, N
"""

const ror_zp_str := """
lda #$80
sta $1
ror $1 ; 64
ror $1 ; 32
ror $1 ; 16
ror $1 ; 8
ror $1 ; 4
ror $1 ; 2
ror $1 ; 1
ror $1 ; 0, Z, C
ror $1 ; 80, N
"""

const ror_zpx_str := """
lda #$80
ldx #$1
sta $2
ror $1,x ; 64
ror $1,x ; 32
ror $1,x ; 16
ror $1,x ; 8
ror $1,x ; 4
ror $1,x ; 2
ror $1,x ; 1
ror $1,x ; 0, Z, C
ror $1,x ; 80, N
"""

const ror_abs_str := """
lda #$80
sta $200
ror $200 ; 64
ror $200 ; 32
ror $200 ; 16
ror $200 ; 8
ror $200 ; 4
ror $200 ; 2
ror $200 ; 1
ror $200 ; 0, Z, C
ror $200 ; 80, N
"""

const ror_absx_str := """
lda #$80
ldx #$1
sta $201
ror $200,x ; 64
ror $200,x ; 32
ror $200,x ; 16
ror $200,x ; 8
ror $200,x ; 4
ror $200,x ; 2
ror $200,x ; 1
ror $200,x ; 0, Z, C
ror $200,x ; 80, N
"""




var and_imm_assembled := PackedByteArray([
	0xa9, 0x55, 0x29, 0x0f
])

var and_zp_assembled := PackedByteArray([
	0xa9, 0x0f, 0x85, 0x01, 0xa9, 0x55, 0x25, 0x01
])

var and_zpx_assembled := PackedByteArray([
	0xa9, 0x0f, 0xa2, 0x01, 0x85, 0x02, 0xa9, 0x55, 0x35, 0x01 
])

var and_abs_assembled := PackedByteArray([
	0xa9, 0x0f, 0x8d, 0x00, 0x01, 0xa9, 0x55, 0x2d, 0x00, 0x01
])

var and_absx_assembled := PackedByteArray([
	0xa9, 0x0f, 0xa2, 0x01, 0x8d, 0x01, 0x01, 0xa9, 0x55, 0x3d, 0x00, 0x01
])

var and_absy_assembled := PackedByteArray([
	0xa9, 0x0f, 0xa0, 0x01, 0x8d, 0x01, 0x01, 0xa9, 0x55, 0x39, 0x00, 0x01
])

var and_indx_assembled := PackedByteArray([
	0xa9, 0x01, 0x85, 0x52, 0xa9, 0x0f, 0x8d, 0x00, 0x01, 0xa2, 0x01, 0xa9, 0x55, 0x21, 0x50
])

var and_indy_assembled := PackedByteArray([
	0xa9, 0x01, 0x85, 0x51, 0xa9, 0x0f, 0x8d, 0x01, 0x01, 0xa0, 0x01, 0xa9, 0x55, 0x31, 0x50
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

var lsr_accum_carry_assembled := PackedByteArray([
	0xa9, 0x03, 0x4a, 0x4a, 0x4a 
])

var lsr_zp_assembled := PackedByteArray([
	0xa9, 0x84, 0x85, 0x42, 0x46, 0x42, 0x46, 0x42, 0x46, 0x42, 0x46, 0x42, 0x46, 0x42
])

var lsr_zpx_assembled := PackedByteArray([
	0xa9, 0x84, 0xa2, 0x01, 0x85, 0x42, 0x56, 0x41, 0x56, 0x41, 0x56, 0x41, 0x56, 0x41, 0x56, 0x41
])

var lsr_abs_assembled := PackedByteArray([
	0xa9, 0x84, 0x8d, 0x00, 0x02, 0x4e, 0x00, 0x02, 0x4e, 0x00, 0x02, 0x4e, 0x00, 0x02, 0x4e, 0x00,
	0x02, 0x4e, 0x00, 0x02
])

var lsr_absx_assembled := PackedByteArray([
	0xa9, 0x84, 0xa2, 0x01, 0x8d, 0x01, 0x02, 0x5e, 0x00, 0x02, 0x5e, 0x00, 0x02, 0x5e, 0x00, 0x02,
	0x5e, 0x00, 0x02, 0x5e, 0x00, 0x02
])


var rol_zpx_assembled := PackedByteArray([
	0xa9, 0x01, 0xa2, 0x01, 0x85, 0x02, 0x36, 0x01, 0x36, 0x01, 0x36, 0x01, 0x36, 0x01, 0x36, 0x01,
	0x36, 0x01, 0x36, 0x01, 0x36, 0x01, 0x36, 0x01
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

var rol_acc_assembled := PackedByteArray([
	0xa9, 0x01, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a
])

var rol_zp_assembled := PackedByteArray([
	0xa9, 0x01, 0x85, 0x01, 0x26, 0x01, 0x26, 0x01, 0x26, 0x01, 0x26, 0x01, 0x26, 0x01, 0x26, 0x01,
	0x26, 0x01, 0x26, 0x01, 0x26, 0x01
])

var rol_abs_assembled := PackedByteArray([
	0xa9, 0x01, 0x8d, 0x00, 0x02, 0x2e, 0x00, 0x02, 0x2e, 0x00, 0x02, 0x2e, 0x00, 0x02, 0x2e, 0x00,
	0x02, 0x2e, 0x00, 0x02, 0x2e, 0x00, 0x02, 0x2e, 0x00, 0x02, 0x2e, 0x00, 0x02, 0x2e, 0x00, 0x02
])

var rol_absx_assembled := PackedByteArray([
	0xa9, 0x01, 0xa2, 0x01, 0x8d, 0x01, 0x02, 0x3e, 0x00, 0x02, 0x3e, 0x00, 0x02, 0x3e, 0x00, 0x02,
	0x3e, 0x00, 0x02, 0x3e, 0x00, 0x02, 0x3e, 0x00, 0x02, 0x3e, 0x00, 0x02, 0x3e, 0x00, 0x02, 0x3e,
	0x00, 0x02
])

var ror_acc_assembled := PackedByteArray([
	0xa9, 0x80, 0x6a, 0x6a, 0x6a, 0x6a, 0x6a, 0x6a, 0x6a, 0x6a, 0x6a
])

var ror_zp_assembled := PackedByteArray([
	0xa9, 0x80, 0x85, 0x01, 0x66, 0x01, 0x66, 0x01, 0x66, 0x01, 0x66, 0x01, 0x66, 0x01, 0x66, 0x01,
	0x66, 0x01, 0x66, 0x01, 0x66, 0x01
])

var ror_zpx_assembled := PackedByteArray([
	0xa9, 0x80, 0xa2, 0x01, 0x85, 0x02, 0x76, 0x01, 0x76, 0x01, 0x76, 0x01, 0x76, 0x01, 0x76, 0x01,
	0x76, 0x01, 0x76, 0x01, 0x76, 0x01, 0x76, 0x01
])

var ror_abs_assembled := PackedByteArray([
	0xa9, 0x80, 0x8d, 0x00, 0x02, 0x6e, 0x00, 0x02, 0x6e, 0x00, 0x02, 0x6e, 0x00, 0x02, 0x6e, 0x00,
	0x02, 0x6e, 0x00, 0x02, 0x6e, 0x00, 0x02, 0x6e, 0x00, 0x02, 0x6e, 0x00, 0x02, 0x6e, 0x00, 0x02
])

var ror_absx_assembled := PackedByteArray([
	0xa9, 0x80, 0xa2, 0x01, 0x8d, 0x01, 0x02, 0x7e, 0x00, 0x02, 0x7e, 0x00, 0x02, 0x7e, 0x00, 0x02,
	0x7e, 0x00, 0x02, 0x7e, 0x00, 0x02, 0x7e, 0x00, 0x02, 0x7e, 0x00, 0x02, 0x7e, 0x00, 0x02, 0x7e,
	0x00, 0x02
])

func test_and_imm():
	setup_assembly(and_imm_str, and_imm_assembled)
	cpu.step()
	assert_int(cpu.A).is_equal(0x55)
	cpu.step()
	assert_int(cpu.A).is_equal(0x05)

func test_and_zp():
	setup_assembly(and_zp_str, and_zp_assembled)
	cpu.step(3)
	assert_int(cpu.A).is_equal(0x55)
	cpu.step()
	assert_int(cpu.A).is_equal(0x05)

func test_and_zpx():
	setup_assembly(and_zpx_str, and_zpx_assembled)
	cpu.step(4)
	assert_int(cpu.A).is_equal(0x55)
	cpu.step()
	assert_int(cpu.A).is_equal(0x05)

func test_and_abs():
	setup_assembly(and_abs_str, and_abs_assembled)
	cpu.step(3)
	assert_int(cpu.A).is_equal(0x55)
	cpu.step()
	assert_int(cpu.A).is_equal(0x05)

func test_and_absx():
	setup_assembly(and_absx_str, and_absx_assembled)
	cpu.step(4)
	assert_int(cpu.A).is_equal(0x55)
	cpu.step()
	assert_int(cpu.A).is_equal(0x05)

func test_and_absy():
	setup_assembly(and_absy_str, and_absy_assembled)
	cpu.step(4)
	assert_int(cpu.A).is_equal(0x55)
	cpu.step()
	assert_int(cpu.A).is_equal(0x05)

func test_and_indx():
	setup_assembly(and_indx_str, and_indx_assembled)
	cpu.step(6)
	assert_int(cpu.A).is_equal(0x55)
	cpu.step()
	assert_int(cpu.A).is_equal(0x05)

func test_and_indy():
	setup_assembly(and_indy_str, and_indy_assembled)
	cpu.step(6)
	assert_int(cpu.A).is_equal(0x55)
	cpu.step()
	assert_int(cpu.A).is_equal(0x05)

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

func test_lsr_zpx():
	setup_assembly(lsr_zpx_str, lsr_zpx_assembled)
	cpu.step(3)
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

func test_lsr_abs():
	setup_assembly(lsr_abs_str, lsr_abs_assembled)
	cpu.step(2)
	assert_int(cpu.get_byte(0x200)).is_equal(0x84)
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x42)
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x21)
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x10)
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x8)
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x4)

func test_lsr_absx():
	setup_assembly(lsr_absx_str, lsr_absx_assembled)
	cpu.step(3)
	assert_int(cpu.get_byte(0x201)).is_equal(0x84)
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x42)
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x21)
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x10)
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x8)
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x4)

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

func test_rol_accumulator():
	setup_assembly(rol_acc_str, rol_acc_assembled)
	cpu.step()
	assert_int(cpu.A).is_equal(0x01)
	cpu.step()
	assert_int(cpu.A).is_equal(0x02)
	cpu.step()
	assert_int(cpu.A).is_equal(0x04)
	cpu.step()
	assert_int(cpu.A).is_equal(0x08)
	cpu.step()
	assert_int(cpu.A).is_equal(0x10)
	cpu.step()
	assert_int(cpu.A).is_equal(0x20)
	cpu.step()
	assert_int(cpu.A).is_equal(0x40)
	cpu.step()
	assert_int(cpu.A).is_equal(0x80)
	assert_bool(cpu.negative_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0)
	assert_bool(cpu.zero_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0x01)
	assert_bool(cpu.carry_flag).is_false()

func test_rol_zp():
	setup_assembly(rol_zp_str, rol_zp_assembled)
	cpu.step(2)
	assert_int(cpu.get_byte(0x1)).is_equal(0x01)
	cpu.step()
	assert_int(cpu.get_byte(0x1)).is_equal(0x02)
	cpu.step()
	assert_int(cpu.get_byte(0x1)).is_equal(0x04)
	cpu.step()
	assert_int(cpu.get_byte(0x1)).is_equal(0x08)
	cpu.step()
	assert_int(cpu.get_byte(0x1)).is_equal(0x10)
	cpu.step()
	assert_int(cpu.get_byte(0x1)).is_equal(0x20)
	cpu.step()
	assert_int(cpu.get_byte(0x1)).is_equal(0x40)
	cpu.step()
	assert_int(cpu.get_byte(0x1)).is_equal(0x80)
	assert_bool(cpu.negative_flag).is_true()
	cpu.step()
	assert_int(cpu.get_byte(0x1)).is_equal(0)
	assert_bool(cpu.zero_flag).is_true()
	cpu.step()
	assert_int(cpu.get_byte(0x1)).is_equal(0x01)
	assert_bool(cpu.carry_flag).is_false()

func test_rol_zpx():
	setup_assembly(rol_zpx_str, rol_zpx_assembled)
	cpu.step(3)
	assert_int(cpu.get_byte(0x2)).is_equal(0x01)
	cpu.step()
	assert_int(cpu.get_byte(0x2)).is_equal(0x02)
	cpu.step()
	assert_int(cpu.get_byte(0x2)).is_equal(0x04)
	cpu.step()
	assert_int(cpu.get_byte(0x2)).is_equal(0x08)
	cpu.step()
	assert_int(cpu.get_byte(0x2)).is_equal(0x10)
	cpu.step()
	assert_int(cpu.get_byte(0x2)).is_equal(0x20)
	cpu.step()
	assert_int(cpu.get_byte(0x2)).is_equal(0x40)
	cpu.step()
	assert_int(cpu.get_byte(0x2)).is_equal(0x80)
	assert_bool(cpu.negative_flag).is_true()
	cpu.step()
	assert_int(cpu.get_byte(0x2)).is_equal(0)
	assert_bool(cpu.zero_flag).is_true()
	cpu.step()
	assert_int(cpu.get_byte(0x2)).is_equal(0x01)
	assert_bool(cpu.carry_flag).is_false()

func test_rol_abs():
	setup_assembly(rol_abs_str, rol_abs_assembled)
	cpu.step(2)
	assert_int(cpu.get_byte(0x200)).is_equal(0x01)
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x02)
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x04)
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x08)
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x10)
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x20)
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x40)
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x80)
	assert_bool(cpu.negative_flag).is_true()
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0)
	assert_bool(cpu.zero_flag).is_true()
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x01)
	assert_bool(cpu.carry_flag).is_false()

func test_rol_absx():
	setup_assembly(rol_absx_str, rol_absx_assembled)
	cpu.step(3)
	assert_int(cpu.get_byte(0x201)).is_equal(0x01)
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x02)
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x04)
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x08)
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x10)
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x20)
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x40)
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x80)
	assert_bool(cpu.negative_flag).is_true()
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0)
	assert_bool(cpu.zero_flag).is_true()
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x01)
	assert_bool(cpu.carry_flag).is_false()

func test_ror_accumulator():
	setup_assembly(ror_acc_str, ror_acc_assembled)
	cpu.step()
	assert_int(cpu.A).is_equal(0x80)
	cpu.step()
	assert_int(cpu.A).is_equal(0x40)
	cpu.step()
	assert_int(cpu.A).is_equal(0x20)
	cpu.step()
	assert_int(cpu.A).is_equal(0x10)
	cpu.step()
	assert_int(cpu.A).is_equal(0x8)
	cpu.step()
	assert_int(cpu.A).is_equal(0x4)
	cpu.step()
	assert_int(cpu.A).is_equal(0x2)
	cpu.step()
	assert_int(cpu.A).is_equal(0x1)
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.A).is_equal(0x0)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_true()
	cpu.step()
	assert_int(cpu.A).is_equal(0x80)
	assert_bool(cpu.carry_flag).is_false()

func test_ror_zp():
	setup_assembly(ror_zp_str, ror_zp_assembled)
	cpu.step(2)
	assert_int(cpu.get_byte(0x1)).is_equal(0x80)
	cpu.step()
	assert_int(cpu.get_byte(0x1)).is_equal(0x40)
	cpu.step()
	assert_int(cpu.get_byte(0x1)).is_equal(0x20)
	cpu.step()
	assert_int(cpu.get_byte(0x1)).is_equal(0x10)
	cpu.step()
	assert_int(cpu.get_byte(0x1)).is_equal(0x8)
	cpu.step()
	assert_int(cpu.get_byte(0x1)).is_equal(0x4)
	cpu.step()
	assert_int(cpu.get_byte(0x1)).is_equal(0x2)
	cpu.step()
	assert_int(cpu.get_byte(0x1)).is_equal(0x1)
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.get_byte(0x1)).is_equal(0x0)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_true()
	cpu.step()
	assert_int(cpu.get_byte(0x1)).is_equal(0x80)
	assert_bool(cpu.carry_flag).is_false()

func test_ror_zpx():
	setup_assembly(ror_zpx_str, ror_zpx_assembled)
	cpu.step(3)
	assert_int(cpu.get_byte(0x2)).is_equal(0x80)
	cpu.step()
	assert_int(cpu.get_byte(0x2)).is_equal(0x40)
	cpu.step()
	assert_int(cpu.get_byte(0x2)).is_equal(0x20)
	cpu.step()
	assert_int(cpu.get_byte(0x2)).is_equal(0x10)
	cpu.step()
	assert_int(cpu.get_byte(0x2)).is_equal(0x8)
	cpu.step()
	assert_int(cpu.get_byte(0x2)).is_equal(0x4)
	cpu.step()
	assert_int(cpu.get_byte(0x2)).is_equal(0x2)
	cpu.step()
	assert_int(cpu.get_byte(0x2)).is_equal(0x1)
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.get_byte(0x2)).is_equal(0x0)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_true()
	cpu.step()
	assert_int(cpu.get_byte(0x2)).is_equal(0x80)
	assert_bool(cpu.carry_flag).is_false()

func test_ror_abs():
	setup_assembly(ror_abs_str, ror_abs_assembled)
	cpu.step(2)
	assert_int(cpu.get_byte(0x200)).is_equal(0x80)
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x40)
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x20)
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x10)
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x8)
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x4)
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x2)
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x1)
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x0)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_true()
	cpu.step()
	assert_int(cpu.get_byte(0x200)).is_equal(0x80)
	assert_bool(cpu.carry_flag).is_false()

func test_ror_absx():
	setup_assembly(ror_absx_str, ror_absx_assembled)
	cpu.step(3)
	assert_int(cpu.get_byte(0x201)).is_equal(0x80)
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x40)
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x20)
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x10)
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x8)
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x4)
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x2)
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x1)
	assert_bool(cpu.carry_flag).is_false()
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x0)
	assert_bool(cpu.carry_flag).is_true()
	assert_bool(cpu.zero_flag).is_true()
	cpu.step()
	assert_int(cpu.get_byte(0x201)).is_equal(0x80)
	assert_bool(cpu.carry_flag).is_false()
