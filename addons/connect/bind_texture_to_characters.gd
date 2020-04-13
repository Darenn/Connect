tool
extends EditorPlugin

"""
Provide a function to bind all textures to characters.
Read 'bind_textures_to_characters' for more info.
"""

# The path where to find the textures for a given character.
# Should be formatted with the character ID.
const path_textures_template = "res://gameplay/entities/characters/%s/textures"

# Paths to the different need texture.
# Should be formatted with the character ID and humor.
# Prefix it with the 'path_textures_template'.
const path_texture_base_template = "%s_%s_base.png"
const path_texture_eye_closed_template = "%s_%s_eye_closed.png"
const path_texture_eye_open_template = "%s_%s_eye_open.png"
const path_texture_mouth_closed_template = "%s_%s_mouth_closed.png"
const path_texture_mouth_open_template = "%s_%s_mouth_open.png"

"""
Binds textures to each character in the 'CharacterDatabase'.

Open the CharacterDatabase scene and go trough all characters.
For each one of them, create and fill a new 'CharacterTextureSet' per humor 
folder found in the textures path. 
"""
static func bind_textures_to_characters(editor_interface) -> void:
	print("""Started to bind textures to characters.
	It will open the character database scene and bind the to each characters theirs texture sets.""")
	editor_interface.open_scene_from_path("res://autoload/characters_database.tscn")
	var database = editor_interface.get_edited_scene_root()
	var dict: Dictionary = database.character_data_by_id
	for character in dict.values():
		_bind_textures_to_character(character as Character)

"""
Binds textures for one character. 

Go trough each one of its humor folder and create a 'CharacterTextureSet' filled
with textures in the folder.
"""
static func _bind_textures_to_character(character: Character) -> void:
	character._characters_texture_set_by_humor = {}
	var id: String = character.id
	var path_to_sprites_dir: String = path_textures_template  % id
	var dir := Directory.new()
	if dir.open(path_to_sprites_dir) == OK:
		dir.list_dir_begin(true, true)
		var file_name := dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				_bind_textures_for_character_humor(path_to_sprites_dir + "/" + 
						file_name + "/", file_name, character)
			file_name = dir.get_next()
	else:
		push_error("An error occurred when trying to access the path : " + 
				path_to_sprites_dir)
		return
	print("Sucessfully bind textures for character : %s" % character.id)

"""
Binds textures for one humor. 

Get all textures from the humor folder.
"""
static func _bind_textures_for_character_humor(dir_path: String, humor: String, 
			character: Character) -> void:
	var id: String = character.id
	var character_texture_set := CharacterTextureSet.new()
	character_texture_set.texture_base = \
			load(dir_path + path_texture_base_template % [id, humor])
	character_texture_set.texture_eye_closed = \
			load(dir_path + path_texture_eye_closed_template % [id, humor])
	character_texture_set.texture_eye_open = \
			load(dir_path + path_texture_eye_open_template % [id, humor])
	character_texture_set.texture_mouth_closed = \
			load(dir_path + path_texture_mouth_closed_template % [id, humor])
	character_texture_set.texture_mouth_open = \
			load(dir_path + path_texture_mouth_open_template % [id, humor])
	character._characters_texture_set_by_humor[humor] = character_texture_set
