extends Label

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

@onready var timer = 0
@onready var timeStr = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	SIGNAL_BUS.LEVEL_COMPLETE.connect(onLevelComplete)
	SIGNAL_BUS.LOAD_LEVEL.connect(onLoadLevel)

func onLoadLevel(_argLevel):
	timer = 0

func onLevelComplete(argLevelId):
	timer = 0
	SIGNAL_BUS.emit_signal("FINAL_TIME", argLevelId, timeStr)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	var mils = fmod(timer, 1) * 1000
	var secs = fmod(timer, 60)
	var mins = fmod(timer, 60*60) / 60
	timeStr = "%02d : %02d: %03d" % [mins, secs, mils]
	text = timeStr
