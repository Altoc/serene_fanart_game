extends Node3D

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

@onready var animPlayer = get_node("AnimationPlayer")

@onready var curtainSprite = get_node("SpringArm3D/Camera3D/Sprite3D")

enum CameraStates {
	FOLLOW_PLAYER=0,
	OOB=1,
	DRAW_CURTAIN=2,
	OPEN_CURTAIN=3
}
@onready var currState

@export var player : Node3D
var rotationY = rotation.y
var rotationX = rotation.x
var posYOffset = 5

@onready var cameraPanLimitLower = -1
@onready var cameraPanLimitUpper = 1.5

func _ready():
	SIGNAL_BUS.PLAYER_OUT_OF_BOUNDS.connect(onPlayerOutOfBounds)
	SIGNAL_BUS.PLAYER_RESPAWNED.connect(onPlayerRespawn)
	SIGNAL_BUS.OPEN_CURTAIN.connect(onOpenCurtain)
	SIGNAL_BUS.DRAW_CURTAIN.connect(onDrawCurtain)
	SIGNAL_BUS.CURTAIN_OPENED.connect(onCurtainOpened)
	animPlayer.animation_finished.connect(onAnimationFinished)
	setState(CameraStates.FOLLOW_PLAYER)

func onCurtainOpened():
	curtainSprite.visible = false

func onOpenCurtain():
	setState(CameraStates.OPEN_CURTAIN)

func onDrawCurtain():
	setState(CameraStates.DRAW_CURTAIN)

func onAnimationFinished(argAnimName):
	if(argAnimName == "DRAW_CURTAIN"):
		SIGNAL_BUS.emit_signal("CURTAIN_DRAWN")
	if(argAnimName == "OPEN_CURTAIN"):
		SIGNAL_BUS.emit_signal("CURTAIN_OPENED")

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
		CameraStates.DRAW_CURTAIN:
			animPlayer.play("DRAW_CURTAIN")
			await get_tree().process_frame
			curtainSprite.visible = true
		CameraStates.OPEN_CURTAIN:
			curtainSprite.visible = true
			animPlayer.play("OPEN_CURTAIN")
			setState(CameraStates.FOLLOW_PLAYER)

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
		CameraStates.DRAW_CURTAIN:
			pass
		CameraStates.OPEN_CURTAIN:
			pass

#Used for KBM
func panCamera(argVec2Pos):
	rotationY += argVec2Pos.x
	if(rotationX + argVec2Pos.y > cameraPanLimitLower && rotationX + argVec2Pos.y < cameraPanLimitUpper):
		rotationX += argVec2Pos.y
