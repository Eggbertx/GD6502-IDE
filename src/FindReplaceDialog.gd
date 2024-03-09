extends Window

class_name FindReplaceDialog

signal find_triggered(text: String)
signal replace_triggered(find: String, replace: String)
signal cancelled()

@onready var find_edit: LineEdit = $PanelContainer/MarginContainer/VBoxContainer/GridContainer/FindEdit
@onready var replace_edit: LineEdit = $PanelContainer/MarginContainer/VBoxContainer/GridContainer/ReplaceEdit

@export var find_text := "":
	get:
		return find_edit.text
	set(v):
		find_edit.text = v

@export var replace_text := "":
	get:
		return replace_edit.text
	set(v):
		replace_edit.text = v


# Called when the node enters the scene tree for the first time.
func _ready():
	find_edit.grab_focus()

func _clear(hide_dialog: bool = true):
	if hide_dialog:
		hide()
	find_text = ""
	replace_text = ""

func _cancel():
	_clear()
	cancelled.emit()

func _shortcut_input(event: InputEvent):
	match event.keycode:
		KEY_ESCAPE:
			_clear()
		KEY_ENTER:
			var focused = gui_get_focus_owner()
			if focused == replace_edit and find_text != "":
				replace_triggered.emit(find_text, replace_text)
			elif not focused is Button:
				find_triggered.emit(find_text)

func _on_find_button_pressed():
	find_triggered.emit(find_text)

func _on_replace_button_pressed():
	replace_triggered.emit(find_text, replace_text)

func _on_cancel_button_pressed():
	_cancel()

func _on_close_requested():
	_clear()

func _on_visibility_changed():
	if visible:
		find_edit.grab_focus()
