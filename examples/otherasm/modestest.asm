; TODO: move this to a proper unit test

; *=128 ; program offset with a decimal memory address
;*=$0F ; hex memory address

start: ; $0600
nop ; implied
modes: ; $0601
lda #$10 ; immediate literal
lda #7 ; immediate literal, decimal, no padding
lda #09 ; immediate literal, decimal
lda #255 ; immediate literal, decimal
lda $ab ; zero-page
lda $20,x ; zero-page x
ldx $21, y ; zero-page y
lda start ; absolute label
lda start, x ; label x-indexed
lda endlabel, y ; label y-indexed
jmp $1234 ; absolute
lda $3000, x ; absolute x
lda $3001, y ; absolute y
; jmp ($ff00) ; indirect
lda ($32, x) ; indexed indirect
lda ($33), y ; indirect indexed
jmp start
;beq $20 ; BEQ and some other opcodes use relative addressing, which has the same syntax as zero page addressing

; testing label address detection when the label occurs after the current line
endlabel:
nop