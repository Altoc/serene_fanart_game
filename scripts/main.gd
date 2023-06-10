extends Node3D

#godot mouse modes: 0=VISIBLE, 1=HIDDEN, 2=CAPTURED, 3=CONFINED
enum MOUSE_MODES {CAPTURED=0, CONFINED=1, VISIBLE=2}
@onready
var currentGameMode = MOUSE_MODES.CAPTURED

func _ready():
	setMouseMode(MOUSE_MODES.CAPTURED)

func setMouseMode(argMouseMode):
	currentGameMode=argMouseMode
	match(currentGameMode):
		MOUSE_MODES.CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		MOUSE_MODES.CONFINED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		MOUSE_MODES.VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
