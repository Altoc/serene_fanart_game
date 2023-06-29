extends Node3D

@onready var SIGNAL_BUS = get_node("SignalBus")

@onready var DEBUG_MODE = true

@onready var bgmBobomb = get_node("bgm_bobomb_battlefield")
@onready var bgm_intro = get_node("bgm_intro")
@onready var sfxPause = get_node("sfx_pause")

@onready var outroCutscenePath = "res://scenes/level_outro.tscn"
@export var levelToLoad = "res://scenes/level_bombomb_battlefield.tscn"

var levelData
@onready var dataFilePath = "res://data/data.json"

@onready var bgmMap = {
	"bgmBobomb": bgmBobomb,
	"bgm_intro": bgm_intro
}
var currBgmKey
@onready var bgmMuted = false

#godot mouse modes: 0=VISIBLE, 1=HIDDEN, 2=CAPTURED, 3=CONFINED
# Then why did I make 1 CONFINED...? Probably because I only use 0 and 2...
enum MOUSE_MODES {CAPTURED=0, CONFINED=1, VISIBLE=2}
@onready
var currentGameMode

@onready
var PAUSE_GAME = false

@onready var currGameMode = 0

func _ready():
	loadLevelData()
	SIGNAL_BUS.SET_UI_MODE.connect(setGameMode)
	SIGNAL_BUS.SET_MOUSE_MODE.connect(setMouseMode)
	SIGNAL_BUS.LOAD_LEVEL.connect(loadLevel)
	SIGNAL_BUS.TOGGLE_BGM.connect(onMuteBgm)
	SIGNAL_BUS.PLAY_BGM.connect(playBgm)
	SIGNAL_BUS.LEVEL_COMPLETE.connect(onLevelCompleted)
	SIGNAL_BUS.PAUSE_GAME.connect(onPauseGame)
	bgmBobomb.finished.connect(onBgmFinished)
	bgm_intro.finished.connect(onBgmFinished)
	playBgm("bgm_intro")
	setMouseMode(MOUSE_MODES.VISIBLE)

func loadLevelData():
	var jsonStr = FileAccess.get_file_as_string(dataFilePath)
	levelData = JSON.parse_string(jsonStr)
	if(levelData):
		print("Successfully loaded data.")
	else:
		print("Problem loading save data.")

func onMuteBgm():
	bgmMuted = !bgmMuted
	if(bgmMuted):
		bgmMap.get(currBgmKey).stop()
	else:
		bgmMap.get(currBgmKey).play()

func onBgmFinished():
	if(!bgmMuted):
		playBgm(currBgmKey)

func setGameMode(gameModeIdx):
	currGameMode = gameModeIdx

func _input(event):
	if(event.is_action_pressed("pause_game")):
		SIGNAL_BUS.emit_signal("PAUSE_GAME", !PAUSE_GAME)

func onLevelCompleted(argLevelId):
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
	var levelTscn = load(argLevelPath).instantiate()
	levelSlot.add_child(levelTscn)
	levelTscn.set_owner(levelSlot)
	levelSlot.move_child(levelTscn, 0)
	levelSlot.get_children()[1].queue_free()
	SIGNAL_BUS.emit_signal("NOTIFY_LEVEL_LOADED")

func playBgm(argKey):
	if(!bgmMuted):
		currBgmKey = argKey
		bgmMap.get(currBgmKey).play()

func onPauseGame(argFlag):
	if(currGameMode == 3):
		if(DEBUG_MODE):
			SIGNAL_BUS.emit_signal("NOTIFY_BOWSER_COLLECTED")
		else:
			sfxPause.play()
			get_tree().paused = argFlag
			PAUSE_GAME = !PAUSE_GAME
			if(argFlag):
				setMouseMode(MOUSE_MODES.VISIBLE)
			else:
				setMouseMode(MOUSE_MODES.CAPTURED)
	elif(currGameMode == 1 || currGameMode == 2):
		SIGNAL_BUS.emit_signal("DIALOGUE_DONE")
