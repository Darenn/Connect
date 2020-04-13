extends Control
class_name Actor

"""
Is used to draw a character during a dialog.

"""

# Each enum is equal to the child index of the control position node in
# _dialog_box_positions
enum DialogBoxPosition {
	Right = 0,
	BottomRight = 1,
	BottomLeft = 2,
	Left = 3,
	Top = 4,
}

# The character representer by the actor
var character: Character
	
onready var _base_texture_rect: TextureRect = $Base
onready var _dialog_box_positions: Control = $DialogBoxPositions

func _ready() -> void:
	pass
	
func init_actor(character_id: String, humor_id: String) -> void:
	character = CharactersDB.get_character(character_id)
	_base_texture_rect.texture = character.get_texture_set(humor_id).texture_base

func get_dialog_box_position(position) -> Control:
	return _dialog_box_positions.get_child(position) as Control
