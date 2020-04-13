tool
extends EditorPlugin

"""
Add the docks and tool_menu_item for the useful functions of the plugin.

"""

const BindTextureScript = \
		preload("res://addons/connect/bind_texture_to_characters.gd")

func _enter_tree() -> void:
	add_tool_menu_item("Bind textures to characters", BindTextureScript, 
			"bind_textures_to_characters", get_editor_interface())
	
