extends Area3D

@onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")
@onready var MAIN = get_node("/root/Main")

@onready var labelName = get_node("Label3D")
@onready var labelTime = get_node("Label3D2")

@export var levelToLoad = "res://scenes/level_bombomb_battlefield.tscn"
@export var levelName = "Bobomb Battlefield"
@export var myLevelId = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SIGNAL_BUS.NOTIFY_SAVE_DATA_UPDATED.connect(onSaveDataUpdated)
	labelName.text = levelName
	refreshTime()

func onSaveDataUpdated():
	refreshTime()

func refreshTime():
	if(myLevelId != -1):
		var levelTimeStr = MAIN.getLevelTime(myLevelId)
		if(levelTimeStr == "99:99:999"):
			labelTime.visible = false
		else:
			labelTime.visible = true
			labelTime.text = levelTimeStr

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees.y += delta * 4

func loadLevelNubTime(argLevelId, argFinalTime):
	if(argLevelId == myLevelId && myLevelId != -1):
		labelTime.text = argFinalTime

func _on_body_entered(body):
	if(body.is_in_group("player_ball")):
		if(myLevelId == -1):
			get_tree().quit()
		SIGNAL_BUS.emit_signal("NOTIFY_LEVEL_NUB_SELECTED", levelToLoad)
		SIGNAL_BUS.emit_signal("BLAST_PLAYER", 500, Vector3.UP)
