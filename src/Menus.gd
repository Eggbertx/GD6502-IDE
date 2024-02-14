extends Node

class_name Menus

static var file_items: Array[Dictionary] = [
	{"type": "text", "text": "Open File"},
	{"type": "text", "text": "Open Example"},
	{"type": "separator"},
	{"type": "text", "text": "Save"},
	{"type": "text", "text": "Save As"},
	{"type": "separator"},
	{"type": "text", "text": "Exit"},
]

static var emulator_items: Array[Dictionary] = [
	{"type": "text", "text": "Assemble"},
	{"type": "text", "text": "Start"},
	{"type": "text", "text": "Debug", "tooltip": "Starts the emulator (may cause the GUI to lag)"},
	{"type": "text", "text": "Paused"},
	{"type": "text", "text": "Reset"},
	{"type": "text", "text": "Stop"},
	{"type": "separator"},
	{"type": "text", "text": "Step Forward"},
	{"type": "text", "text": "Step Back"},
	{"type": "text", "text": "Go To Address"},
	{"type": "separator"},
	{"type": "text", "text": "Clear Log"},
]

static var help_items: Array[Dictionary] = [
	{"type": "text", "text": "GD6502 IDE on GitHub"},
	{"type": "text", "text": "6502.org"},
	{"type": "text", "text": "MOS 6502 Wikipedia"},
	{"type": "text", "text": "Easy 6502"}
]

static func set_menu_items(menu: PopupMenu, items: Array[Dictionary]):
	var id := 0
	for item in items:
		var item_id = item["id"] if item.has("id") else id
		if not item.has("type"):
			item["type"] = "text"
		match item["type"]:
			"separator":
				menu.add_separator(item["text"] if item.has("text") else "", item_id)
			"checkbox":
				menu.add_check_item(item["text"], item_id)
			_:
				menu.add_item(item["text"], item_id)
		if item.has("tooltip"):
			menu.set_item_tooltip(item_id, item["tooltip"])
		id += 1

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
	EMULATOR_DEBUG,
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
