class_name BranchLabelTest
extends GdUnitTestSuite

const out_of_branch_range_str = """
loop:
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
lda $1234
beq loop
"""

const label_before_branch = """
loop:
lda $1234
beq loop
"""

const label_after_branch = """
beq loop
nop
loop:
brk
"""

func test_label_before_branch():
	var asm = Assembler.new()
	asm.asm_str = label_before_branch
	assert_int(asm.assemble()).is_equal(OK)
	assert_array(asm.assembled).is_equal(PackedByteArray([0xad, 0x34, 0x12, 0xf0, 0xfb]))
	assert_int(asm.labels["loop"]).is_equal(0x600)

func test_label_after_branch():
	var asm = Assembler.new()
	asm.asm_str = label_after_branch
	assert_int(asm.assemble()).is_equal(OK)
	assert_array(asm.assembled).is_equal(PackedByteArray([0xf0, 0x1, 0xea, 0x00]))
	assert_int(asm.labels["loop"]).is_equal(0x603)

func test_out_of_branch_range():
	var asm = Assembler.new()
	asm.asm_str = out_of_branch_range_str
	assert_int(asm.assemble()).is_equal(Assembler.INVALID_BRANCH)
	assert_array(asm.assembled).is_empty()
