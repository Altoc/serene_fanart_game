extends Button

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass




func _on_button_up():
	#CAPTURED = 0
	SIGNAL_BUS.emit_signal("SET_MOUSE_MODE", 0)
	#IN_GAME = 1
	SIGNAL_BUS.emit_signal("SET_UI_MODE", 1)
	SIGNAL_BUS.emit_signal("LOAD_LEVEL")
