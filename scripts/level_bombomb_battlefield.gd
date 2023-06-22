extends Node3D

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

@export var player : Node3D

@onready var respawnPoint = get_node("RespawnPoint")
@onready var respawnFlag = false
@onready var respawnTimeDelaySecs = 3
@onready var respawnTimer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SIGNAL_BUS.PLAYER_OUT_OF_BOUNDS.connect(onPlayerOutOfBounds)

func _process(delta):
	if(respawnFlag):
		respawnTimer += delta
		if(respawnTimer >= respawnTimeDelaySecs):
			respawnPlayer()

func onPlayerOutOfBounds():
	respawnFlag = true

func respawnPlayer():
	SIGNAL_BUS.emit_signal("PLAYER_RESPAWNED")
	respawnFlag = false
	respawnTimer = 0
	player.transform.origin = respawnPoint.transform.origin
