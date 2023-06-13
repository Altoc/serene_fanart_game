extends RigidBody3D

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")
@onready var myCollider = get_node("CollisionShape3D")
@onready var mesh = get_node("MeshInstance3D")

@export var pickupThreshold = 0

var playerBall

enum OBJECT_STATES {
	NOT_PICKED_UP=0,
	PICKED_UP=1
}
@onready var currState = OBJECT_STATES.NOT_PICKED_UP

# Called when the node enters the scene tree for the first time.
func _ready():
	setState(OBJECT_STATES.NOT_PICKED_UP)

func _process(delta):
	if(currState == OBJECT_STATES.PICKED_UP):
		#set center point to be the player ball
		pass
		#transform.basis = playerBall.transform.basis

func setState(argNewState):
	currState = argNewState
	match(currState):
		OBJECT_STATES.NOT_PICKED_UP:
			pass
		OBJECT_STATES.PICKED_UP:
			#turn collision detection for player ball OFF
			set_collision_mask_value(2, false)
			#turn off collision detection for floor (TEMPORARY?)
			set_collision_mask_value(1, false)
			#lock_rotation = true
			
			#transform.basis = playerBall.transform.basis
		
			#reparent to ball
			#get_parent().call_deferred("remove_child", self)
			#playerBall.call_deferred("add_child", self)
			#self.call_deferred("set_owner", playerBall)
			
			var glue = PinJoint3D.new()
			get_parent().add_child(glue)
			glue.set_owner(get_parent())
			glue.node_a = get_parent().get_path()
			glue.node_b = playerBall.get_path()
			SIGNAL_BUS.emit_signal("ADD_OBJECT_TO_PLAYER_BALL", self)
			mass = 0.001

func _on_body_entered(body):
	if(body.is_in_group("player_ball") && currState == OBJECT_STATES.NOT_PICKED_UP):
		processBallCollision(body)

func processBallCollision(argPlayer):
	if(pickupThreshold <= argPlayer.getSize()):
		playerBall = argPlayer
		setState(OBJECT_STATES.PICKED_UP)
	else:
		print("Object too heavy. Threshold: " + str(pickupThreshold))
