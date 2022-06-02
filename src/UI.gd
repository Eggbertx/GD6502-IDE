extends Control

signal file_selected
signal game_item_selected
signal emulator_item_selected
signal help_item_selected

const pixel_scale = 8
const screen_size = 32

onready var game_menu = $Panel/HBoxContainer/GameButton.get_popup()
onready var emulator_menu = $Panel/HBoxContainer/EmulatorButton.get_popup()
onready var help_menu = $Panel/HBoxContainer/HelpButton.get_popup()
var loaded_file = ""

func _ready():
	game_menu.connect("id_pressed", self, "game_menu_selected")
	emulator_menu.connect("id_pressed", self, "emulator_menu_selected")
	help_menu.connect("id_pressed", self, "help_menu_selected")


func pixel_size():
	return get_viewport().size.x / screen_size

func open_file(examples = true):
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

func open_goto():
	$GoToAddressDialog.visible = true

func game_menu_selected(id):
	emit_signal("game_item_selected", id)

func emulator_menu_selected(id):
	emit_signal("emulator_item_selected", id)

func help_menu_selected(id):
	emit_signal("help_item_selected", id)

func hide_screen():
	$VSplitContainer/Screen.hide()

func show_screen():
	$VSplitContainer/Screen.show()

func log_print(s):
	$TabContainer/Status.write_line(s)
	
func log_reset():
	$TabContainer/Status.clear()
	
func log_line():
	$TabContainer/Status.write_linebreak()


func _unhandled_key_input(event):
	match event.scancode:
		KEY_F1:
			# load non-packaged file
			open_file(false)
		KEY_F2:
			# load example
			open_file(true)

func _on_FileDialog_file_selected(path):
	loaded_file = path
	if path != "":
		emit_signal("file_selected", path)

func _on_FileDialog_hide():
	loaded_file = ""

func _on_GoToAddressDialog_confirmed():
	log_print("Going to address %d" % $GoToAddressDialog.get_address())
