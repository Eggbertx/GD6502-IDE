extends Node

# status register bits
const STATUS_NONE = 0
const STATUS_CARRY = 1 
const STATUS_ZERO = 2
const STATUS_INTERRUPT = 4
const STATUS_BCD = 8
const STATUS_BREAK = 16
const STATUS_OVERFLOW = 64
const STATUS_NEGATIVE = 128

const M6502_STOPPED = 0
const M6502_RUNNING = 1
const M6502_PAUSED = 2

const RAM_END = 0x05FF
const PC_START = 0x0600


# registers
var accumulator = 0
var x = 0
var y = 0
var SP = 0
var PC = PC_START
var status = M6502_STOPPED
var memory = []
var memory_size = 0
var opcode = Opcodes.BRK
var logger: Node

func _ready():
	reset()
	logger = null

func load_bytes(bytes:PoolByteArray):
	memory.resize(PC_START + bytes.size())
	for b in bytes:
		memory[PC_START + b] = bytes[b]

func set_logger(newlogger):
	logger = newlogger

func print_info():
	if logger != null:
		logger.write_line("Accumulator: %x" % accumulator)
		logger.write_line("X: %x" % x)
		logger.write_line("Y: %x" % y)
		logger.write_line("Stack pointer: %x" % SP)
		logger.write_line("PC: %x" % PC)
		logger.write_line("Opcode: %x" % opcode)

#func _process(delta):
#	pass

func reset(state:int = status):
	accumulator = 0
	x = 0
	y = 0
	SP = 0
	PC = PC_START
	status = state

# basic memory operations
func pop_byte():
	var popped = memory[PC] & 0xFF
	PC += 1
	return popped

func push_byte(byte:int):
	memory[PC] = byte & 0xFF
	PC += 1
	
func pop_word():
	return pop_byte() + (pop_byte() << 8)

func push_word(byte:int):
	push_byte(byte & 0xFF)
	push_byte((byte >> 8) & 0xFF)

func execute(new_PC = -1):
	if status == M6502_STOPPED or status == M6502_PAUSED:
		return
	if new_PC > -1:
		PC = new_PC
	#print_info()
	# opcode = pop_byte()
	#match opcode:
	#	Opcodes.BRK:
	#		status = M6502_STOPPED

