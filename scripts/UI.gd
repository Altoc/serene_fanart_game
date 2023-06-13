extends BoxContainer

enum UI_STATES {
	MAIN_MENU=0,
	IN_GAME=1
}
@onready var currState

#Refs
@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")
@onready var hud = get_node("HUD")
@onready var mainMenu = get_node("MainMenu")

func _ready():
	SIGNAL_BUS.SET_UI_MODE.connect(setState)
	setState(UI_STATES.MAIN_MENU)

func setState(argNewState):
	currState = argNewState
	match(currState):
		UI_STATES.MAIN_MENU:
			hud.visible = false
			mainMenu.visible = true
		UI_STATES.IN_GAME:
			hud.visible = true
			mainMenu.visible = false
