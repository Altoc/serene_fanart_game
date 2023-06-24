extends TextureRect

func _ready():
	pivot_offset = Vector2(87.5, 87.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation += delta * 1
