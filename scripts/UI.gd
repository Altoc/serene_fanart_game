extends BoxContainer

enum UI_STATES {
	MAIN_MENU=0,
	INTRO_CUTSCENE=1,
	OUTRO_CUTSCENE=2,
	IN_GAME=3,
	CREDITS=4
}
@onready var currUiState

enum PEACH_POPUP_STATES {
	NO_POPUP=0,
	YES_POPUP=1
}
@onready var currPPState

@onready var peachMessageQueue = []

@onready var peachPopupTime = 5
@onready var peachPopupTimer = 0

#Refs 
@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")
@onready var hud = get_node("HUD")
@onready var cutScene = get_node("DialogueHUD")
@onready var credits = get_node("Credits")
@onready var mainMenu = get_node("MainMenu")
@onready var peachPopup = get_node("HUD/PeachPopup")
@onready var peachTextContainer = get_node("HUD/PeachText")
@onready var peachTextLabel = get_node("HUD/PeachText/Panel/Label")

@onready var messageReadyForRemoval = false

func _ready():
	SIGNAL_BUS.SET_UI_MODE.connect(setUiState)
	SIGNAL_BUS.SET_PP_MODE.connect(setPPState)
	SIGNAL_BUS.ADD_PEACH_MESSAGE_TO_QUEUE.connect(addPeachMessage)
	SIGNAL_BUS.REMOVE_PEACH_MESSAGE.connect(removePeachMessage)
	setUiState(UI_STATES.MAIN_MENU)
	setPPState(PEACH_POPUP_STATES.NO_POPUP)

func addPeachMessage(argStr):
	peachMessageQueue.push_front(argStr)

func removePeachMessage():
	messageReadyForRemoval = true

func _process(delta):
	if(currPPState == PEACH_POPUP_STATES.YES_POPUP && messageReadyForRemoval):
		peachPopupTimer += delta
		if(peachPopupTimer >= peachPopupTime):
			peachPopupTimer = 0
			setPPState(PEACH_POPUP_STATES.NO_POPUP)
	elif(currPPState == PEACH_POPUP_STATES.NO_POPUP):
		if(peachMessageQueue.size() > 0):
			displayNextPeachMessage()

func displayNextPeachMessage():
	peachTextLabel.text = peachMessageQueue.front()
	peachMessageQueue.pop_front()
	setPPState(PEACH_POPUP_STATES.YES_POPUP)

func setUiState(argNewState):
	currUiState = argNewState
	match(currUiState):
		UI_STATES.MAIN_MENU:
			hud.visible = false
			cutScene.visible = false
			mainMenu.visible = true
			credits.visible = false
		UI_STATES.INTRO_CUTSCENE:
			hud.visible = false
			cutScene.visible = true
			cutScene.get_node("VBoxContainer2/Panel/LabelIntro").visible = true
			cutScene.get_node("VBoxContainer2/Panel/LabelOutro").visible = false
			mainMenu.visible = false
			credits.visible = false
		UI_STATES.OUTRO_CUTSCENE:
			hud.visible = false
			cutScene.visible = true
			cutScene.get_node("VBoxContainer2/Panel/LabelIntro").visible = false
			cutScene.get_node("VBoxContainer2/Panel/LabelOutro").visible = true
			mainMenu.visible = false
			credits.visible = false
		UI_STATES.IN_GAME:
			hud.visible = true
			cutScene.visible = false
			mainMenu.visible = false
			credits.visible = false
		UI_STATES.CREDITS:
			hud.visible = false
			credits.visible = true
			cutScene.visible = false
			mainMenu.visible = false

func setPPState(argNewState):
	currPPState = argNewState
	match(currPPState):
		PEACH_POPUP_STATES.NO_POPUP:
			SIGNAL_BUS.emit_signal("PEACH_MESSAGE_REMOVED")
			messageReadyForRemoval = false
			peachPopup.visible = false
			peachTextContainer.visible = false
		PEACH_POPUP_STATES.YES_POPUP:
			SIGNAL_BUS.emit_signal("DISPLAY_PEACH_MESSAGE")
			peachPopup.visible = true
			peachTextContainer.visible = true
