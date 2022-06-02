extends "res://addons/gut/test.gd"

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
	assert_eq(bytes, dcb_arr, "testing 6502asm dcb parsing")

func test_no_code():
	var bytes = asm.dcb_to_bytes(no_code_str)
	assert_eq(bytes, no_code_arr, "testing dcb_to_bytes properly returning an empty array")

func test_invalid():
	var bytes = asm.dcb_to_bytes(invalid_operand)
	assert_null(bytes, "testing dcb_to_bytes returning a null value if a dcb line has invalid operand(s)")
