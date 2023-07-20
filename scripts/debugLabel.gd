extends Label

@onready var MAIN = get_node("/root/Main")

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	if(MAIN.DEBUG_MODE):
		visible = true
	else:
		visible = false
