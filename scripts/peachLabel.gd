extends Label

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

@onready var animateCharacters = false
@onready var animateCharacterTime = 0.05
@onready var animateCharacterTimer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SIGNAL_BUS.DISPLAY_PEACH_MESSAGE.connect(onDisplayPeachMessage)
	SIGNAL_BUS.PEACH_MESSAGE_REMOVED.connect(onRemovePeachMessage)

func onDisplayPeachMessage():
	animateCharacters = true

func onRemovePeachMessage():
	visible_characters = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(animateCharacters):
		animateCharacterTimer += delta
		if(animateCharacterTime <= animateCharacterTimer):
			animateCharacterTimer = 0
			visible_characters += 1
			if(visible_ratio == 1):
				animateCharacters = false
				SIGNAL_BUS.emit_signal("REMOVE_PEACH_MESSAGE")
