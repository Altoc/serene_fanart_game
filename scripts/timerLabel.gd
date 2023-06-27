extends Label

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

@onready var timer = 0
@onready var timeStr = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	SIGNAL_BUS.SET_UI_MODE.connect(onUiModeChange)
	SIGNAL_BUS.LOAD_LEVEL.connect(onLoadLevel)

func onLoadLevel(_argLevel):
	onUiModeChange(0)

func onUiModeChange(argMode):
	timer = 0
	if(argMode == 2):
		SIGNAL_BUS.emit_signal("FINAL_TIME", timeStr)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	var mils = fmod(timer, 1) * 1000
	var secs = fmod(timer, 60)
	var mins = fmod(timer, 60*60) / 60
	timeStr = "%02d : %02d: %03d" % [mins, secs, mils]
	text = timeStr
