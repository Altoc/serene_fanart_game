extends Area3D

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")


func _on_body_entered(body):
	if(body.is_in_group("player_ball")):
		SIGNAL_BUS.emit_signal("PLAYER_OUT_OF_BOUNDS")
