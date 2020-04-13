extends Control
class_name DialogGUI

"""
Display all GUI relative to dialogs.

Listen to 'ink_runner' to start the dialog, display new messages, 
end the dialog.
"""

const ActorScene := preload("res://gui/dialog_gui/actor/actor.tscn")
#const DialogBoxScene := preload("res://gui/dialog_gui/dialog_box/dialog_box.tscn")

onready var _actors_container: Control = $Actors
onready var _layout: DialogGUILayout = $LayoutDefault
onready var _dialog_box: DialogBox = $DialogBox

# Dict<actor_id: String, Actor>
var _actors_in_dialog = {}

func _ready() -> void:
	CommandRunner.register_command("change_layout", self, "change_layout", 1,
			 7, "Change the dialog GUI layout", "")

func change_layout(layout_id: String, actor_id_pos_0 := "none", 
		actor_id_pos_1 := "none", actor_id_pos_2 := "none",
		actor_id_pos_3 := "none", actor_id_pos_4 := "none", 
		actor_id_pos_5 := "none"):
	var characters_id:= [actor_id_pos_0, actor_id_pos_1,
			 actor_id_pos_2, actor_id_pos_3, actor_id_pos_4, actor_id_pos_5] 
	_reset()
	for i in range(characters_id.size()):
		var id := characters_id[i] as String
		if id == "none":
			continue
		var actor : Actor = ActorScene.instance() 
		_actors_container.add_child(actor)
		actor.init_actor(id, "neutral") #TODO what's default behaviour?
		var layout_position := _layout.get_layout_position(i)
		actor.rect_position = layout_position.rect_position
		actor.rect_scale = layout_position.rect_scale
		_actors_in_dialog[id] = actor
		
	
func _reset():
	_dialog_box.clear()
	_dialog_box.visible = false
	for child in _actors_container.get_children():
		child.queue_free()


func _on_InkRunner_on_dialog_paragraph_received(paragraph: String, 
		actor_id: String, humor_id: String) -> void:
	if not _actors_in_dialog.has(actor_id):
		push_error("Actor %s is not in the dialog." % actor_id)
		return
	var actor : Actor = _actors_in_dialog[actor_id]
	var pos := actor.get_dialog_box_position(Actor.DialogBoxPosition.Right)
	_dialog_box.visible = true
	_dialog_box.rect_global_position = pos.rect_global_position
	_dialog_box.rect_scale = pos.rect_scale
	_dialog_box.display_text(paragraph)
