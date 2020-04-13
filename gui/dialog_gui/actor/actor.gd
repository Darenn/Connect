extends TextureRect

"""
Is used to draw a character during a dialog.

"""

class_name Actor

# The character representer by the actor
var character: Character

func init(character_id: String):
	character = CharactersDB.get_character(character_id)
	
