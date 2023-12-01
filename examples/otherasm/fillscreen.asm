lda #$1
loop:
sta $200,x
sta $300,x
sta $400,x
sta $500,x
inx
jmp loop