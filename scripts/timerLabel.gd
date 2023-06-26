extends Label

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

@onready var minsRaw = 0
@onready var secsRaw = 0

@onready var timeStr = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	SIGNAL_BUS.SET_UI_MODE.connect(onUiModeChange)

func onUiModeChange(argMode):
	minsRaw = 0
	secsRaw = 0
	if(argMode == 2):
		SIGNAL_BUS.emit_signal("FINAL_TIME", timeStr)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	secsRaw += delta
	var secs = roundi(secsRaw)
	if(secs >= 60):
		secsRaw = 0
		minsRaw += 1
	var minStr = str(minsRaw)
	if(minsRaw == 0):
		minStr = "00"
	var secStr = str(secs)
	if(secs < 10):
		secStr = "0" + secStr
	timeStr = minStr + ":" + secStr
	#trimmedStr = timeStr.substr(0, timeStr.find(":", 0)) + timeStr.substr(timeStr.find(":", 0), 3)
	text = timeStr
