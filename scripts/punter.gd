extends Area3D

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

@export var blastPower = 20000
@export var blastDirection = Vector3.UP

@onready var blasting = false
@onready var bodyToBlast = null

@onready var blastTime = 1
@onready var blastTimer = 1

@onready var gamePaused = false

func _ready():
	SIGNAL_BUS.PAUSE_GAME.connect(onGamePause)

func onGamePause(pauseFlag):
	gamePaused = pauseFlag

func _on_body_entered(body):
	if(body.is_in_group("player_ball")):
		bodyToBlast = body
		blasting = true

func _on_body_exited(body):
	if(body.is_in_group("player_ball")):
		blasting = false

func _process(delta):
	if(!gamePaused):
		if(blasting):
			blastTimer += delta
			if(blastTimer >= blastTime):
				blastTimer = 0
				bodyToBlast.getBlasted(blastPower, blastDirection)
