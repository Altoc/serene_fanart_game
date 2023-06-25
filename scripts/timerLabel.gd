extends Label

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

@onready var mins = 0
@onready var secs = 0

@onready var trimmedStr = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	SIGNAL_BUS.SET_UI_MODE.connect(onUiModeChange)

func onUiModeChange(argMode):
	mins = 0
	secs = 0
	if(argMode == 2):
		SIGNAL_BUS.emit_signal("FINAL_TIME", trimmedStr)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#timer += delta
	secs += delta
	if(secs >= 60):
		secs = 0
		mins += 1
	var minStr = str(mins)
	if(mins == 0):
		minStr = "00"
	var secStr = str(secs)
	if(secs - 10 < 0):
		secStr = str(roundi(secs))
	var timeStr = minStr + ":" + secStr
	trimmedStr = timeStr.substr(0, timeStr.find(":", 0)) + timeStr.substr(timeStr.find(":", 0), 3)
	text = trimmedStr
