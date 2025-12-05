class_name EmulatorManager
extends Node

signal emulator_reset
signal rom_loaded(bytes:int)
signal rom_unloaded
signal status_changed(new_status:CPU.EmulationStatus, old_status:CPU.EmulationStatus)

var cpu: ExampleCPUSubclass:
	get:
		return $CPU

func _ready() -> void:
	_connect_signals()

func _connect_signals():
	_connect_if_not_connected(cpu.illegal_opcode, self._on_cpu_illegal_opcode)
	_connect_if_not_connected(cpu.status_changed, self._on_cpu_status_changed)

func reset(reset_status:CPU.EmulationStatus = cpu.get_status()):
	cpu.reset(reset_status)
	emulator_reset.emit()

func load_rom(bytes:PackedByteArray):
	cpu.load_rom(bytes)
	rom_loaded.emit(bytes.size())

func unload_rom():
	cpu.unload_rom()
	rom_unloaded.emit()

func get_status() -> CPU.EmulationStatus:
	return cpu.get_status()

func set_status(status:CPU.EmulationStatus, no_reset = false):
	cpu.set_status(status, no_reset)

func _connect_if_not_connected(sig:Signal, handler:Callable):
	if not sig.is_connected(handler):
		sig.connect(handler)

func _on_cpu_status_changed(new_status:CPU.EmulationStatus, old_status:CPU.EmulationStatus):
	status_changed.emit(new_status, old_status)

func _on_cpu_illegal_opcode(_opcode: int) -> void:
	reset(CPU.EmulationStatus.STOPPED)
