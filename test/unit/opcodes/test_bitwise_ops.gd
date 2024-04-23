class_name BitwiseOpcodesTest
extends CPUTestBase

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

var ora_assembled := PackedByteArray([
	0xa9, 0x55, 0x09, 0x0f, 0xa9, 0xaa, 0x85, 0x03, 0xa9, 0x55, 0x09, 0x0f, 0xa2, 0x01, 0xa0, 0x01, 
	0xa9, 0x0e, 0x85, 0x01, 0xa9, 0xf0, 0x85, 0xaa, 0xa9, 0x0f, 0x85, 0x12, 0xa9, 0xaa, 0x15, 0x00, 
	0xa9, 0xaa, 0x85, 0x03, 0x01, 0x02, 0xa9, 0x11, 0x85, 0x0a, 0x11, 0x0a 
])

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




