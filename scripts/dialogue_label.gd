extends Label

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

enum States {
	SPOOLING=0,
	DONE=1
}
@onready var currState = null

@onready var animateCharacterTime = 0.05
@onready var animateCharacterTimer = 0

func setState(argNewState):
	currState = argNewState
	match(currState):
		States.SPOOLING:
			visible_characters = 0
		States.DONE:
			SIGNAL_BUS.emit_signal("DIALOGUE_DONE")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match(currState):
		States.SPOOLING:
			animateCharacterTimer += delta
			if(animateCharacterTime <= animateCharacterTimer):
				animateCharacterTimer = 0
				visible_characters += 1
			if(visible_ratio == 1):
				setState(States.DONE)
		States.DONE:
			pass

func _on_visibility_changed():
	setState(States.SPOOLING)
