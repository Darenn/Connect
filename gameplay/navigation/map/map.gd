extends Node

class_name Map

export(Array, PackedScene) var rooms

func _ready() -> void:
	pass
	
func has_room(name: String) -> bool:
	for room in get_children():
		if room.name == name:
			return true
	return false
	
func get_room(name: String) -> Room:
	for room in get_children():
		if room.name == name:
			return room
	return null
