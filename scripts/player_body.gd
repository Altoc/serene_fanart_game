extends Node3D

@onready
var SIGNAL_BUS = get_node("/root/Main/SignalBus")

func _ready():
	SIGNAL_BUS.PLAYER_MOVEMENT_DIRECTION_UPDATE.connect(onPlayerMovementDirectionUpdate)

func onPlayerMovementDirectionUpdate(argInput):
	if(argInput.is_action_pressed("forward_roll") 
	|| argInput.is_action_pressed("super_spin")):
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
