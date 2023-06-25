extends Button

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

@export var uiMode = 1

@export var levelToLoad = "res://scenes/level_intro.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_button_up():
	#CAPTURED = 0
	#SIGNAL_BUS.emit_signal("SET_MOUSE_MODE", 0)
	#CUTSCENE = 1
	SIGNAL_BUS.emit_signal("SET_UI_MODE", uiMode)
	SIGNAL_BUS.emit_signal("LOAD_LEVEL", levelToLoad)
