extends Node

const REPO_URL = "https://github.com/Eggbertx/GD6502-IDE"
const SETTINGS_PATH = "user://settings.save"

@onready var logger:TextEdit = $UI/MainPanel/TabContainer/Status
@onready var screen:Screen = $UI/MainPanel/Screen
@onready var ui:UI = $UI
@onready var emulator:EmulatorManager = $EmulatorManager
var cpu: ExampleCPUSubclass:
	get:
		return $EmulatorManager/CPU

var asm := Assembler.new()
var executions_per_physics_process := 91
var debugging := false
# var max_wait_time := 1.0/60.0
# var wait_time: float = 0.0

func _ready():
	get_window().min_size = Vector2i(480, 560)
	load_settings()
	cpu.watched_ranges.append([0x200, 0x5ff])

	asm.set_logger(logger)
	asm.set_hexdump_logger($UI/MainPanel/TabContainer/Hexdump)
	var args = OS.get_cmdline_args()
	if args.size() == 2 and args[0] == "--asm":
		open_rom(args[1])

func _input(event):
	if event is InputEventKey:
		if emulator.get_status() == CPU.EmulationStatus.RUNNING and emulator.cpu.memory.size() >= 0xFF:
			emulator.cpu.memory[0xFF] = event.keycode & 0xFF

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_EXIT_TREE:
		save_settings()

func _physics_process(_delta):
	if emulator.get_status() != CPU.EmulationStatus.RUNNING:
		return
	for i in range(executions_per_physics_process):
		run_cpu()

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
		ui.log_print("Failed loading settings: %" % FileAccess.get_open_error())
		return

	get_window().mode = Window.MODE_MAXIMIZED if (file.get_var()) else Window.MODE_WINDOWED
	get_window().size = file.get_var()
	file.close()

func assemble_code():
	var success = asm.assemble()
	asm.update_hexdump()
	emulator.reset()
	$UI/MainPanel/TabContainer.current_tab = 0
	screen.clear()
	return success

func run_cpu(force = false):
	cpu.execute(force)
	if debugging:
		update_register_label()

func update_register_label():
	$UI.update_register_info(cpu.A, cpu.X, cpu.Y, cpu.PC, cpu.SP, cpu.flags)

func open_rom(path: String):
	ui.log_print("Loading file: %s" % path)
	ui.log_line()
	cpu.memory.resize(cpu.pc_start)
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		ui.log_print("Got error code %d while loading %s" % [FileAccess.get_open_error(), path])
		return

	asm.asm_str = file.get_as_text()
	ui.set_assembly_source(asm.asm_str)
	file.close()
	var success: bool = assemble_code() == OK
	enable_emulation(success)
	if success:
		emulator.reset(CPU.EmulationStatus.STOPPED)

func enable_emulation(enabled: bool):
	if enabled:
		emulator.load_rom(asm.assembled)
	ui.set_emulation_menu_items_enabled(enabled)

func _on_ui_file_item_selected(id: int):
	match id:
		Menus.FILE_OPEN_FILE:
			ui.open_file_dialog(false)
		Menus.FILE_OPEN_EXAMPLE:
			ui.open_file_dialog(true)
		Menus.FILE_EXIT:
			get_tree().quit(0)

func _on_ui_emulator_item_selected(id: int):
	match id:
		Menus.EMULATOR_ASSEMBLE:
			asm.asm_str = ui.code_edit.text
			enable_emulation(assemble_code() == OK)
		Menus.EMULATOR_ASSEMBLE_AND_START:
			asm.asm_str = ui.code_edit.text
			if assemble_code() == OK:
				enable_emulation(true)
				emulator.set_status(CPU.EmulationStatus.RUNNING)
				run_cpu()
				debugging = false	
		Menus.EMULATOR_START:
			emulator.set_status(CPU.EmulationStatus.RUNNING)
			run_cpu()
			debugging = false
			ui.register_label.text = ""
		Menus.EMULATOR_DEBUG:
			emulator.set_status(CPU.EmulationStatus.RUNNING)
			run_cpu()
			debugging = true
		Menus.EMULATOR_PAUSED:
			var status = emulator.get_status()
			if status == CPU.EmulationStatus.RUNNING:
				ui.emulator_menu.set_item_checked(Menus.EMULATOR_PAUSED, true)
				emulator.set_status(CPU.EmulationStatus.PAUSED)
			elif status == CPU.EmulationStatus.PAUSED:
				emulator.set_status(CPU.EmulationStatus.RUNNING)
				ui.emulator_menu.set_item_checked(Menus.EMULATOR_PAUSED, false)
		Menus.EMULATOR_STEP_FORWARD:
			logger.write_line("Stepping forward")
			emulator.set_status(CPU.EmulationStatus.PAUSED)
			run_cpu(true)
		Menus.EMULATOR_STOP:
			emulator.reset(CPU.EmulationStatus.STOPPED)
		Menus.EMULATOR_GOTO:
			$UI/GoToAddressDialog.show()
		Menus.EMULATOR_CLEAR_LOG:
			$UI/MainPanel/TabContainer/Status.clear()

func _on_ui_help_item_selected(id: int):
	match id:
		Menus.HELP_REPO:
			OS.shell_open(REPO_URL)
		Menus.HELP_6502ORG:
			OS.shell_open("http://www.6502.org/")
		Menus.HELP_WP_6502:
			OS.shell_open("https://en.wikipedia.org/wiki/MOS_Technology_6502")
		Menus.HELP_EASY6502:
			OS.shell_open("https://skilldrick.github.io/easy6502/")


func _on_cpu_watched_memory_changed(location:int, new_val:int):
	if location >= 0x200 and location <= 0x5ff:
		screen.set_pixel_col(location-0x200, new_val & 0xf)


func _on_cpu_illegal_opcode(opcode: int) -> void:
	ui.log_print("Unhandled opcode: $%02X at PC %04X" % [opcode, cpu.PC])
	emulator.set_status(CPU.EmulationStatus.STOPPED, true)


func _on_emulator_manager_emulator_reset() -> void:
	update_register_label()
	if screen != null:
		screen.clear()


func _on_emulator_manager_status_changed(new_status: CPU.EmulationStatus, old_status: CPU.EmulationStatus) -> void:
	update_register_label()
	if logger == null:
		return
	match new_status:
		CPU.EmulationStatus.STOPPED:
			logger.write_line("Stopping emulator")
		CPU.EmulationStatus.RUNNING:
			if old_status == CPU.EmulationStatus.PAUSED:
				logger.write_line("Unpausing emulator")
			else:
				logger.write_line("Starting emulator")
		CPU.EmulationStatus.PAUSED:
			if old_status == CPU.EmulationStatus.RUNNING:
				logger.write_line("Pausing emulator")
		CPU.EmulationStatus.END:
			logger.write_line("Program end at PC=$%04X" % cpu.PC)


func _on_cpu_stack_filled() -> void:
	logger.write_line("6502 stack filled")


func _on_cpu_stack_emptied() -> void:
	logger.write_line("6502 stack empty")
