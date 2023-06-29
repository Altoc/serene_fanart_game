extends Label


@onready var creditsText = "Thank you so much for to be a playing my game!\n
\n
A SAIC 3 contest entry.\n
Game made by IPW.\n
\n
Special thanks to those who ripped the 3d models and sounds:\n
booscaster for ripping the 2d mario 64 textures,
https://www.models-resource.com/nintendo_64/supermario64/ for 3d models,
alec pike for ripping the mario head model, ripping the peach model,
SFX: https://themushroomkingdom.net/media/sm64/wav
\n
Superb Speedrunners (In order of obtaining 4:30 on Bobomb Battlefield):\n
KODO - Discord: 48#1825
INTY - Really friggin' good fr
MountainOstrich - Kind of like a big deal
"


# Called when the node enters the scene tree for the first time.
func _ready():
	text = creditsText


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
