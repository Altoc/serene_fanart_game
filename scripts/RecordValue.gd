extends Label

@onready var MAIN = get_node("/root/Main")
@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

# Called when the node enters the scene tree for the first time.
func _ready():
	SIGNAL_BUS.FINAL_TIME.connect(getRecordTime)

func getRecordTime(argLevelId, _argTimeStr):
	var levelTimeStr = MAIN.getLevelTime(argLevelId)
	if(levelTimeStr == "99:99:999"):
		levelTimeStr = "Never Before Beaten"
	text = levelTimeStr
