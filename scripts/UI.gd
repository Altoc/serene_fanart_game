extends BoxContainer

enum UI_STATES {
	MAIN_MENU=0,
	IN_CUTSCENE=1,
	IN_GAME=2
}
@onready var currState

#Refs 
@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")
@onready var hud = get_node("HUD")
@onready var cutScene = get_node("DialogueHUD")
@onready var mainMenu = get_node("MainMenu")

func _ready():
	SIGNAL_BUS.SET_UI_MODE.connect(setState)
	setState(UI_STATES.MAIN_MENU)

func setState(argNewState):
	currState = argNewState
	match(currState):
		UI_STATES.MAIN_MENU:
			hud.visible = false
			cutScene.visible = false
			mainMenu.visible = true
		UI_STATES.IN_CUTSCENE:
			hud.visible = false
			cutScene.visible = true
			mainMenu.visible = false
		UI_STATES.IN_GAME:
			hud.visible = true
			cutScene.visible = false
			mainMenu.visible = false
