extends RigidBody3D

@onready
var SIGNAL_BUS = get_node("/root/Main/SignalBus")
@onready
var audio = get_node("AudioStreamPlayer3D")

var input = Vector3()
var inputReceived = false
var torque = Vector3()
#previous mouse position. used for camera panning kbm
var mousePrevPos = Vector2(0,0)
enum PlayerStates {
		IDLE=0,
		OOB=1,
		BACK_IN_BOUNDS=2
	}
var currPlayerState
var prevPlayerState = null
@export var torqueFactor = 200
var torqueIncreaseRate
@export
var myCamera : Node3D
var size = 1
@onready var myMesh = get_node("Ball")

func _ready():
	SIGNAL_BUS.ADD_OBJECT_TO_PLAYER_BALL.connect(onAddObjectToPlayerBall)
	SIGNAL_BUS.PLAYER_OUT_OF_BOUNDS.connect(onPlayerOutOfBounds)
	SIGNAL_BUS.PLAYER_RESPAWNED.connect(onPlayerRespawned)
	torqueIncreaseRate = torqueFactor / mass

func getSize():
	return size

func calculateTorque(argMass, argIncreaseRate):
	return argMass * argIncreaseRate

func onPlayerRespawned():
	setPlayerState(PlayerStates.BACK_IN_BOUNDS)

func onPlayerOutOfBounds():
	setPlayerState(PlayerStates.OOB)

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

func _physics_process(_delta):
	input = Vector3()
	handleInput(Input)
	input = input.normalized()
	if(input.x > 0):
		torque = myCamera.get_global_transform().basis.x * (torqueFactor * -1)
		apply_torque(torque)

func _process(_delta):
	match(currPlayerState):
		PlayerStates.IDLE:
			pass
		PlayerStates.OOB:
			pass

func handleInput(argInput):
	inputReceived = false
	if(argInput.is_action_pressed("forward_roll") 
	|| argInput.is_action_pressed("super_spin")):
		inputReceived = true
		input.x += 1
		SIGNAL_BUS.emit_signal("PLAYER_MOVEMENT_DIRECTION_UPDATE", argInput)
	if(!inputReceived):
		setPlayerState(PlayerStates.IDLE)

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
		PlayerStates.IDLE:
			pass
		PlayerStates.OOB:
			audio.play()
		PlayerStates.BACK_IN_BOUNDS:
			sleeping = true
			sleeping = false
			setPlayerState(PlayerStates.IDLE)

func _on_area_3d_body_entered(body):
	if(body.is_in_group("object")):
		if(body.canBePickedUp(size)):
			body.setState(1)
		elif(body.hasMovementMod()):
			getBlasted(body.mass, body.transform.basis.z * -1)
			SIGNAL_BUS.emit_signal("OBJECT_PUNTED_BALL", body)

func getBlasted(blastPower, blastDirection):
	print("blasting player")
	apply_central_force(blastDirection * 1000 * blastPower)
