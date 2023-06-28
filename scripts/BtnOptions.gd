extends Button

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

func _on_toggled(_button_pressed):
	SIGNAL_BUS.emit_signal("MUTE_PEACH")
