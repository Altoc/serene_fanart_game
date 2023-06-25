extends Button

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")
@export var mainMenu = "res://scenes/main_menu.tscn"

func _on_pressed():
	SIGNAL_BUS.emit_signal("SET_UI_MODE", 0)
	SIGNAL_BUS.emit_signal("LOAD_LEVEL", mainMenu)
