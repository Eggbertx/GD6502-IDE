# Testing STA, STX, and STY instructions

class_name STAXYTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

var sta_assembled = PackedByteArray([
	0xa9, 0xab, 0xa2, 0x01, 0xa0, 0x02, 0x85, 0x01, 0x95, 0x01, 0x8d, 0x23, 0x01, 0x9d, 0x23, 0x01, 
	0x99, 0x23, 0x01, 0xa9, 0x01, 0x85, 0x03, 0x85, 0x04, 0x81, 0x02, 0xa9, 0x05, 0x85, 0x04, 0xa9, 
	0xfd, 0x85, 0x03, 0x91, 0x03
])

var stx_assembled = PackedByteArray([
	0xa2, 0x01, 0xa0, 0x02, 0x86, 0x04, 0x96, 0x05, 0x8e, 0x23, 0x01 
])

var sty_assembled = PackedByteArray([
	0xa0, 0x01, 0xa2, 0x02, 0x84, 0x04, 0x94, 0x05, 0x8c, 0x23, 0x01 
])

var cpu := CPU.new()
var asm := Assembler.new()

func before():
	auto_free(cpu)
	auto_free(asm)

func before_test():
	cpu.unload_rom()
	cpu.reset()

func test_sta():
	asm.asm_str = """
lda #$ab
ldx #$01
ldy #$02
sta $01 ; zp
sta $01,x ; zp,x
sta $0123 ; abs
sta $0123,x ; abs,x
sta $0123,y ; abs,y
lda #$01
sta $03
sta $04
sta ($02,x) ; indexed indirect
lda #$05
sta $04
lda #$fd
sta $03
sta ($03),y ; indirect indexed
"""
	assert_int(asm.assemble()).is_equal(OK)
	assert_int(asm.assembled.size()).is_equal(sta_assembled.size())
	assert_array(asm.assembled).is_equal(sta_assembled)
	cpu.load_rom(asm.assembled)
	cpu.step(3)
	assert_int(cpu.A).is_equal(0xab)
	assert_int(cpu.X).is_equal(0x01)
	assert_int(cpu.Y).is_equal(0x02)
	cpu.step()
	assert_int(cpu.memory[1]).is_equal(0xab)
	cpu.step()
	assert_int(cpu.memory[2]).is_equal(0xab)
	cpu.step()
	assert_int(cpu.memory[0x0123]).is_equal(0xab)
	cpu.step()
	assert_int(cpu.memory[0x0124]).is_equal(0xab)
	cpu.step()
	assert_int(cpu.memory[0x0125]).is_equal(0xab)
	cpu.step(3)
	assert_int(cpu.memory[0x03]).is_equal(0x01)
	assert_int(cpu.memory[0x04]).is_equal(0x01)
	cpu.step()
	assert_int(cpu.memory[0x0101]).is_equal(0x01)
	cpu.step(5)
	assert_int(cpu.memory[0x05ff]).is_equal(0xfd)

func test_stx():
	asm.asm_str = """
ldx #$01
ldy #$02
stx $04
stx $05,y
stx $0123
"""
	assert_int(asm.assemble()).is_equal(OK)
	assert_int(asm.assembled.size()).is_equal(stx_assembled.size())
	assert_array(asm.assembled).is_equal(stx_assembled)
	cpu.load_rom(asm.assembled)
	cpu.step(5)
	assert_int(cpu.X).is_equal(0x01)
	assert_int(cpu.Y).is_equal(0x02)
	assert_int(cpu.memory[0x04]).is_equal(0x01)
	assert_int(cpu.memory[0x07]).is_equal(0x01)
	assert_int(cpu.memory[0x0123]).is_equal(0x01)

func test_sty():
	asm.asm_str = """
ldy #$01
ldx #$02
sty $04
sty $05,x
sty $0123
"""
	assert_int(asm.assemble()).is_equal(OK)
	assert_int(asm.assembled.size()).is_equal(sty_assembled.size())
	assert_array(asm.assembled).is_equal(sty_assembled)
	cpu.load_rom(asm.assembled)
	cpu.step(5)
	assert_int(cpu.Y).is_equal(0x01)
	assert_int(cpu.X).is_equal(0x02)
	assert_int(cpu.memory[0x04]).is_equal(0x01)
	assert_int(cpu.memory[0x07]).is_equal(0x01)
	assert_int(cpu.memory[0x0123]).is_equal(0x01)
