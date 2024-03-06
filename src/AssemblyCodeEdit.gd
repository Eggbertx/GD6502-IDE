extends CodeEdit

signal find_triggered()

var find_id = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	var menu:PopupMenu = get_menu()
	find_id = menu.item_count + 20
	menu.add_item("Find/Replace", find_id)
	menu.connect("id_pressed", find_activated)
	var ev = InputEventKey.new()
	ev.keycode = KEY_F
	ev.ctrl_pressed = true
	var shortcut = Shortcut.new()
	shortcut.events.append(ev)
	menu.set_item_shortcut(menu.get_item_index(find_id), shortcut)

func find_activated(id: int):
	if id == find_id:
		find_triggered.emit()

func _shortcut_input(event: InputEvent):
	var ev_name = event.as_text()
	match ev_name:
		"Ctrl+F":
			find_triggered.emit()
			accept_event()
