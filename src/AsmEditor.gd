extends TextEdit


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_color_region(";", "", Color.darkgray)
	for opcode in Opcodes.dict:
		add_keyword_color(opcode, Color.yellow)
		add_keyword_color(opcode.to_lower(), Color.yellow)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
