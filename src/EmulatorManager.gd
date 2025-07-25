class_name  EmulatorManager extends Node

var thread := Thread.new()
var semaphore := Semaphore.new()
#var mutex := Mutex.new()

const CPU_HZ := 1_190_000 # Approximate 6507 CPU frequency
const TARGET_FPS := 60
const CYCLES_PER_FRAME := CPU_HZ / TARGET_FPS

@export var cpu := ExampleCPUSubclass.new()

func get_status() -> CPU.status:
	return cpu.get_status()

func set_status(value: CPU.status) -> void:
	if value != cpu.get_status():
		cpu.set_status(value)
		match value:
			CPU.status.PAUSED:
				semaphore.post()
			CPU.status.STOPPED:
				cpu.reset(value)

func start():
	semaphore.post()
	set_status(CPU.status.RUNNING)
	if not thread.is_started():
		thread.start(_thread_func)

func stop():
	if thread.is_started():
		set_status(CPU.status.STOPPED)

func pause():
	if thread.is_started():
		set_status(CPU.status.PAUSED)

# func unlock():
# 	mutex.unlock()

func _thread_func():
	while true:
		semaphore.wait()
		if cpu.get_status() == CPU.status.RUNNING:
			# tia.execute()
			cpu.execute()
			semaphore.post()
