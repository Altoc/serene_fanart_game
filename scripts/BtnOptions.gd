extends Button

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

@export var onText = "Please Peach Shut Up (jk ilu but fr)"
@export var offText = "Peach PLEASE say the funny things again"
@export var signalToNotify = "MUTE_PEACH"

func _on_toggled(argButtonPressed):
	SIGNAL_BUS.emit_signal(signalToNotify)
	if(argButtonPressed):
		text = onText
	else:
		text = offText
