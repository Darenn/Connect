tool
extends Resource
class_name Character

"""
Contains all data relative to a character.

"""

# The id used to refer the character in ink script, but also in the database
export(String) var id = ""
# The name displayed in the GUI
export(String) var displayed_name = "no_name"
# The color used to write the character name and other gui effects like shadow.
export(Color) var color
export(Vector2) var shadow_direction

# A Dictionary<humor_id: String, textures_set: CharacterTextureSet 
# containing all textures for the character, by humor.
# _characters_texture_set_by_humor["angry"] -> textures for angry humor
export(Dictionary) var _characters_texture_set_by_humor: Dictionary = {}

func get_texture_set(humor_id: String) -> CharacterTextureSet:
	return _characters_texture_set_by_humor[humor_id]
