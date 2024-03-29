extends Node

class_name Menus

static var file_items: Array[Dictionary] = [
	{"type": "text", "text": "Open File", "accelerator": KEY_F1},
	{"type": "text", "text": "Open Example", "accelerator": KEY_F2},
	{"type": "separator"},
	{"type": "text", "text": "Save"},
	{"type": "text", "text": "Save As"},
	{"type": "separator"},
	{"type": "text", "text": "Exit"},
]

static var emulator_items: Array[Dictionary] = [
	{"type": "text", "text": "Assemble"},
	{"type": "text", "text": "Assemble and Start", "accelerator": KEY_F5},
	{"type": "text", "text": "Start"},
	{"type": "text", "text": "Debug", "tooltip": "Starts the emulator (may cause the GUI to lag)"},
	{"type": "checkbox", "text": "Paused"},
	{"type": "text", "text": "Reset"},
	{"type": "text", "text": "Stop"},
	{"type": "separator"},
	{"type": "text", "text": "Step Forward", "accelerator": KEY_MASK_CTRL | KEY_PERIOD},
	{"type": "text", "text": "Step Back", "accelerator": KEY_MASK_CTRL | KEY_COMMA},
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
		if item.has("accelerator"):
			menu.set_item_accelerator(item_id, item["accelerator"])
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
	EMULATOR_ASSEMBLE_AND_START,
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
