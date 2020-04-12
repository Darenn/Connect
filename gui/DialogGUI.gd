extends Control

class_name DialogGUI


var _actor_scene := preload("res://gameplay/entities/actors/actor.tscn")


onready var _dialog_box: DialogBox = $DialogBox
onready var _actors_container: Control = $Actors

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func display_dialog(link_data: LinkParser) -> void:
	_dialog_box.display_text(link_data.text)
	
func _on_changed_layout(layout_id: String, characters_id: PoolStringArray):
	_reset()
	for id in characters_id:
		_actor_scene.instance()
	
func _reset():
	pass
	# empty actors
	# clear dialog_box
