extends Node3D

@onready
var SIGNAL_BUS = get_node("/root/Main/SignalBus")

@export
var player : Node3D
var tiltLimit = 45
var rotationY = rotation.y
var rotationX = rotation.x
var posYOffset = 5

func _process(_delta):
	transform.origin.x = player.transform.origin.x
	transform.origin.z = player.transform.origin.z
	transform.origin.y = player.transform.origin.y + posYOffset
	rotation.y = rotationY
	rotation.x = rotationX

#Used for KBM
func panCamera(argVec2Pos):
	rotationY += argVec2Pos.x
	if(rotationX + argVec2Pos.y > -0.55 && rotationX + argVec2Pos.y < 1.26):
		rotationX += argVec2Pos.y
