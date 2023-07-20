extends BoxContainer

enum UI_STATES {
	MAIN_MENU=0,
	INTRO_CUTSCENE=1,
	OUTRO_CUTSCENE=2,
	IN_GAME=3,
	CREDITS=4,
	LEVEL_HUB=5,
	LEVEL_RESULTS=6
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

@onready var mutePeachFlag = false

#Refs 
@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")
@onready var hud = get_node("HUD")
@onready var cutScene = get_node("DialogueHUD")
@onready var credits = get_node("Credits")
@onready var mainMenu = get_node("MainMenu")
@onready var peachPopup = get_node("HUD/PeachPopup")
@onready var pauseMenu = get_node("HUD/PauseMenu")
@onready var peachTextContainer = get_node("HUD/PeachText")
@onready var levelRecapContainer = get_node("LevelRecapContainer")
@onready var peachTextLabel = get_node("HUD/PeachText/Panel/Label")

@onready var messageReadyForRemoval = false

func _ready():
	SIGNAL_BUS.SET_UI_MODE.connect(setUiState)
	SIGNAL_BUS.SET_PP_MODE.connect(setPPState)
	SIGNAL_BUS.MUTE_PEACH.connect(onMutePeach)
	SIGNAL_BUS.ADD_PEACH_MESSAGE_TO_QUEUE.connect(addPeachMessage)
	SIGNAL_BUS.REMOVE_PEACH_MESSAGE.connect(removePeachMessage)
	SIGNAL_BUS.PAUSE_GAME.connect(onPauseGame)
	SIGNAL_BUS.DRAW_CURTAIN.connect(onDrawCurtain)
	SIGNAL_BUS.CURTAIN_OPENED.connect(onCurtainOpened)
	setUiState(UI_STATES.MAIN_MENU)
	setPPState(PEACH_POPUP_STATES.NO_POPUP)

func onCurtainOpened():
	visible = true

func onCurtainDrawn():
	visible = true

func onDrawCurtain():
	visible = false

func onMutePeach():
	mutePeachFlag = !mutePeachFlag

func onPauseGame(argPauseFlag):
	pauseMenu.visible = argPauseFlag

func addPeachMessage(argStr):
	if(!mutePeachFlag):
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
			pauseMenu.visible = false
			cutScene.visible = false
			mainMenu.visible = true
			credits.visible = false
			levelRecapContainer.visible = false
		UI_STATES.INTRO_CUTSCENE:
			hud.visible = false
			pauseMenu.visible = false
			cutScene.visible = true
			cutScene.get_node("VBoxContainer2/Panel/LabelIntro").visible = true
			cutScene.get_node("VBoxContainer2/Panel/LabelOutro").visible = false
			cutScene.get_node("VBoxContainer2/HBoxContainer/PanelContainer/Label").visible = false
			mainMenu.visible = false
			credits.visible = false
			levelRecapContainer.visible = false
		UI_STATES.OUTRO_CUTSCENE:
			hud.visible = false
			pauseMenu.visible = false
			cutScene.visible = true
			cutScene.get_node("VBoxContainer2/Panel/LabelIntro").visible = false
			cutScene.get_node("VBoxContainer2/Panel/LabelOutro").visible = true
			cutScene.get_node("VBoxContainer2/HBoxContainer/PanelContainer/Label").visible = true
			mainMenu.visible = false
			credits.visible = false
			levelRecapContainer.visible = false
		UI_STATES.IN_GAME:
			hud.visible = true
			pauseMenu.visible = false
			cutScene.visible = false
			mainMenu.visible = false
			credits.visible = false
			levelRecapContainer.visible = false
		UI_STATES.CREDITS:
			hud.visible = false
			pauseMenu.visible = false
			credits.visible = true
			cutScene.visible = false
			mainMenu.visible = false
			levelRecapContainer.visible = false
		UI_STATES.LEVEL_HUB:
			hud.visible = false
			pauseMenu.visible = false
			credits.visible = false
			cutScene.visible = false
			mainMenu.visible = false
			levelRecapContainer.visible = false
		UI_STATES.LEVEL_RESULTS:
			hud.visible = false
			pauseMenu.visible = false
			credits.visible = false
			cutScene.visible = false
			mainMenu.visible = false
			levelRecapContainer.visible = true
			onCurtainDrawn()

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
