extends Button

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

func _on_pressed():
	SIGNAL_BUS.emit_signal("USER_SELECTED_NEXT_LEVEL_RECAP")
