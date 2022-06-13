extends "res://addons/gut/test.gd"

# Test Assembler.gd's addressing mode detection

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

const implied_str = """
ASL
CLC
SEC
CLI
SEI
CLV
CLD
SED
LSR
NOP
TAX
TXA
DEX
INX
TAY
TYA
DEY
INY
ROR
ROL
RTI
RTS
TXS
TSX
PHA
PLA
PHP
PLP
"""
var implied_assembled = PoolByteArray([
	0x0a, 0x18, 0x38, 0x58, 0x78, 0xb8, 0xd8, 0xf8, 0x4a, 0xea, 0xaa, 0x8a, 0xca, 0xe8, 0xa8, 0x98,
	0x88, 0xc8, 0x6a, 0x2a, 0x40, 0x60, 0x9a, 0xba, 0x48, 0x68, 0x08, 0x28 
])

const immediate_str = """
ADC #$12
AND #34
CMP #$56
CPX #$78
CPY #$9a
EOR #$bc
LDA #$de
LDX #$f0
LDY #$12
ORA #$34
SBC #$56
"""
var immediate_assembled = PoolByteArray([
	0x69, 0x12, 0x29, 0x22, 0xc9, 0x56, 0xe0, 0x78, 0xc0, 0x9a, 0x49, 0xbc, 0xa9, 0xde, 0xa2, 0xf0,
	0xa0, 0x12, 0x09, 0x34, 0xe9, 0x56 
])

const zp_str = """
ADC $ab
AND $ab
ASL $ab
BIT $ab
CMP $ab
CPX $ab
CPY $ab
DEC $ab
EOR $ab
INC $ab
LDA $ab
LDX $ab
LDY $ab
LSR $ab
ORA $ab
ROR $ab
ROL $ab
SBC $ab
STA $ab
STX $ab
STY $ab
"""
var zp_assembled = PoolByteArray([
	0x65, 0xab, 0x25, 0xab, 0x06, 0xab, 0x24, 0xab, 0xc5, 0xab, 0xe4, 0xab, 0xc4, 0xab, 0xc6, 0xab,
	0x45, 0xab, 0xe6, 0xab, 0xa5, 0xab, 0xa6, 0xab, 0xa4, 0xab, 0x46, 0xab, 0x05, 0xab, 0x66, 0xab,
	0x26, 0xab, 0xe5, 0xab, 0x85, 0xab, 0x86, 0xab, 0x84, 0xab
])

const zpx_str = """
ADC $ab,x
AND $ab,x
ASL $ab,x
CMP $ab,x
DEC $ab,x
EOR $ab,x
INC $ab,x
LDA $ab,x
LDY $ab,x
LSR $ab,x
ORA $ab,x
ROR $ab,x
ROL $ab,x
SBC $ab,x
STA $ab,x
STY $ab,x
"""
var zpx_assembled = PoolByteArray([
	0x75, 0xab, 0x35, 0xab, 0x16, 0xab, 0xd5, 0xab, 0xd6, 0xab, 0x55, 0xab, 0xf6, 0xab, 0xb5, 0xab,
	0xb4, 0xab, 0x56, 0xab, 0x15, 0xab, 0x76, 0xab, 0x36, 0xab, 0xf5, 0xab, 0x95, 0xab, 0x94, 0xab
])

const zpy_str = """
LDX $ab,y
STX $ab,y
"""
var zpy_assembled = PoolByteArray([0xb6, 0xab, 0x96, 0xab])

