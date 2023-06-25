extends Node3D

@onready var SIGNAL_BUS = get_node("SignalBus")

@onready var DEBUG_MODE = true

@onready var bgmBobomb = get_node("bgm_bobomb_battlefield")
@onready var bgm_intro = get_node("bgm_intro")
@onready var sfxPause = get_node("sfx_pause")
@onready var sfxSoLongBowser = get_node("sfx_solongbowser")

@onready var outroCutscenePath = "res://scenes/level_outro.tscn"
@export var levelToLoad = "res://scenes/level_bombomb_battlefield.tscn"

@onready var bgmMap = {
	"bgmBobomb": bgmBobomb,
	"bgm_intro": bgm_intro
}

var currBgmKey

#godot mouse modes: 0=VISIBLE, 1=HIDDEN, 2=CAPTURED, 3=CONFINED
# Then why did I make 1 CONFINED...? Probably because I only use 0 and 2...
enum MOUSE_MODES {CAPTURED=0, CONFINED=1, VISIBLE=2}
@onready
var currentGameMode

@onready
var PAUSE_GAME = false

@onready var currGameMode = 0

func _ready():
	SIGNAL_BUS.SET_UI_MODE.connect(setGameMode)
	SIGNAL_BUS.SET_MOUSE_MODE.connect(setMouseMode)
	SIGNAL_BUS.LOAD_LEVEL.connect(loadLevel)
	SIGNAL_BUS.PLAY_BGM.connect(playBgm)
	SIGNAL_BUS.GOAL.connect(onBowserGot)
	bgmBobomb.finished.connect(onBgmFinished)
	bgm_intro.finished.connect(onBgmFinished)
	playBgm("bgm_intro")
	setMouseMode(MOUSE_MODES.VISIBLE)

func onBgmFinished():
	playBgm(currBgmKey)

func setGameMode(gameModeIdx):
	currGameMode = gameModeIdx

func _input(event):
	if(event.is_action_pressed("pause_game")):
		if(currGameMode == 3):
			if(DEBUG_MODE):
				SIGNAL_BUS.emit_signal("GOAL")
			else:
				togglePauseGame(!PAUSE_GAME)
		elif(currGameMode == 1 || currGameMode == 2):
			SIGNAL_BUS.emit_signal("DIALOGUE_DONE")

func onBowserGot():
	sfxSoLongBowser.play()
	SIGNAL_BUS.emit_signal("SET_MOUSE_MODE", 2)
	SIGNAL_BUS.emit_signal("SET_UI_MODE", 2)
	SIGNAL_BUS.emit_signal("LOAD_LEVEL", outroCutscenePath)

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
	currBgmKey = argKey
	bgmMap.get(currBgmKey).play()

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
