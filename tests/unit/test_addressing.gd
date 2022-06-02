extends "res://addons/gut/test.gd"

# Test Assembler.gd's addressing mode detection

const addr_modes_str = """
nop ; implied
ror a ; accumlator
lda #$10 ; immediate literal
lda $ab ; zero-page
lda $20,x ; zero-page x
lda $21, y ; zero-page y
beq label ; relative label
; bne *+4 ; relative, skip (not supported by 6502asm)
jmp $1234 ; absolute
lda labelname ; absolute label
jmp $3000, x ; absolute x
lda $3001, y ; absolute y
lda ($ff00) ; indirect
lda ($32,x) ; indexed indirect
lda ($33), y ; indirect indexed
"""

var asm = Assembler.new()

func test_addrmode():
	asm.asm_str = addr_modes_str
	asm.assemble()
