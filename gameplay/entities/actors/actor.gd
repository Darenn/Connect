extends TextureRect

# Is used to represent a character during a dialog

class_name Actor

var character: Character

func init(character_id: String):
	character = CharactersDB.get_character(character_id)
	
