extends Node3D

@onready
var SIGNAL_BUS = get_node("/root/Main/SignalBus")

enum CameraStates {
	FOLLOW_PLAYER=0,
	OOB=1
}
@onready var currState

@export
var player : Node3D
var rotationY = rotation.y
var rotationX = rotation.x
var posYOffset = 5

#@onready var cameraPanLimitLower = -0.55
#@onready var cameraPanLimitUpper = 1.26
@onready var cameraPanLimitLower = -1
@onready var cameraPanLimitUpper = 1.5

func _ready():
	SIGNAL_BUS.PLAYER_OUT_OF_BOUNDS.connect(onPlayerOutOfBounds)
	SIGNAL_BUS.PLAYER_RESPAWNED.connect(onPlayerRespawn)
	setState(CameraStates.FOLLOW_PLAYER)

func onPlayerOutOfBounds():
	setState(CameraStates.OOB)

func onPlayerRespawn():
	setState(CameraStates.FOLLOW_PLAYER)

func setState(newState):
	currState = newState
	match(currState):
		CameraStates.FOLLOW_PLAYER:
			pass
		CameraStates.OOB:
			pass

func _process(_delta):
	match(currState):
		CameraStates.FOLLOW_PLAYER:
			transform.origin.x = player.transform.origin.x
			transform.origin.z = player.transform.origin.z
			transform.origin.y = player.transform.origin.y + posYOffset
			rotation.y = rotationY
			rotation.x = rotationX
			get_node("SpringArm3D").spring_length = 10 + (player.size * 0.5)
		CameraStates.OOB:
			look_at(player.transform.origin)

#Used for KBM
func panCamera(argVec2Pos):
	rotationY += argVec2Pos.x
	if(rotationX + argVec2Pos.y > cameraPanLimitLower && rotationX + argVec2Pos.y < cameraPanLimitUpper):
		rotationX += argVec2Pos.y
	#else:
	#	print("past the limit")
