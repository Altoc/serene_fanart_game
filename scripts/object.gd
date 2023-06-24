extends RigidBody3D

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")
@onready var myCollider = get_node("CollisionShape3D")

@onready var pickupThreshold = mass

@export var goal = false
@export var myName = ""
@export var peachMessage = ""
@onready var cutscenePath = "res://scenes/level_outro.tscn"

@onready var myMesh = get_node("Model")
@onready var baselineRotationDegreesY = myMesh.rotation_degrees.y

@onready var movementMod = null

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
			if(movementMod):
				movementMod.queue_free()
			#turn collision detection for player ball OFF
			set_collision_mask_value(2, false)
			#turn off collision detection for floor (TEMPORARY?)
			set_collision_mask_value(1, false)
			#contact_monitor = false
			#max_contacts_reported = 0
			angular_damp = 100
			var glue = PinJoint3D.new()
			add_child(glue)
			glue.set_owner(self)
			glue.node_a = self.get_path()
			glue.node_b = playerBall.get_path()
			#glue.set_param(glue.PARAM_BIAS, 999)
			glue.set_param(glue.PARAM_BIAS, 1)
			glue.set_param(glue.PARAM_DAMPING, 1)
			SIGNAL_BUS.emit_signal("ADD_OBJECT_TO_PLAYER_BALL", self)
			mass = 0.001

func _on_body_entered(body):
	if(body.is_in_group("player_ball") && currState == OBJECT_STATES.CAN_BE_PICKED_UP):
		processBallCollision(body)

func processBallCollision(argPlayer):
	if(pickupThreshold <= argPlayer.getSize()):
		#print("Object picked up.")
		if(goal):
			#CAPTURED = 0
			SIGNAL_BUS.emit_signal("SET_MOUSE_MODE", 0)
			#IN_GAME = 2
			SIGNAL_BUS.emit_signal("SET_UI_MODE", 2)
			SIGNAL_BUS.emit_signal("LOAD_LEVEL", cutscenePath)
		playerBall = argPlayer
		setState(OBJECT_STATES.PICKED_UP)
	#else:
		#print("Object too heavy. Threshold: " + str(pickupThreshold))

func canBePickedUp(argSize):
	if(pickupThreshold <= argSize):
		return true
	return false
