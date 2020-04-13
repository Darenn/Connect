tool
extends EditorPlugin

const path_textures_template = "res://gameplay/entities/characters/%s/sprites"
const path_texture_base_template = "%s_%s_base.png"
const path_texture_eye_closed_template = "%s_%s_eye_closed.png"
const path_texture_eye_open_template = "%s_%s_eye_open.png"
const path_texture_mouth_closed_template = "%s_%s_mouth_closed.png"
const path_texture_mouth_open_template = "%s_%s_mouth_open.png"

func _enter_tree():
	add_tool_menu_item("Fill Characters Textures", self, "_run")

func _run(id):
	get_editor_interface().open_scene_from_path("res://autoload/character_database.tscn")
	var database = get_editor_interface().get_edited_scene_root()
	var dict: Dictionary = database.character_data_by_id
	for character in dict.values():
		_preload_textures(character as Character)
		
		
func _preload_textures(character: Character):
	character._characters_texture_set_by_humor = {}
	var id: String = character.id
	var path_to_sprites_dir: String = path_textures_template  % id
	var dir := Directory.new()
	if dir.open(path_to_sprites_dir) == OK:
		dir.list_dir_begin(true, true)
		var file_name := dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				_preload_texture_for_humor(path_to_sprites_dir + "/" + file_name + "/", file_name, character)
			file_name = dir.get_next()
	else:
		push_error("An error occurred when trying to access the path." + path_to_sprites_dir)
		return
	print("Sucessfully bind sprites for character : %s" % character.id)


func _preload_texture_for_humor(dir_path: String, humor: String, character: Character):
	var id: String = character.id
	var character_texture_set := CharacterTextureSet.new()
	character_texture_set.texture_base = load(dir_path + path_texture_base_template % [id, humor])
	character_texture_set.texture_eye_closed = load(dir_path + path_texture_eye_closed_template % [id, humor])
	character_texture_set.texture_eye_open = load(dir_path + path_texture_eye_open_template % [id, humor])
	character_texture_set.texture_mouth_closed = load(dir_path + path_texture_mouth_closed_template % [id, humor])
	character_texture_set.texture_mouth_open = load(dir_path + path_texture_mouth_open_template % [id, humor])
	character._characters_texture_set_by_humor[humor] = character_texture_set
