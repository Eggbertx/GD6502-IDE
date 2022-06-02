extends TextEdit

var use_console = false

func _init() -> void:
	var menu = get_menu()
	menu.add_item("Clear")
	menu.connect("id_pressed", self, "context_menu_selected")

func context_menu_selected(id):
	var item_text = get_menu().get_item_text(id)
	if item_text == "Clear":
		clear()

func write_line(s = ""):
	text += str(s) + "\n"
	cursor_set_line(get_line_count())
	if use_console:
		Console.write_line(s)

func write(s):
	text += str(s)
	cursor_set_line(get_line_count())
	if use_console:
		Console.write(s)

func write_linebreak():
	write_line("--------------------------------")

func clear():
	text = ""
	if use_console:
		Console.clear()
