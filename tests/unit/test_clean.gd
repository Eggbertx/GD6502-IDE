extends "res://addons/gut/test.gd"

# Test Assembler.gd's comment/space cleaning

const not_cleaned = """
start: lda $20,x
; full line comment
;full line comment with no space after ;
 ; full line comment with whitespace before ;

nop;
	nop
	lda $20,x ; zero-page x
	lda $21 	, 	 y ; zero-page y
nop 	  $0200 ;technically invalid since nop doesn't take any parameters
nop 
;;
;
"""

const cleaned = """start: lda $20,x
nop
nop
lda $20,x
lda $21,y
nop $0200
nop"""

var asm = Assembler.new()

func test_clean():
	asm.asm_str = not_cleaned
	var lines = not_cleaned.split("\n")
	var cleaned_str = ""

	for line in lines:
		var cleaned_line = asm.clean_line(line)
		if cleaned_line != "":
			cleaned_str += cleaned_line
			cleaned_str += "\n"
	assert_eq(cleaned_str.strip_edges(true, true), cleaned, "tests the comment cleaning functionality")
