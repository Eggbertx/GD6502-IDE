class_name ExampleCPUVariant
extends CPU

var _current_key := 0

func get_byte(addr: int) -> int:
	match addr:
		0xfe:
			return randi_range(0, 255)
		0xff:
			return _current_key
		_:
			return super(addr)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var ke := event as InputEventKey
		_current_key = ke.unicode & 0xff