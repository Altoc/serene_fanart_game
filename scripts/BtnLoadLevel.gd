extends Button

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")
@export var levelToLoadPath = "res://scenes/level_hub.tscn"

func _ready():
	self.button_up.connect(_on_button_up)

func _on_button_up():
	SIGNAL_BUS.emit_signal("LOAD_LEVEL", levelToLoadPath)
	SIGNAL_BUS.emit_signal("PAUSE_GAME", false)
