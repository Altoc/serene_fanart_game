extends Area3D

@export var blastPower = 30
@export var blastDirection = Vector3.UP


func _on_body_entered(body):
	if(body.is_in_group("player_ball")):
		body.getBlasted(blastPower, blastDirection)
