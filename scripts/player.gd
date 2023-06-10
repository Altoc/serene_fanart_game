extends CharacterBody3D

@onready
var SIGNAL_BUS = get_node("/root/Main/SignalBus")

var gravity = 50.0
var movementSpeed = 0.0
#factor by which movement speed increases
var movementSpeedIncreaseFactor = 30.0
#value read from algs
var movementSpeedMax = 15.0
#max running speed
var runSpeedMax = 18.0
var input = Vector3()
var inputReceived = false
var dirInput = Vector2()
var dir = Vector3()
#previous mouse position. used for camera panning kbm
var mousePrevPos = Vector2(0,0)
enum playerStates {IDLE=0,TURN=1,FALLING=2,LANDING=3,RUN=4}
var currPlayerState
var prevPlayerState = null
@export
var myCamera : Node3D

func _physics_process(delta):
	velocity.y -= gravity * delta
	if(currPlayerState == playerStates.FALLING):
		setPlayerState(playerStates.LANDING)
	velocity.x = 0
	velocity.z = 0
	input = Vector3()
	handleInput(Input)
	input = input.normalized()
	#if (Input.get_action_strength("PlayerLeft") > 0.0 || Input.get_action_strength("PlayerRight") > 0.0
	#|| Input.get_action_strength("PlayerBackward") > 0.0 || Input.get_action_strength("PlayerForward") > 0.0):
	if (Input.get_action_strength("PlayerForward") > 0.0):
		dir = (transform.basis.z * input.z + transform.basis.x * input.x)
		dirInput = Vector2(Input.get_axis("PlayerLeft", "PlayerRight"), Input.get_axis("PlayerForward", "PlayerBackward"))
		var inputAngle = dirInput.angle()
		var cameraAngle = myCamera.rotation.y
		rotation.y = (cameraAngle - inputAngle)
		if(movementSpeed < movementSpeedMax):
			movementSpeed += movementSpeedIncreaseFactor * delta
		elif(movementSpeed > movementSpeedMax):
			movementSpeed -= movementSpeedIncreaseFactor * delta
		velocity.x = dir.x * movementSpeed
		velocity.z = dir.z * movementSpeed
	move_and_slide()

func handleInput(argInput):
	inputReceived = false
	if(argInput.is_action_pressed("PlayerForward")): 
	#|| argInput.is_action_pressed("PlayerRight")
	#|| argInput.is_action_pressed("PlayerLeft")
	#|| argInput.is_action_pressed("PlayerBackward")):
		inputReceived = true
		input.x += 1
		setPlayerState(playerStates.RUN)
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
			movementSpeed = 0.0
			pass
		playerStates.RUN:
			pass
		playerStates.TURN:
			pass
		playerStates.FALLING:
			pass
		playerStates.LANDING:
			pass
