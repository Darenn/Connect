extends Node

class_name Navigator

var current_room: Room
onready var map: Map = $Map

func _ready() -> void:
	CommandRunner.register_command("change_room", self, "change_room", 1, 1, "", "")

func change_room(name: String) -> bool:
	var new_room: Room
	if map.has_room(name):
		new_room = map.get_room(name)
		if current_room != null:
			current_room.visible = false
		current_room = new_room
		current_room.visible = true
		return true
	else:
		push_error("Room '%s' does not exist." % name)
		return false
