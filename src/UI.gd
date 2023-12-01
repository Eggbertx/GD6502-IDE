extends Control

class_name UI

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
	EMULATOR_PAUSED,
	EMULATOR_RESET,
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

signal file_selected(path:String)
signal file_item_selected(id:int)
signal emulator_item_selected(id:int)
signal help_item_selected(id:int)

const pixel_scale = 8
const screen_size = 32
const register_label_format = "A: $%02X    X: $%02X    Y: $%02X    PC: $%04X    SP: $%04X  |  Flags: [color=%s][hint=Negative]N[/hint][/color][color=%s][hint=Overflow]V[/hint][/color][color=777]-[/color][color=%s][hint=BRK]B[/hint][/color][color=%s][hint=BCD]D[/hint][/color][color=%s][hint=Interrupt]I[/hint][/color][color=%s][hint=Zero]Z[/hint][/color][color=%s][hint=Carry]C[/hint][/color]"

@onready var file_menu:PopupMenu = $MenuPanel/HBoxContainer/FileButton.get_popup()
@onready var emulator_menu:PopupMenu = $MenuPanel/HBoxContainer/EmulatorButton.get_popup()
@onready var help_menu:PopupMenu = $MenuPanel/HBoxContainer/HelpButton.get_popup()
@onready var code_edit := $MainPanel/CodeEdit
@onready var highlighter :SyntaxHighlighter = code_edit.syntax_highlighter
@onready var screen:Screen = $MainPanel/Screen

var loaded_file = ""

func _ready():
	init_menus()
	get_viewport().gui_embed_subwindows = false
	file_menu.connect("id_pressed", file_menu_selected)
	emulator_menu.connect("id_pressed", emulator_menu_selected)
	help_menu.connect("id_pressed", help_menu_selected)
	init_syntax_highlighting()

func init_syntax_highlighting():
	code_edit.grab_focus()
	for opcode in Opcodes.dict:
		highlighter.keyword_colors[opcode] = Color.CYAN
		highlighter.keyword_colors[opcode.to_lower()] = Color.CYAN

func init_menus():
	file_menu.add_item("Open File")
	file_menu.add_item("Open Example")
	file_menu.add_separator()
	file_menu.add_item("Save")
	file_menu.add_item("Save As")
	file_menu.add_separator()
	file_menu.add_item("Exit")
	emulator_menu.add_item("Assemble")
	emulator_menu.add_item("Start")
	emulator_menu.add_check_item("Paused")
	emulator_menu.add_item("Reset")
	emulator_menu.add_item("Stop")
	emulator_menu.add_separator()
	emulator_menu.add_item("Step Forward")
	emulator_menu.add_item("Step Back")
	emulator_menu.add_item("Go To Address")
	emulator_menu.add_separator()
	emulator_menu.add_item("Clear Log")
	help_menu.add_item("GD6502 on GitHub")
	help_menu.add_item("6502.org")
	help_menu.add_item("MOS 6502 Wikipedia")
	help_menu.add_item("Easy 6502")
	for i in range(1,9):
		emulator_menu.set_item_disabled(i, true)

func pixel_size():
	return get_viewport().size.x / screen_size

func open_file_dialog(examples = true):
	if $FileDialog.visible:
		return
	$FileDialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	if examples:
		$FileDialog.access = FileDialog.ACCESS_RESOURCES
		$FileDialog.set_title("Open example")
		$FileDialog.current_dir = "res://examples/"
	else:
		$FileDialog.access = FileDialog.ACCESS_FILESYSTEM
		$FileDialog.set_title("Open file")
	$FileDialog.popup()

func set_assembly_source(text: String, clear_undo = true):
	code_edit.text = text
	if clear_undo:
		code_edit.clear_undo_history()

func open_goto():
	$GoToAddressDialog.visible = true

func file_menu_selected(id):
	emit_signal("file_item_selected", id)

func emulator_menu_selected(id):
	emit_signal("emulator_item_selected", id)

func help_menu_selected(id):
	emit_signal("help_item_selected", id)

func hide_screen():
	screen.hide()

func show_screen():
	screen.show()

func log_print(s):
	$MainPanel/TabContainer/Status.write_line(s)
	
func log_reset():
	$MainPanel/TabContainer/Status.clear()
	
func log_line():
	$MainPanel/TabContainer/Status.write_linebreak()

func update_register_info(a: int, x: int, y: int, pc: int, sp: int, flags: int):
	$MainPanel/RegisterInfo.parse_bbcode(register_label_format % [
		a, x, y, pc, sp,
		"green" if (flags & CPU.flag_bit.NEGATIVE) == CPU.flag_bit.NEGATIVE else "red",
		"green" if (flags & CPU.flag_bit.OVERFLOW) == CPU.flag_bit.OVERFLOW else "red",
		"green" if (flags & CPU.flag_bit.BREAK) == CPU.flag_bit.BREAK else "red",
		"green" if (flags & CPU.flag_bit.BCD) == CPU.flag_bit.BCD else "red",
		"green" if (flags & CPU.flag_bit.INTERRUPT) == CPU.flag_bit.INTERRUPT else "red",
		"green" if (flags & CPU.flag_bit.ZERO) == CPU.flag_bit.ZERO else "red",
		"green" if (flags & CPU.flag_bit.CARRY) == CPU.flag_bit.CARRY else "red",
	])

func _unhandled_key_input(event):
	match event.keycode:
		KEY_F1:
			# load non-packaged file
			open_file_dialog(false)
		KEY_F2:
			# load example
			open_file_dialog(true)

func _on_FileDialog_file_selected(path):
	loaded_file = path
	if path != "":
		emit_signal("file_selected", path)

func _on_FileDialog_hide():
	loaded_file = ""

func _on_GoToAddressDialog_confirmed():
	log_print("Going to address %d" % $GoToAddressDialog.get_address())

func _on_tab_container_tab_changed(tab: int):
	print("Switching to tab %s" % $MainPanel/TabContainer.get_tab_title(tab))
