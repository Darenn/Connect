tool
extends Resource
class_name Character

const path_textures_template = "res://gameplay/entities/actors/%s/sprites"
const path_texture_base_template = "%s_%s_base.png"
const path_texture_eye_closed_template = "%s_%s_eye_closed.png"
const path_texture_eye_open_template = "%s_%s_eye_open.png"
const path_texture_mouth_closed_template = "%s_%s_mouth_closed.png"
const path_texture_mouth_open_template = "%s_%s_mouth_open.png"

export(String) var id = ""
export(String) var displayed_name = "no_name"
export(Color) var color

export(Dictionary) var _characters_texture_set_by_humor: Dictionary = {}

export(bool) var MyButton setget _preload_textures

func _init():
	pass
	# Fill the dictionarysss

func _preload_textures(isLoading):
#	if id == "":
#		return
	var path_to_sprites_dir: String = path_textures_template  % id
	var dir := Directory.new()
	if dir.open(path_to_sprites_dir) == OK:
		dir.list_dir_begin(true, true)
		var file_name := dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				_preload_texture_for_humor(path_to_sprites_dir + "/" + file_name + "/", file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path." + path_to_sprites_dir)

func _preload_texture_for_humor(dir_path: String, humor: String):
	var character_texture_set := CharacterTextureSet.new()
	character_texture_set.texture_base = load(dir_path + path_texture_base_template % [id, humor])
	character_texture_set.texture_eye_closed = load(dir_path + path_texture_eye_closed_template % [id, humor])
	character_texture_set.texture_eye_open = load(dir_path + path_texture_eye_open_template % [id, humor])
	character_texture_set.texture_mouth_closed = load(dir_path + path_texture_mouth_closed_template % [id, humor])
	character_texture_set.texture_mouth_open = load(dir_path + path_texture_mouth_open_template % [id, humor])
	_characters_texture_set_by_humor[humor] = character_texture_set

class CharacterTextureSet:
	export(Texture) var texture_base
	export(Texture) var texture_eye_closed
	export(Texture) var texture_eye_open
	export(Texture) var texture_mouth_closed
	export(Texture) var texture_mouth_open
