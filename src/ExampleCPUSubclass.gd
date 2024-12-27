class_name ExampleCPUSubclass
extends CPU

func _setup_specs():
	memory_size = 0x5ff
	sp_start = 0xff
	pc_start = 0x600

func get_byte(addr: int) -> int:
	match addr:
		0xfe:
			return randi_range(0, 255)
		_:
			return super(addr)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var ke := event as InputEventKey
		set_byte(0xff, ke.unicode & 0xff)


func step(steps:int = 1):
	_status = status.PAUSED
	for s in range(steps):
		execute(true)
