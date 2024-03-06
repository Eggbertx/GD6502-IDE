extends Window

class_name FindReplaceDialog

signal find_triggered(text: String)
signal replace_triggered(find: String, replace: String)
signal cancelled()

@export var find_text := "":
	get:
		return $PanelContainer/MarginContainer/VBoxContainer/GridContainer/FindEdit.text
	set(v):
		$PanelContainer/MarginContainer/VBoxContainer/GridContainer/FindEdit.text = v

@export var replace_text := "":
	get:
		return $PanelContainer/MarginContainer/VBoxContainer/GridContainer/ReplaceEdit.text
	set(v):
		$PanelContainer/MarginContainer/VBoxContainer/GridContainer/ReplaceEdit.text = v


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _clear(hide_dialog: bool = true):
	if hide_dialog:
		hide()
	find_text = ""
	replace_text = ""

func _cancel():
	_clear()
	cancelled.emit()

func _shortcut_input(event: InputEvent):
	if event.keycode == KEY_ESCAPE:
		_clear()

func _on_find_button_pressed():
	find_triggered.emit(find_text)

func _on_replace_button_pressed():
	replace_triggered.emit(find_text, replace_text)

func _on_cancel_button_pressed():
	_cancel()

func _on_close_requested():
	_clear()
