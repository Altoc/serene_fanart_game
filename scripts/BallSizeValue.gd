extends Label

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

# Called when the node enters the scene tree for the first time.
func _ready():
	SIGNAL_BUS.PLAYER_BALL_SIZE_CHANGED.connect(updateBallSizeLabel)

func updateBallSizeLabel(argBallSize):
	text = str(argBallSize)
