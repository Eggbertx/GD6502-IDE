class_name DCBTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# used for testing Assembler.gd's functionality for generating byte arrays from hexadecimal
# or decimal operands

const dcb_str = "$ff,$f0,71"
const dcb_arr = [0xFF, 0xF0, 71]

const no_code_str = ""
const no_code_arr = []

const invalid_operand = "ff"

var asm = Assembler.new()

func test_dcb():
	var bytes = asm.dcb_to_bytes(dcb_str)
	assert_array(bytes).is_equal(dcb_arr)

func test_no_code():
	var bytes = asm.dcb_to_bytes(no_code_str)
	assert_array(bytes).is_equal(no_code_arr)

func test_invalid():
	var bytes = asm.dcb_to_bytes(invalid_operand)
	assert_array(bytes).is_null()
