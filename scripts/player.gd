extends RigidBody3D

@onready
var SIGNAL_BUS = get_node("/root/Main/SignalBus")

var input = Vector3()
var inputReceived = false
var torque = Vector3()
#previous mouse position. used for camera panning kbm
var mousePrevPos = Vector2(0,0)
enum playerStates {IDLE=0,TURN=1,FALLING=2,LANDING=3,RUN=4}
var currPlayerState
var prevPlayerState = null
@export var torqueFactor = 200
var torqueIncreaseRate
@export
var myCamera : Node3D
var size = 1

func _ready():
	SIGNAL_BUS.ADD_OBJECT_TO_PLAYER_BALL.connect(onAddObjectToPlayerBall)
	torqueIncreaseRate = torqueFactor / mass

func getSize():
	return size

func calculateTorque(argMass, argIncreaseRate):
	return argMass * argIncreaseRate

#increase ball size and mass
func onAddObjectToPlayerBall(argObject):
	var sizeIncreaseFactor = (argObject.mass * 0.1) 
	var scaleIncreaseFactor = 1 + (argObject.pickupThreshold * 0.0005)
	size += sizeIncreaseFactor
	mass += argObject.mass
	torqueFactor = calculateTorque(mass, torqueIncreaseRate)
	#ballMesh.scale *= scaleIncreaseFactor
	get_node("CollisionShape3D").scale *= scaleIncreaseFactor
	SIGNAL_BUS.emit_signal("PLAYER_BALL_SIZE_CHANGED", size)

func _physics_process(delta):
	input = Vector3()
	handleInput(Input)
	input = input.normalized()
	if(input.x > 0):
		torque = myCamera.get_global_transform().basis.x * (torqueFactor * -1)
		apply_torque(torque)

func handleInput(argInput):
	inputReceived = false
	if(argInput.is_action_pressed("forward_roll") 
	|| argInput.is_action_pressed("super_spin")):
		inputReceived = true
		input.x += 1
		SIGNAL_BUS.emit_signal("PLAYER_MOVEMENT_DIRECTION_UPDATE", argInput)
	if(!inputReceived):
		setPlayerState(playerStates.IDLE)

func _input(argInput):
	if(argInput is InputEventMouseMotion):
		var panVec = argInput.relative * 0.005
		#invert x and y axis
		panVec *= -1
		myCamera.panCamera(panVec)

func setPlayerState(argState):
	if(currPlayerState != null):
		prevPlayerState = currPlayerState
	if(argState != null):
		currPlayerState = argState
	match currPlayerState:
		playerStates.IDLE:
			#constant_torque = Vector3(0, 0, 0)
			pass
		playerStates.RUN:
			pass
		playerStates.TURN:
			pass
		playerStates.FALLING:
			pass
		playerStates.LANDING:
			pass
