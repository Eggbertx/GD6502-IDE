extends ConfirmationDialog

func _ready() -> void:
	reset()

func reset():
	$GridContainer/UnpauseCheck.pressed = false
	$GridContainer/AddressSpinner.value = 0

func get_unpause_on_confirm() -> bool:
	return $GridContainer/UnpauseCheck.pressed

func get_address() -> int:
	return int($GridContainer/AddressSpinner.value)

func _on_GoToAddressDialog_about_to_show() -> void:
	$GridContainer/UnpauseCheck.pressed = false
	$GridContainer/AddressSpinner.value = 32
