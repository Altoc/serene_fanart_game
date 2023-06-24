extends Node3D

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")
@export var mainMenu = "res://scenes/main_menu.tscn"

@onready var startTimer = false
@onready var time = 5
@onready var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SIGNAL_BUS.UP_MOON.connect(onUpMoon)

func _process(delta):
	if(startTimer):
		timer += delta
		if(timer >= time):
			timer = 0
			startTimer = false
			SIGNAL_BUS.emit_signal("SET_UI_MODE", 0)
			SIGNAL_BUS.emit_signal("LOAD_LEVEL", mainMenu)

func onUpMoon():
	get_node("AnimationPlayer").play("moon_up")
	startTimer = true
