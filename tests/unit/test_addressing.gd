extends "res://addons/gut/test.gd"

# Test Assembler.gd's addressing mode detection, more in-depth address mode tests are in ./unit/

const addr_modes_str = """
label:
nop ; implied
;ror a ; accumlator
lda #$10 ; immediate literal
lda $ab ; zero-page
lda $20,x ; zero-page x
ldx $21, y ; zero-page y
beq label ; relative label
; bne *+4 ; relative, skip (not supported by 6502asm)
jmp $1234 ; absolute
lda labelname ; absolute label
adc $3000, x ; absolute x
lda $3001, y ; absolute y
;lda ($ff00) ; indirect
lda ($32,x) ; indexed indirect
lda ($33), y ; indirect indexed
"""
var addr_modes_assembled = PoolByteArray([
	0xea, 0xa9, 0x10, 0xa5, 0xab, 0xb5, 0x20, 0xb6, 0x21, 0xf0, 0xf5, 0x4c, 0x34, 0x12, 0xad, 0xff,
	0xff, 0x7d, 0x00, 0x30, 0xb9, 0x01, 0x30, 0xa1, 0x32, 0xb1, 0x33
])



var asm = Assembler.new()

func test_addrmode():
	asm.asm_str = addr_modes_str
	var success = asm.assemble()
	assert_eq(success, OK, "tests to make sure the code assembled with no errors")
	assert_eq(asm.assembled.size(), addr_modes_assembled.size(), "test to make sure we're getting the correct # of bytes")

	# for b in range(asm.assembled.size()):
	# 	assert_eq(asm.assembled[b], addr_modes_assembled[b], "Checking asm.assembled[%d]" % b)
	assert_eq(asm.assembled, addr_modes_assembled, "'nop' uses implied addressing")

