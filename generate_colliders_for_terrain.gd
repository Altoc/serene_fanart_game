@tool extends EditorScript


func _run():
	for child in get_scene().get_children():
		if child is MeshInstance3D:
			child.create_convex_collision()