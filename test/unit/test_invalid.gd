class_name InvalidAsmTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')
# used for testing Assembler.gd's functionality for detecting invalid syntax and aborting assembly when it's detected

const invalid_str = """
; this is valid
loop:
jmp loop
sameline: tax
samelinenospace:txa

; invalid syntaxes start here
lda $aaaa, ; missing index
lda $12,xy ; invalid zp indexed
lda ($bc,y) ; invalid indexed-indirect, x only
lda ($bc),x ; invalid indirect-indexed, y only
lda # ; indirect, missing number
lda $ ; missing reference
lda #$
lda #$456 ; > 8 bits
sta $ a
"""

var asm = Assembler.new()
func test_invalids():
	asm.asm_str = invalid_str
	var success = asm.assemble()
	# todo: come up with a more reliable way of doing this, since a null byte array could also be
	# returned if the cleaned source code is empty
	
	assert_int(success).is_not_equal(OK)
