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
const SETTINGS_PATH = "user://settings.save"
var logger: Node
var asm: Assembler
onready var emulator_menu = $UI/MenuPanel/HBoxContainer/EmulatorButton.get_popup()

func _ready():
	load_settings()
	logger = $UI/MainPanel/TabContainer/Status
	$CPU.set_logger(logger)
	asm = Assembler.new()
	asm.set_logger(logger)
	asm.set_hexdump_logger($UI/MainPanel/TabContainer/Hexdump)
	var args = OS.get_cmdline_args()
	if args.size() > 0:
		open_rom(args[0])

func _input(event):
	if event is InputEventKey:
		if $CPU.get_status() == $CPU.M6502_RUNNING and $CPU.memory.size() >= 0xFF:
			$CPU.memory[0xFF] = event.scancode & 0xFF

func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_settings()

func save_settings():
	var file = File.new()
	if file.open(SETTINGS_PATH, File.WRITE) != OK:
		OS.alert("Failed saving settings")
		return
	file.store_var(OS.window_maximized)
	file.store_var(OS.window_size)
	file.close()

func load_settings():
	var file = File.new()
	if !file.file_exists(SETTINGS_PATH):
		return
	if file.open(SETTINGS_PATH, File.READ) != OK:
		$UI.log_print("Failed loading settings")
		return

	OS.window_maximized = file.get_var()
	OS.window_size = file.get_var()
	file.close()

func assemble_code():
	var success = asm.assemble()
	asm.update_hexdump()
	$CPU.reset($CPU.M6502_STOPPED)
	emulator_menu.set_item_disabled(1, asm.asm_str == "" or success != OK)
	if success != OK:
		$UI/MainPanel/TabContainer.current_tab = 0
	return success

func open_rom(path):
	$UI.log_print("Loading file: %s" % path)
	$UI.log_line()
	$CPU.memory.resize($CPU.PC_START)
	var file = File.new()
	var err = file.open(path, File.READ)
	if err != OK:
		$UI.log("Got error code %d while loading %s" % [err, path])
		return

	asm.asm_str = file.get_as_text()
	$UI.set_assembly_source(asm.asm_str)
	file.close()
	var success = assemble_code()
	if success == OK:
		$CPU.reset($CPU.M6502_RUNNING)
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
			assemble_code()
		EMULATOR_START:
			$CPU.set_status(CPU.M6502_RUNNING)
		EMULATOR_PAUSED:
			var status = $CPU.get_status()
			if status == CPU.M6502_RUNNING:
				$CPU.set_status(CPU.M6502_PAUSED)
			elif status == CPU.M6502_PAUSED:
				$CPU.set_status(CPU.M6502_RUNNING)
		EMULATOR_STEP_FORWARD:
			logger.write_line("Stepping forward")
		EMULATOR_STEP_BACK:
			logger.write_line("Stepping back")
		EMULATOR_STOP:
			$CPU.set_status(CPU.M6502_STOPPED)
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


func _on_CPU_status_changed(new_status: int, old_status: int) -> void:
	match new_status:
		CPU.M6502_STOPPED:
			logger.write_line("Stopping emulator")
		CPU.M6502_RUNNING:
			if old_status == CPU.M6502_PAUSED:
				logger.write_line("Unpausing emulator")
			else:
				logger.write_line("Starting emulator")
		CPU.M6502_PAUSED:
			if old_status == CPU.M6502_RUNNING:
				logger.write_line("Pausing emulator")
