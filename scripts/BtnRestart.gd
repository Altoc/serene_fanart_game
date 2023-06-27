extends Button

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")
var levelToLoadPath

func _ready():
	self.button_up.connect(_on_button_up)
	SIGNAL_BUS.NOTIFY_LEVEL_LOADED.connect(_on_level_loaded)

func _on_level_loaded():
	levelToLoadPath = get_node("/root/Main/LevelSlot").get_child(0).scene_file_path

func _on_button_up():
	SIGNAL_BUS.emit_signal("LOAD_LEVEL", levelToLoadPath)
	SIGNAL_BUS.emit_signal("PAUSE_GAME", false)
