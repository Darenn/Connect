extends Control
class_name DialogGUILayout

func get_layout_position(layout_position: int) -> Control:
	return get_children()[layout_position]
