extends Label

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

# Called when the node enters the scene tree for the first time.
func _ready():
	SIGNAL_BUS.FINAL_TIME.connect(onFinalTimeReceived)

func onFinalTimeReceived(argLevelId, argTimeStr):
	text = argTimeStr
