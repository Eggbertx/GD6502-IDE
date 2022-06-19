extends Node

enum {
	FILE_OPEN_FILE,
	FILE_OPEN_EXAMPLE,
	FILE_SEPARATOR1,
	FILE_SAVE_FILE,
	FILE_SAVE_FILE_AS,
	FILE_SEPARATOR2,
	FILE_QUIT,
}
enum {
	HELP_REPO,
	HELP_6502ASM,
	HELP_EASY6502,
	HELP_6502ORG
}

enum {
	EMULATOR_ASSEMBLE
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
var asm: Assembler

func _ready():
	logger = $UI/MainPanel/TabContainer/Status
	$CPU.set_logger(logger)
	asm = Assembler.new()
	asm.set_logger(logger)
	var args = OS.get_cmdline_args()
	if args.size() > 0:
		open_rom(args[0])

func _input(event):
	if event is InputEventKey:
		if $CPU.status == $CPU.M6502_RUNNING and $CPU.memory.size() >= 0xFF:
			$CPU.memory[0xFF] = event.scancode & 0xFF

# delta is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func open_rom(path):
	$UI.log_print("Loading file: %s" % path)
	$UI.log_line()
	$CPU.memory.resize($CPU.PC_START)
	var file = File.new()
	var err = file.open(path, File.READ)
	if err != OK:
		$UI.log("Error loading %s" % err)
		return

	asm.asm_str = file.get_as_text()
	$UI.set_assembly_source(asm.asm_str)
	file.close()
	var success = asm.assemble()
	$CPU.reset($CPU.M6502_RUNNING)
	if success == OK:
		$CPU.execute()

func _on_UI_file_item_selected(id):
	match id:
		FILE_OPEN_FILE:
			$UI.open_file_dialog(false)
		FILE_OPEN_EXAMPLE:
			$UI.open_file_dialog(true)
		FILE_QUIT:
			get_tree().quit(0)

func _on_UI_emulator_item_selected(id) -> void:
	match id:
		EMULATOR_ASSEMBLE:
			asm.asm_str = $UI/MainPanel/TextEdit.text
			var success = asm.assemble()
			$CPU.reset($CPU.M6502_RUNNING)
			if success == OK:
				$CPU.execute()
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
			$UI/MainPanel/TabContainer/Status.clear()

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