const abs_str = """
ADC $abcd
AND $abcd
ASL $abcd
BIT $abcd
CMP $abcd
CPX $abcd
CPY $abcd
DEC $abcd
EOR $abcd
INC $abcd
JMP $abcd
JSR $abcd
LDA $abcd
LDX $abcd
LDY $abcd
LSR $abcd
ORA $abcd
ROR $abcd
ROL $abcd
SBC $abcd
STA $abcd
STX $abcd
STY $abcd
"""
var abs_assembled = PoolByteArray([
	0x6d, 0xcd, 0xab, 0x2d, 0xcd, 0xab, 0x0e, 0xcd, 0xab, 0x2c, 0xcd, 0xab, 0xcd, 0xcd, 0xab, 0xec,
	0xcd, 0xab, 0xcc, 0xcd, 0xab, 0xce, 0xcd, 0xab, 0x4d, 0xcd, 0xab, 0xee, 0xcd, 0xab, 0x4c, 0xcd,
	0xab, 0x20, 0xcd, 0xab, 0xad, 0xcd, 0xab, 0xae, 0xcd, 0xab, 0xac, 0xcd, 0xab, 0x4e, 0xcd, 0xab,
	0x0d, 0xcd, 0xab, 0x6e, 0xcd, 0xab, 0x2e, 0xcd, 0xab, 0xed, 0xcd, 0xab, 0x8d, 0xcd, 0xab, 0x8e,
	0xcd, 0xab, 0x8c, 0xcd, 0xab
])

const absx_str = """
ADC $abcd,x
AND $abcd,x
ASL $abcd,x
CMP $abcd,x
DEC $abcd,x
EOR $abcd,x
INC $abcd,x
LDA $abcd,x
LDY $abcd,x
LSR $abcd,x
ORA $abcd,x
ROR $abcd,x
ROL $abcd,x
SBC $abcd,x
STA $abcd,x
"""
var absx_assembled = PoolByteArray([
	0x7d, 0xcd, 0xab, 0x3d, 0xcd, 0xab, 0x1e, 0xcd, 0xab, 0xdd, 0xcd, 0xab, 0xde, 0xcd, 0xab, 0x5d,
	0xcd, 0xab, 0xfe, 0xcd, 0xab, 0xbd, 0xcd, 0xab, 0xbc, 0xcd, 0xab, 0x5e, 0xcd, 0xab, 0x1d, 0xcd,
	0xab, 0x7e, 0xcd, 0xab, 0x3e, 0xcd, 0xab, 0xfd, 0xcd, 0xab, 0x9d, 0xcd, 0xab
])

const absy_str = """
ADC $abcd,y
AND $abcd,y
CMP $abcd,y
EOR $abcd,y
LDA $abcd,y
LDX $abcd,y
ORA $abcd,y
SBC $abcd,y
STA $abcd,y
"""
var absy_assembled = PoolByteArray([
	0x79, 0xcd, 0xab, 0x39, 0xcd, 0xab, 0xd9, 0xcd, 0xab, 0x59, 0xcd, 0xab, 0xb9, 0xcd, 0xab, 0xbe,
	0xcd, 0xab, 0x19, 0xcd, 0xab, 0xf9, 0xcd, 0xab, 0x99, 0xcd, 0xab
])

const indx_str = """
ADC ($12,x)
AND ($12,x)
CMP ($12,x)
EOR ($12,x)
LDA ($12,x)
ORA ($12,x)
SBC ($12,x)
STA ($12,x)
"""
var indx_assembled = PoolByteArray([
	0x61, 0x12, 0x21, 0x12, 0xc1, 0x12, 0x41, 0x12, 0xa1, 0x12, 0x01, 0x12, 0xe1, 0x12, 0x81, 0x12
])

const indy_str = """
ADC ($ab),y
AND ($ab),y
CMP ($ab),y
EOR ($ab),y
LDA ($ab),y
ORA ($ab),y
SBC ($ab),y
STA ($ab),y
"""
var indy_assembled = PoolByteArray([
	0x71, 0xab, 0x31, 0xab, 0xd1, 0xab, 0x51, 0xab, 0xb1, 0xab, 0x11, 0xab, 0xf1, 0xab, 0x91, 0xab
])

const rel_str = """
lbl:
BPL lbl
BMI lbl
BVC lbl
BVS lbl
BCC lbl
BCS lbl
BNE lbl
BEQ lbl
"""

var rel_assembled = PoolByteArray([
	0x10, 0xfe, 0x30, 0xfc, 0x50, 0xfa, 0x70, 0xf8, 0x90, 0xf6, 0xb0, 0xf4, 0xd0, 0xf2, 0xf0, 0xf0
])

var asm = Assembler.new()


