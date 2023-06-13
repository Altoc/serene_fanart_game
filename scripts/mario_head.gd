extends Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees.y += delta * 4
