extends Control

class_name UI

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
@onready var code_edit := $MainPanel/AssemblyCodeEdit
@onready var highlighter :SyntaxHighlighter = code_edit.syntax_highlighter
@onready var screen:Screen = $MainPanel/Screen
@onready var register_label:RichTextLabel = $MainPanel/RegisterInfo
@onready var find_dialog:FindReplaceDialog = $FindReplaceDialog

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
	Menus.set_menu_items(file_menu, Menus.file_items)
	Menus.set_menu_items(emulator_menu, Menus.emulator_items)
	Menus.set_menu_items(help_menu, Menus.help_items)
	set_emulation_menu_items_enabled(false)

func set_emulation_menu_items_enabled(enabled: bool):
	for i in range(Menus.EMULATOR_START,Menus.EMULATOR_CLEAR_LOG):
		emulator_menu.set_item_disabled(i, !enabled)

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
	file_item_selected.emit(id)

func emulator_menu_selected(id):
	emulator_item_selected.emit(id)

func help_menu_selected(id):
	help_item_selected.emit(id)

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


func _on_FileDialog_file_selected(path):
	loaded_file = path
	if path != "":
		file_selected.emit(path)

func _on_FileDialog_hide():
	loaded_file = ""

func _on_GoToAddressDialog_confirmed():
	log_print("Going to address %d" % $GoToAddressDialog.get_address())

func _on_tab_container_tab_changed(tab: int):
	print("Switching to tab %s" % $MainPanel/TabContainer.get_tab_title(tab))

func _on_assembly_code_edit_find_triggered():
	find_dialog.show()

func _on_find_replace_dialog_find_triggered(text: String):
	code_edit.set_search_flags(TextEdit.SEARCH_BACKWARDS)
	code_edit.set_search_text(text)
	code_edit.add_selection_for_next_occurrence()
	code_edit.delete_selection()
	#var col = code_edit.get_caret_column()
	#var line = code_edit.get_caret_line()

func _on_find_replace_dialog_replace_triggered(_find: String, _replace: String):
	pass # Replace with function body.

func _on_find_replace_dialog_cancelled():
	code_edit.delete_selection()

func _on_assembly_code_edit_clear_search_triggered():
	code_edit.delete_selection()

func _on_screen_clicked() -> void:
	code_edit.release_focus()
