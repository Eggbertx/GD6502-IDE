extends Node

enum {
	GAME_FILE,
	GAME_EXAMPLE,
	GAME_SEPARATOR,
	GAME_QUIT,
}
enum {
	HELP_REPO,
	HELP_6502ASM,
	HELP_EASY6502,
	HELP_6502ORG
}

enum {
	EMULATOR_START
	EMULATOR_PAUSED
	EMULATOR_STEP_FORWARD
	EMULATOR_STEP_BACK
	EMULATOR_SEPARATOR
	EMULATOR_STOP
	EMULATOR_GOTO
	EMULATOR_CLEAR_LOG
}

const REPO_URL = "https://github.com/Eggbertx/GD6502"
var logger: Node

func _ready():
	logger = $UI/TabContainer/Status
	Console.add_command("loadAsm", self, "open_rom")\
 		.set_description("Loads a 6502asm-compatible assembly source file")\
 		.add_argument("file", TYPE_STRING, "The source file to be loaded")\
 		.register()
	Console.add_command("assembleLine", self, "assemble_line")\
		.set_description("Assembles a line of text and prints the memory info and hexdump")\
		.add_argument("opcode", TYPE_STRING, "A 6502 opcode")\
		.add_argument("arg", TYPE_STRING, "A memory address or value. If none is provided, implied addressing is assumed.")\
		.register()

	$CPU.debug = OS.is_debug_build()
	$CPU.set_logger($UI/TabContainer/Status)
	var args = OS.get_cmdline_args()
	if args.size() > 0:
		open_rom(args[0])

func _input(event):
	if event is InputEventKey:
		match event.scancode:
			KEY_ESCAPE:
				get_tree().quit(0)

# delta is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func assemble_line(opcode:String, args:String = ""):
	var asm = Assembler.new()
	asm.set_logger(logger)
	var line = "%s %s" % [opcode, args]
	asm.asm_str = line
	logger.write_line(line)
	print()
	asm.assemble()

func open_rom(path):
	$UI.log_print("Loading file: %s" % path)
	$UI.log_line()
	$CPU.memory.resize($CPU.PC_START)
	var err = $CPU.load_file(path)
	if err:
		$UI.log("Error loading %s" % path)
		return
	$CPU.reset($CPU.M6502_RUNNING)
	$CPU.execute()

func _on_UI_game_item_selected(id):
	match id:
		GAME_FILE:
			$UI.open_file(false)
		GAME_EXAMPLE:
			$UI.open_file(true)
		GAME_QUIT:
			get_tree().quit(0)

func _on_UI_emulator_item_selected(id) -> void:
	logger.write_line(id)
	match id:
		EMULATOR_START:
			logger.write_line("Starting emulator")
		EMULATOR_PAUSED:
			logger.write_line("Toggling pause")
		EMULATOR_STEP_FORWARD:
			logger.write_line("Stepping forward")
		EMULATOR_STEP_BACK:
			logger.write_line("Stepping back")
		EMULATOR_STOP:
			logger.write_line("Stopping emulator")
		EMULATOR_GOTO:
			$UI/GoToAddressDialog.show()
		EMULATOR_CLEAR_LOG:
			$UI/TabContainer/Status.clear()

func _on_UI_help_item_selected(id):
	match id:
		HELP_REPO:
			OS.shell_open(REPO_URL)
		HELP_6502ASM:
			OS.shell_open("http://6502asm.com/")
		HELP_EASY6502:
			OS.shell_open("https://skilldrick.github.io/easy6502/")
		HELP_6502ORG:
			OS.shell_open("http://www.6502.org/")

func _on_UI_file_selected(file):
	open_rom(file)