func test_implied_addressing():
	asm.asm_str = implied_str
	var success = asm.assemble()
	assert_eq(success, OK, "tests to make sure the code for testing implied addressing assembled with no errors")
	assert_eq(asm.assembled.size(), implied_assembled.size(), "assembled bytecode size")
	assert_eq(asm.assembled, implied_assembled, "testing implied addressing")

func test_immediate_addressing():
	asm.asm_str = immediate_str
	var success = asm.assemble()
	assert_eq(success, OK, "tests to make sure the code for testing immediate addresssing assembled with no errors")
	assert_eq(asm.assembled.size(), immediate_assembled.size(), "assembled bytecode size")
	assert_eq(asm.assembled, immediate_assembled, "testing immediate addressing")

func test_zp_addressing():
	asm.asm_str = zp_str
	var success = asm.assemble()
	assert_eq(success, OK, "tests to make sure the code for testing zero-page addressing assembled with no errors")
	assert_eq(asm.assembled.size(), zp_assembled.size(), "assembled bytecode size")
	assert_eq(asm.assembled, zp_assembled, "testing zero-page addressing")

func test_zpx_addressing():
	asm.asm_str = zpx_str
	var success = asm.assemble()
	assert_eq(success, OK, "tests to make sure the code for testing zero-page,x addressing assembled with no errors")
	assert_eq(asm.assembled.size(), zpx_assembled.size(), "assembled bytecode size")
	assert_eq(asm.assembled, zpx_assembled, "testing zero-page,x addressing")

func test_zpy_addressing():
	asm.asm_str = zpy_str
	var success = asm.assemble()
	assert_eq(success, OK, "tests to make sure the code for testing zero-page,y addressing assembled with no errors")
	assert_eq(asm.assembled.size(), zpy_assembled.size(), "assembled bytecode size")
	assert_eq(asm.assembled, zpy_assembled, "testing zero-page,y addressing")

func test_abs_addressing():
	asm.asm_str = abs_str
	var success = asm.assemble()
	assert_eq(success, OK, "tests to make sure the code for testing absolute addressing assembled with no errors")
	assert_eq(asm.assembled.size(), abs_assembled.size(), "assembled bytecode size")
	assert_eq(asm.assembled, abs_assembled, "testing absolute addressing")

func test_absx_addressing():
	asm.asm_str = absx_str
	var success = asm.assemble()
	assert_eq(success, OK, "tests to make sure the code for testing absolute,x addressing assembled with no errors")
	assert_eq(asm.assembled.size(), absx_assembled.size(), "assembled bytecode size")
	assert_eq(asm.assembled, absx_assembled, "testing absolute,x addressing")

func test_absy_addressing():
	asm.asm_str = absy_str
	var success = asm.assemble()
	assert_eq(success, OK, "tests to make sure the code for testing absolute,y addressing assembled with no errors")
	assert_eq(asm.assembled.size(), absy_assembled.size(), "assembled bytecode size")
	assert_eq(asm.assembled, absy_assembled, "testing absolute,y addressing")

func test_indx_addressing():
	asm.asm_str = indx_str
	var success = asm.assemble()
	assert_eq(success, OK, "tests to make sure the code for testing indexed indirect addressing assembled with no errors")
	assert_eq(asm.assembled.size(), indx_assembled.size(), "assembled bytecode size")
	assert_eq(asm.assembled, indx_assembled, "testing indexed indirect addressing")

func test_indy_addressing():
	asm.asm_str = indy_str
	var success = asm.assemble()
	assert_eq(success, OK, "tests to make sure the code for testing indirect indexed addressing assembled with no errors")
	assert_eq(asm.assembled.size(), indy_assembled.size(), "assembled bytecode size")
	assert_eq(asm.assembled, indy_assembled, "testing indirect indexed addressing")

func test_addrmode():
	asm.asm_str = addr_modes_str
	var success = asm.assemble()
	assert_eq(success, OK, "tests to make sure the code assembled with no errors")
	assert_eq(asm.assembled.size(), addr_modes_assembled.size(), "test to make sure we're getting the correct # of bytes")
	for b in range(asm.assembled.size()):
		assert_eq(asm.assembled[b], addr_modes_assembled[b], "Checking asm.assembled[%d]" % b)
	assert_eq(asm.assembled, addr_modes_assembled, "'nop' uses implied addressing")

