extends Node

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

@export var walkSpeed : float = 5
@onready var parent = get_parent()
@onready var movementType = "CYCLE"

@onready var wobbleToleranceLimitDegrees = 15
@onready var wobbleVelocity = 25
@onready var RotationDegreesYOffset = 0

@export var reverseCourse = false
@onready var destNodeIdxFactor = 1

#Timer which determines how long the movement mod will wait before moving again
@export var restTimer = 3
#Tracker variable to determine if restTimer has been reached
@onready var restTime = 0

enum MOVEMENT_STATES {
	IDLE=0,
	WALKING=1
}
@onready var currState = MOVEMENT_STATES.IDLE

#index of destNodes array we are currently moving to
@onready var currDestNode = 0
#array holding vector3s of the destination nodes we want to stop at
@export var destNodes : Array[Vector3]

@onready var gamePaused = false

func _ready():
	SIGNAL_BUS.GAME_PAUSED.connect(onGamePause)

func onGamePause(argPausedFlag):
	gamePaused = argPausedFlag

#Get definitive position
func getPosition():
	return parent.transform.origin

#Turn NPC towards target Vec3
func setRotation():
	if(!isPistonMovement()):
		parent.look_at(destNodes[currDestNode], Vector3.UP)
		RotationDegreesYOffset = 0
		parent.myMesh.rotation_degrees.y = parent.baselineRotationDegreesY

func isPistonMovement():
	#look_at() C++ bug relating to difference between target and current being approx 0
	var diffX = abs(parent.transform.origin.x - destNodes[currDestNode].x)
	var diffZ = abs(parent.transform.origin.z - destNodes[currDestNode].z)
	if(diffX + diffZ > 0.125):
		return false
	return true

func _process(delta):
	if(!gamePaused):
		movementAction(delta)

func movementAction(delta):
	match(currState):
		MOVEMENT_STATES.IDLE:
			restTime += delta
			if(restTime >= restTimer):
				onRestTimerTimeout()
		MOVEMENT_STATES.WALKING:
			if(!isPistonMovement()):
				wobbleMesh(delta)
			var currNode = destNodes[currDestNode]
			if (getPosition().x > currNode.x - 0.1 && getPosition().x < currNode.x + 0.1
			&& getPosition().y > currNode.y - 0.1 && getPosition().y < currNode.y + 0.1
			&& getPosition().z > currNode.z - 0.1 && getPosition().z < currNode.z + 0.1):
				onDestinationReached()
			parent.transform.origin = getPosition().move_toward(currNode, delta * walkSpeed)

func wobbleMesh(delta):
	var wobbleFactor = delta * wobbleVelocity * walkSpeed
	if(abs(RotationDegreesYOffset + wobbleFactor) < wobbleToleranceLimitDegrees):
		RotationDegreesYOffset += wobbleFactor
		parent.myMesh.rotation_degrees.y += wobbleFactor
	else:
		wobbleVelocity *= -1

#Set NPC set in regards to movement
func setState(argNewState):
	currState = argNewState
	match(currState):
		MOVEMENT_STATES.IDLE:
			pass
		MOVEMENT_STATES.WALKING:
			setRotation()

#Called when the npc has reached their current node destination
func onDestinationReached():
	setState(MOVEMENT_STATES.IDLE)
	#make sure we arent out of bounds
	if(currDestNode + destNodeIdxFactor > destNodes.size() - 1 || currDestNode + destNodeIdxFactor < 0):
		if(reverseCourse):
			destNodeIdxFactor *= -1
		else:
			currDestNode = -1
	#go to the next dest node
	currDestNode += destNodeIdxFactor

func onRestTimerTimeout():
	restTime = 0
	setState(MOVEMENT_STATES.WALKING)
