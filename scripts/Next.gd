extends Button

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

@export var levelToLoad = "res://scenes/level_bombomb_battlefield.tscn"


# Called when the node enters the scene tree for the first time.
func _ready():
	SIGNAL_BUS.DIALOGUE_DONE.connect(onDialogueDone)
	visible = false

func onDialogueDone():
	visible = true

func _on_pressed():
	#CAPTURED = 0
	SIGNAL_BUS.emit_signal("SET_MOUSE_MODE", 0)
	#IN_GAME = 2
	SIGNAL_BUS.emit_signal("SET_UI_MODE", 2)
	SIGNAL_BUS.emit_signal("LOAD_LEVEL", levelToLoad)
