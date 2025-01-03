extends RigidBody3D

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")
@onready var myCollider = get_node("CollisionShape3D")

@onready var pickupThreshold = mass

@export var goal = false
@export var myName = ""
@export var peachMessage = ""

@onready var myMesh = get_node("Model")
@onready var baselineRotationDegreesY = myMesh.rotation_degrees.y

@onready var movementMod = null

@onready var sfxPlayer = get_node("AudioStreamPlayer3D")

var playerBall

enum OBJECT_STATES {
	CANT_BE_PICKED_UP=0,
	CAN_BE_PICKED_UP=1,
	PICKED_UP=2
}
var currState

# Called when the node enters the scene tree for the first time.
func _ready():
	setState(OBJECT_STATES.CANT_BE_PICKED_UP)
	for child in get_children():
		if(child.is_in_group("movement_mod")):
			movementMod = child

func hasMovementMod():
	return movementMod != null

func getMovementModSpeed():
	if(hasMovementMod()):
		return movementMod.walkSpeed

func setState(argNewState):
	currState = argNewState
	match(currState):
		OBJECT_STATES.CANT_BE_PICKED_UP:
			freeze = true
		OBJECT_STATES.CAN_BE_PICKED_UP:
			freeze = false
		OBJECT_STATES.PICKED_UP:
			if(sfxPlayer != null):
				sfxPlayer.play()
			if(movementMod):
				movementMod.queue_free()
			set_collision_mask_value(2, false)
			set_collision_mask_value(1, false)
			angular_damp = 100
			var glue = PinJoint3D.new()
			add_child(glue)
			glue.set_owner(self)
			glue.node_a = self.get_path()
			glue.node_b = playerBall.get_path()
			glue.set_param(glue.PARAM_BIAS, 1)
			glue.set_param(glue.PARAM_DAMPING, 1)
			if(!goal):
				SIGNAL_BUS.emit_signal("ADD_OBJECT_TO_PLAYER_BALL", self)
			mass = 0.001

func _on_body_entered(body):
	if(body.is_in_group("player_ball") && currState == OBJECT_STATES.CAN_BE_PICKED_UP):
		processBallCollision(body)

func processBallCollision(argPlayer):
	if(pickupThreshold <= argPlayer.getSize()):
		if(goal):
			SIGNAL_BUS.emit_signal("NOTIFY_BOWSER_COLLECTED")
		playerBall = argPlayer
		setState(OBJECT_STATES.PICKED_UP)
	#else:
		#print("Object too heavy. Threshold: " + str(pickupThreshold))

func canBePickedUp(argSize):
	if(pickupThreshold <= argSize):
		return true
	return false
