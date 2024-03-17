extends CodeEdit

signal find_triggered()
signal clear_search_triggered()

var find_id := -1
var clear_id := -1
const find_accel := KEY_MASK_CTRL | KEY_F

# Called when the node enters the scene tree for the first time.
func _ready():
	var menu:PopupMenu = get_menu()
	find_id = menu.item_count + 20
	clear_id = find_id + 1
	menu.add_separator()
	@warning_ignore("INT_AS_ENUM_WITHOUT_MATCH")
	menu.add_item("Find/Replace", find_id, find_accel)
	menu.add_item("Clear search results", clear_id, KEY_ESCAPE)
	menu.connect("id_pressed", find_activated)

func find_activated(id: int):
	match id:
		find_id:
			find_triggered.emit()
		clear_id:
			clear_search_triggered.emit()

func _shortcut_input(event: InputEvent):
	var ev_name = event.as_text()
	match ev_name:
		"Ctrl+F":
			find_triggered.emit()
			accept_event()
