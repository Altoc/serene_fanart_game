extends RigidBody3D

@onready
var SIGNAL_BUS = get_node("/root/Main/SignalBus")

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
	input = Vector3()
	handleInput(Input)
	input = input.normalized()
	
	
	
	if (Input.get_action_strength("PlayerForward") > 0.0
	|| Input.get_action_strength("PlayerRight") > 0.0
	|| Input.get_action_strength("PlayerLeft") > 0.0
	|| Input.get_action_strength("PlayerBackward") > 0.0):
		if(abs(constant_torque.normalized()) < abs(Vector3(10,10,10).normalized())):
			var torqueX = Vector3(Input.get_action_strength("PlayerForward"), 0, 0)
			var torqueY = Vector3(0, 2, 0)
			var torqueZ = Vector3(0, 0, 2)
			var torqueToAdd = torqueX + torqueY + torqueZ
			add_constant_torque(torqueToAdd)

func handleInput(argInput):
	inputReceived = false
	if(argInput.is_action_pressed("PlayerForward") 
	|| argInput.is_action_pressed("PlayerRight")
	|| argInput.is_action_pressed("PlayerLeft")
	|| argInput.is_action_pressed("PlayerBackward")):
		inputReceived = true
		input.x += 1
		setPlayerState(playerStates.RUN)
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
			constant_torque = Vector3(0, 0, 0)
			pass
		playerStates.RUN:
			pass
		playerStates.TURN:
			pass
		playerStates.FALLING:
			pass
		playerStates.LANDING:
			pass
