extends Node

@export var walkSpeed : float = 5
@onready var parent = get_parent()

@onready var movementType = "ROTATE"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	parent.rotation.y += delta * walkSpeed
