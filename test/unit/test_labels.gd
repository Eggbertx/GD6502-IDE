class_name LabelsTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

const labels_str = """
start:
nop
lda start ; already set so this should be $0600
jmp unset ; not set yet, should be $FFFF until updated
jmp nonexistent ; label doesn't exist at all, remains as $FFFF

unset:
nop
"""

var asm = Assembler.new()
var bytes = PackedByteArray([0xea, 0xad, 0x00, 0x06, 0x4c, 0x0a, 0x06, 0x4c, 0xff, 0xff, 0xea])

func test_labels():
	asm.asm_str = labels_str
	var success = asm.assemble()
	assert_int(success).is_equal(OK)

	# test to make sure that the labels have been properly updated
	# TODO: take *=addr into account
	assert_array(asm.assembled).is_equal(bytes)
