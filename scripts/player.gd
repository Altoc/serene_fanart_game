extends RigidBody3D

@onready
var SIGNAL_BUS = get_node("/root/Main/SignalBus")
@onready
var audio = get_node("sfx_mama_mia")

@onready var blastPowerLimit = mass * 5

@onready var fakeMass = mass

@onready var sfx_oof = get_node("sfx_oof")

var input = Vector3()
var inputReceived = false
var torque = Vector3()
#previous mouse position. used for camera panning kbm
var mousePrevPos = Vector2(0,0)
enum PlayerStates {
		IDLE=0,
		OOB=1,
		BACK_IN_BOUNDS=2,
		FREEZE=3
	}
var currPlayerState
var prevPlayerState = null
@export var torqueFactor = 50
var torqueIncreaseRate
@export
var myCamera : Node3D
var size = 1
@onready var myMesh = get_node("Ball")

func _ready():
	SIGNAL_BUS.ADD_OBJECT_TO_PLAYER_BALL.connect(onAddObjectToPlayerBall)
	SIGNAL_BUS.PLAYER_OUT_OF_BOUNDS.connect(onPlayerOutOfBounds)
	SIGNAL_BUS.PLAYER_RESPAWNED.connect(onPlayerRespawned)
	SIGNAL_BUS.BLAST_PLAYER.connect(getBlasted)
	SIGNAL_BUS.NOTIFY_BOWSER_COLLECTED.connect(onBowserCollected)
	torqueIncreaseRate = (torqueFactor / fakeMass)

func onBowserCollected():
	setPlayerState(PlayerStates.FREEZE)

func getSize():
	return size

func onPlayerRespawned():
	setPlayerState(PlayerStates.BACK_IN_BOUNDS)

func onPlayerOutOfBounds():
	setPlayerState(PlayerStates.OOB)

#increase ball size and mass
func onAddObjectToPlayerBall(argObject):
	var massToIncrBy = argObject.mass
	if(size > 100):
		massToIncrBy *= 0.25
	var sizeIncreaseFactor = (massToIncrBy * 0.15)
	if(size > 150):
		massToIncrBy *= 0.50
	var scaleIncreaseFactor = 1 + (massToIncrBy * 0.0025)
	size += sizeIncreaseFactor
	fakeMass += massToIncrBy * 0.15
	torqueFactor = torqueIncreaseRate * fakeMass
	print("torque: " + str(torqueFactor))
	get_node("CollisionShape3D").shape.radius *= scaleIncreaseFactor
	get_node("Area3D/CollisionShape3D").shape.radius *= scaleIncreaseFactor
	SIGNAL_BUS.emit_signal("PLAYER_BALL_SIZE_CHANGED", size)

func _physics_process(_delta):
	input = Vector3()
	handleInput(Input)
	input = input.normalized()
	#forward roll
	if(input.x > 0):
		torque = myCamera.get_global_transform().basis.x * (torqueFactor * -1)
		apply_torque(torque)
		apply_central_force(myCamera.get_global_transform().basis.z * (torqueFactor * -1))
	#break
	elif(input.x < 0):
		torque = myCamera.get_global_transform().basis.x * (torqueFactor)
		apply_torque(torque)
		apply_central_force(myCamera.get_global_transform().basis.z * (torqueFactor))

func _process(_delta):
	match(currPlayerState):
		PlayerStates.IDLE:
			pass
		PlayerStates.OOB:
			pass

func handleInput(argInput):
	inputReceived = false
	if(argInput.is_action_pressed("forward_roll")):
		inputReceived = true
		input.x += 1
		SIGNAL_BUS.emit_signal("PLAYER_MOVEMENT_DIRECTION_UPDATE", argInput)
	if(argInput.is_action_pressed("break")):
		inputReceived = true
		input.x -= 1
		SIGNAL_BUS.emit_signal("PLAYER_MOVEMENT_DIRECTION_UPDATE", argInput)
	if(argInput.is_action_pressed("super_spin")):
		inputReceived = true
		#print("play super spin sound")
	if(argInput.is_action_just_released("super_spin")):
		torque = myCamera.get_global_transform().basis.x * (torqueFactor * -1)
		apply_torque_impulse(torque)
		getBlasted(mass, myCamera.get_global_transform().basis.z * -1)
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
		PlayerStates.FREEZE:
			sleeping = true
			freeze = true

func _on_area_3d_body_entered(body):
	if(body.is_in_group("object")):
		if(body.canBePickedUp(size)):
			body.setState(1)
		elif(body.hasMovementMod()):
			if(body.movementMod.movementType == "CYCLE"):
				getBlasted(body.mass, body.transform.basis.z * -1)
				SIGNAL_BUS.emit_signal("OBJECT_PUNTED_BALL", body)

func getBlasted(blastPower, blastDirection):
	blastPowerLimit = mass * 5
	if(abs(blastPower) > blastPowerLimit):
		blastPower = blastPowerLimit
	print("blasting player with " + str(blastPower))
	apply_central_impulse(blastDirection * 25 * blastPower)
	sfx_oof.play()
