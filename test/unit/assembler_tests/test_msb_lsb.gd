class_name HiLoByte
extends GdUnitTestSuite

const msb_str := """
lda label
lda #>label

label:
nop
"""

const lsb_str := """
lda label
lda #<label

label:
nop
"""

var msb_assembled := PackedByteArray([
	0xad, 0x05, 0x06, 0xa9, 0x06, 0xea
])

var lsb_assembled := PackedByteArray([
	0xad, 0x05, 0x06, 0xa9, 0x05, 0xea
])

func test_msb():
	var asm := Assembler.new()
	asm.asm_str = msb_str
	assert_int(asm.assemble()).is_equal(OK)
	assert_array(asm.assembled).is_equal(msb_assembled)
	assert_int(asm.labels.get("label")).is_equal(0x605)

func test_lsb():
	var asm := Assembler.new()
	asm.asm_str = lsb_str
	assert_int(asm.assemble()).is_equal(OK)
	assert_array(asm.assembled).is_equal(lsb_assembled)
	assert_int(asm.labels.get("label")).is_equal(0x605)