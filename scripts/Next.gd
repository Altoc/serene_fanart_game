extends Button

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

@export var levelToLoad = "res://scenes/level_bombomb_battlefield.tscn"

var currUiMode

@onready var moonUp = false

# Called when the node enters the scene tree for the first time.
func _ready():
	SIGNAL_BUS.DIALOGUE_DONE.connect(onDialogueDone)
	SIGNAL_BUS.SET_UI_MODE.connect(onUiModeChange)
	visible = false

func onUiModeChange(argMode):
	currUiMode = argMode
	visible = false
	moonUp = false
	match(currUiMode):
		1:
			text = "Let's a-go!"
		2:
			text = "Bye bye!"

func onDialogueDone():
	visible = true

func _on_pressed():
	match(currUiMode):
		1:
			SIGNAL_BUS.emit_signal("SET_MOUSE_MODE", 0)
			SIGNAL_BUS.emit_signal("SET_UI_MODE", 5)
			SIGNAL_BUS.emit_signal("LOAD_LEVEL", levelToLoad)
		2:
			if(moonUp == false):
				moonUp = true
				SIGNAL_BUS.emit_signal("UP_MOON")
