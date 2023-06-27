extends "level.gd"

@onready var sfx_letsAGo = get_node("sfx_lets_a_go")

var levelToLoad

@onready var loadLevelTime = 1
@onready var loadLevelTimer = 0

enum States {
	IDLE=0,
	LOADING_LEVEL=1
}
@onready var currState = null

func _ready():
	super._ready()
	SIGNAL_BUS.NOTIFY_LEVEL_NUB_SELECTED.connect(onLevelNubCollision)
	setState(States.IDLE)

func setState(argNewState):
	currState = argNewState

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	match(currState):
		States.IDLE:
			pass
		States.LOADING_LEVEL:
			loadLevelTimer += delta
			if(loadLevelTimer >= loadLevelTime):
				loadLevelTimer = 0
				SIGNAL_BUS.emit_signal("LOAD_LEVEL", levelToLoad)
				setState(States.IDLE)

func onLevelNubCollision(argLevelToLoad):
	levelToLoad = argLevelToLoad
	sfx_letsAGo.play()
	setState(States.LOADING_LEVEL)
