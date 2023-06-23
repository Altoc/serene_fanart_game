extends Node3D

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

@export var player : Node3D

@onready var respawnPoint = get_node("RespawnPoint")
@onready var respawnFlag = false
@onready var respawnTimeDelaySecs = 3
@onready var respawnTimer = 0

@onready var firstGrabs = []

# Called when the node enters the scene tree for the first time.
func _ready():
	SIGNAL_BUS.PLAYER_OUT_OF_BOUNDS.connect(onPlayerOutOfBounds)
	SIGNAL_BUS.ADD_OBJECT_TO_PLAYER_BALL.connect(onObjectAddedToPlayerBall)
	SIGNAL_BUS.emit_signal("PLAY_BGM", "bgmBobomb")

func _process(delta):
	if(respawnFlag):
		respawnTimer += delta
		if(respawnTimer >= respawnTimeDelaySecs):
			respawnPlayer()

func onObjectAddedToPlayerBall(rigidBody):
	if(rigidBody.myName not in firstGrabs):
		firstGrabs.push_back(rigidBody.myName)
		SIGNAL_BUS.emit_signal("ADD_PEACH_MESSAGE_TO_QUEUE", rigidBody.peachMessage)

func onPlayerOutOfBounds():
	respawnFlag = true

func respawnPlayer():
	respawnFlag = false
	respawnTimer = 0
	player.transform.origin = respawnPoint.transform.origin
	SIGNAL_BUS.emit_signal("PLAYER_RESPAWNED")
