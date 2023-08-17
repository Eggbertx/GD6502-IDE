extends Control

signal file_selected
signal file_item_selected
signal emulator_item_selected
signal help_item_selected

const pixel_scale = 8
const screen_size = 32

@onready var file_menu:PopupMenu = $MenuPanel/HBoxContainer/FileButton.get_popup()
@onready var emulator_menu:PopupMenu = $MenuPanel/HBoxContainer/EmulatorButton.get_popup()
@onready var help_menu:PopupMenu = $MenuPanel/HBoxContainer/HelpButton.get_popup()
@onready var code_edit := $MainPanel/CodeEdit
var loaded_file = ""

func _ready():
	file_menu.connect("id_pressed", Callable(self, "file_menu_selected"))
	emulator_menu.connect("id_pressed", Callable(self, "emulator_menu_selected"))
	help_menu.connect("id_pressed", Callable(self, "help_menu_selected"))
	init_syntax_highlighting()

func init_syntax_highlighting():
	code_edit.grab_focus()
	code_edit.add_comment_delimiter(";", "", true)
	for opcode in Opcodes.dict:
		code_edit.add_code_completion_option(CodeEdit.KIND_FUNCTION, opcode, opcode)

func pixel_size():
	return get_viewport().size.x / screen_size

func open_file_dialog(examples = true):
	if $FileDialog.visible:
		return
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
	$MainPanel/Screen.hide()

func show_screen():
	$MainPanel/Screen.show()

func log_print(s):
	$MainPanel/TabContainer/Status.write_line(s)
	
func log_reset():
	$MainPanel/TabContainer/Status.clear()
	
func log_line():
	$MainPanel/TabContainer/Status.write_linebreak()

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
