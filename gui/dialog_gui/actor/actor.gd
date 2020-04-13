extends Control
class_name Actor

"""
Is used to draw a character during a dialog.

"""


# The character representer by the actor
var character: Character
	
onready var _base_texture_rect: TextureRect = $Base

func _ready() -> void:
	pass
	
func init_actor(character_id: String, humor_id: String) -> void:
	character = CharactersDB.get_character(character_id)
	_base_texture_rect.texture = character.get_texture_set(humor_id).texture_base
