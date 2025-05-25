class_name  EmulatorManager extends Node

var thread := Thread.new()
var semaphore := Semaphore.new()
var mutex := Mutex.new()

@export
var cpu := ExampleCPUSubclass.new()

func get_status() -> CPU.status:
	return cpu.get_status()

func set_status(value: CPU.status) -> void:
	if value != cpu.get_status():
		cpu.set_status(value)
		match value:
			CPU.status.PAUSED:
				semaphore.post()
			CPU.status.RUNNING:
				if not thread.is_started():
					thread.start(_thread_func)



func _thread_func():
	while true:
		semaphore.wait()
		if cpu.get_status() == CPU.status.RUNNING:
			# tia.execute()
			cpu.execute()
