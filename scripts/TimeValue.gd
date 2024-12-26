extends Label

@onready var MAIN = get_node("/root/Main")
@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

# Called when the node enters the scene tree for the first time.
func _ready():
	SIGNAL_BUS.FINAL_TIME.connect(getLevelTime)

func getLevelTime(_argLevelId, argTimeStr):
	text = argTimeStr
