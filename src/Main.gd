extends Node

enum {
	FILE_OPEN_FILE,
	FILE_OPEN_EXAMPLE,
	FILE_SEPARATOR1,
	FILE_SAVE,
	FILE_SAVE_AS,
	FILE_SEPARATOR2,
	FILE_EXIT,
}
enum {
	EMULATOR_ASSEMBLE,
	EMULATOR_START,
	EMULATOR_PAUSE,
	EMULATOR_STOP,
	EMULATOR_SEPARATOR1,
	EMULATOR_STEP_FORWARD,
	EMULATOR_STEP_BACK,
	EMULATOR_GOTO,
	EMULATOR_SEPARATOR2,
	EMULATOR_CLEAR_LOG
}
enum {
	HELP_REPO,
	HELP_6502ORG,
	HELP_WP_6502,
	HELP_EASY6502
}

const REPO_URL = "https://github.com/Eggbertx/GD6502"
const SETTINGS_PATH = "user://settings.save"
@onready var logger:TextEdit = $UI/MainPanel/TabContainer/Status
var asm: Assembler

func _ready():
	load_settings()
	$CPU.set_logger(logger)
	asm = Assembler.new()
	asm.set_logger(logger)
	asm.set_hexdump_logger($UI/MainPanel/TabContainer/Hexdump)
	var args = OS.get_cmdline_args()
	if args.size() > 1:
		open_rom(args[1])

func _input(event):
	if event is InputEventKey:
		if $CPU.get_status() == $CPU.M6502_RUNNING and $CPU.memory.size() >= 0xFF:
			$CPU.memory[0xFF] = event.keycode & 0xFF

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_EXIT_TREE:
		save_settings()

func save_settings():
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file == null:
		OS.alert("Failed saving settings")
		printerr(FileAccess.get_open_error())
		return
	file.store_var((get_window().mode == Window.MODE_MAXIMIZED))
	file.store_var(get_window().size)
	file.close()

func load_settings():
	if !FileAccess.file_exists(SETTINGS_PATH):
		return

	var file := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if file == null:
		$UI.log_print("Failed loading settings: %" % FileAccess.get_open_error())
		return

	get_window().mode = Window.MODE_MAXIMIZED if (file.get_var()) else Window.MODE_WINDOWED
	get_window().size = file.get_var()
	file.close()

func assemble_code():
	var success = asm.assemble()
	asm.update_hexdump()
	$CPU.reset($CPU.M6502_STOPPED)
	$UI/MainPanel/TabContainer.current_tab = 0
	return success

func open_rom(path: String):
	$UI.log_print("Loading file: %s" % path)
	$UI.log_line()
	$CPU.memory.resize($CPU.PC_START)
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		$UI.log_print("Got error code %d while loading %s" % [FileAccess.get_open_error(), path])
		return

	asm.asm_str = file.get_as_text()
	$UI.set_assembly_source(asm.asm_str)
	file.close()
	var success = assemble_code()
	if success == OK:
		$CPU.reset($CPU.M6502_RUNNING)
		$CPU.execute()

func enable_emulation(enabled: bool):
	if enabled:
		$CPU.load_bytes(asm.assembled)
	$UI.emulator_menu.set_item_disabled(EMULATOR_START, !enabled)
	$UI.emulator_menu.set_item_disabled(EMULATOR_PAUSE, !enabled)
	$UI.emulator_menu.set_item_disabled(EMULATOR_STOP, !enabled)
	$UI.emulator_menu.set_item_disabled(EMULATOR_STEP_FORWARD, !enabled)
	$UI.emulator_menu.set_item_disabled(EMULATOR_GOTO, !enabled)

func _on_ui_file_item_selected(id: int):
	match id:
		FILE_OPEN_FILE:
			$UI.open_file_dialog(false)
		FILE_OPEN_EXAMPLE:
			$UI.open_file_dialog(true)
		FILE_EXIT:
			get_tree().quit(0)

func _on_ui_emulator_item_selected(id: int):
	match id:
		EMULATOR_ASSEMBLE:
			asm.asm_str = $UI/MainPanel/CodeEdit.text
			enable_emulation(assemble_code() == OK)
		EMULATOR_START:
			$CPU.set_status(CPU.M6502_RUNNING)
			$ClockTimer.start()
			$CPU.execute()
		EMULATOR_PAUSE:
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
			$ClockTimer.stop()
		EMULATOR_GOTO:
			$UI/GoToAddressDialog.show()
		EMULATOR_CLEAR_LOG:
			$UI/MainPanel/TabContainer/Status.clear()

func _on_ui_help_item_selected(id: int):
	match id:
		HELP_REPO:
			OS.shell_open(REPO_URL)
		HELP_6502ORG:
			OS.shell_open("http://www.6502.org/")
		HELP_WP_6502:
			OS.shell_open("https://en.wikipedia.org/wiki/MOS_Technology_6502")
		HELP_EASY6502:
			OS.shell_open("https://skilldrick.github.io/easy6502/")

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

func _on_clock_timer_timeout():
	if $CPU.get_status() == CPU.M6502_RUNNING:
		$CPU.execute()
		$UI.update_register_info($CPU.A, $CPU.X, $CPU.Y, $CPU.PC, $CPU.SP)
