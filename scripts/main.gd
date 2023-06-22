extends Node3D

@onready var SIGNAL_BUS = get_node("SignalBus")

@onready var bgmBobomb = get_node("bgm_bobomb_battlefield")
@onready var sfxPause = get_node("sfx_pause")

@onready var bgmMap = {
	"bgmBobomb": bgmBobomb
}

#godot mouse modes: 0=VISIBLE, 1=HIDDEN, 2=CAPTURED, 3=CONFINED
# Then why did I make 1 CONFINED...? Probably because I only use 0 and 2...
enum MOUSE_MODES {CAPTURED=0, CONFINED=1, VISIBLE=2}
@onready
var currentGameMode

@onready
var PAUSE_GAME = false

func _ready():
	SIGNAL_BUS.SET_MOUSE_MODE.connect(setMouseMode)
	SIGNAL_BUS.LOAD_LEVEL.connect(loadLevel)
	SIGNAL_BUS.PLAY_BGM.connect(playBgm)
	setMouseMode(MOUSE_MODES.VISIBLE)

func _input(event):
	if(event.is_action_pressed("pause_game")):
		togglePauseGame(!PAUSE_GAME)

func setMouseMode(argMouseMode):
	currentGameMode=argMouseMode
	match(currentGameMode):
		MOUSE_MODES.CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		MOUSE_MODES.CONFINED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		MOUSE_MODES.VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func loadLevel(argLevelPath):
	var levelSlot = get_node("LevelSlot")
	levelSlot.get_children()[0].queue_free()
	var levelTscn = load(argLevelPath).instantiate()
	levelSlot.add_child(levelTscn)
	levelTscn.set_owner(levelSlot)

func playBgm(argKey):
	match(argKey):
		"bgmBobomb":
			bgmMap.get(argKey).play()

#argFlag - true = pause game, false = unpause game
func togglePauseGame(argFlag):
	sfxPause.play()
	get_tree().paused = argFlag
	PAUSE_GAME = !PAUSE_GAME
	SIGNAL_BUS.emit_signal("GAME_PAUSED", PAUSE_GAME)
	if(argFlag):
		setMouseMode(MOUSE_MODES.VISIBLE)
	else:
		setMouseMode(MOUSE_MODES.CAPTURED)
