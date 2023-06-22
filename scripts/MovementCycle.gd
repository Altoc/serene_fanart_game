extends Node

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

@onready var velocity = Vector3.ZERO
@onready var gravity = 50
@export var walkSpeed : float = 5

@onready var parent = get_parent()

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
func setRotation(argTargetVec3):
	if(parent.transform.origin.y != argTargetVec3.y):
		parent.look_at(argTargetVec3, Vector3.UP)

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
			var currNode = destNodes[currDestNode]
			if (getPosition().x > currNode.x - 0.1 && getPosition().x < currNode.x + 0.1
			&& getPosition().y > currNode.y - 0.1 && getPosition().y < currNode.y + 0.1
			&& getPosition().z > currNode.z - 0.1 && getPosition().z < currNode.z + 0.1):
				onDestinationReached()
			parent.transform.origin = getPosition().move_toward(currNode, delta * walkSpeed)

#Set NPC set in regards to movement
func setState(argNewState):
	currState = argNewState
	match(currState):
		MOVEMENT_STATES.IDLE:
			pass
		MOVEMENT_STATES.WALKING:
			var currNode = destNodes[currDestNode]
			setRotation(currNode)

#Called when the npc has reached their current node destination
func onDestinationReached():
	setState(MOVEMENT_STATES.IDLE)
	#go to the next dest node
	currDestNode += 1
	#make sure we arent out of bounds
	if(currDestNode > destNodes.size() - 1):
		currDestNode = 0

func onRestTimerTimeout():
	restTime = 0
	setState(MOVEMENT_STATES.WALKING)
