extends TextureRect

func _ready():
	pivot_offset = Vector2(125, 125)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation += delta * 1
