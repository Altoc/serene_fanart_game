extends Area3D

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")
@export var levelToLoad = "res://scenes/level_bombomb_battlefield.tscn"

@onready var label = get_node("Label3D")
@export var levelName = "Bobomb Battlefield"


# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = levelName

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees.y += delta * 4

func _on_body_entered(body):
	if(body.is_in_group("player_ball")):
		SIGNAL_BUS.emit_signal("NOTIFY_LEVEL_NUB_SELECTED", levelToLoad)
		SIGNAL_BUS.emit_signal("BLAST_PLAYER", 500, Vector3.UP)
