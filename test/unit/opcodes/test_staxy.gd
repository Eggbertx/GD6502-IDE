class_name STAXYTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

var lda_assembled = PackedByteArray([
	0xa9, 0xab, 0xa2, 0x01, 0xa0, 0x02, 0x85, 0x01, 0x95, 0x01, 0x8d, 0x23, 0x01, 0x9d, 0x23, 0x01, 
	0x99, 0x23, 0x01, 0xa9, 0x01, 0x85, 0x03, 0x85, 0x04, 0x81, 0x02, 0xa9, 0x05, 0x85, 0x04, 0xa9, 
	0xfd, 0x85, 0x03, 0x91, 0x03
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
	assert_int(asm.assembled.size()).is_equal(lda_assembled.size())
	assert_array(asm.assembled).is_equal(lda_assembled)
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
