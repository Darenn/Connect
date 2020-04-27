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

export(Vector2) var blink_time: Vector2
export(Vector2) var blink_interval: Vector2

# The character represented by the actor
var character: Character
var is_shadow_visible: bool setget set_shadow_visible, get_shadow_visible
	
onready var _base_texture_rect: TextureRect = $Texture
onready var _eyes_texture_rect: TextureRect = $Eyes
onready var _shadow_texture_rect: TextureRect = $Texture/ShadowTexture
onready var _dialog_box_positions: Control = $DialogBoxPositions
onready var _blinking_timer: Timer = $Eyes/BlinkingTimer

var _humor_id: String
	
func init_actor(character_id: String, humor_id: String) -> void:
	character = CharactersDB.get_character(character_id)
	_humor_id = humor_id
	_base_texture_rect.texture = character.get_texture_set(humor_id).texture_base
	_eyes_texture_rect.texture = character.get_texture_set(humor_id).texture_eye_open
	_shadow_texture_rect.texture = _base_texture_rect.texture
	_shadow_texture_rect.material.set_shader_param("shadow_color", character.color)
	_shadow_texture_rect.material.set_shader_param("shadow_direction", Vector2(10, 10))
	_blink()

func get_dialog_box_position(position) -> Control:
	return _dialog_box_positions.get_child(position) as Control
	
func set_shadow_visible(is_visible: bool) -> void:
	_shadow_texture_rect.visible = is_visible
	
func get_shadow_visible() -> bool:
	return _shadow_texture_rect.visible
	
func _ready():
	pass
	
func _blink() -> void:
	while true:
		_blinking_timer.start(rand_range(blink_interval.x, blink_interval.y))
		yield(_blinking_timer, "timeout")
		_eyes_texture_rect.texture = character.get_texture_set(_humor_id).texture_eye_closed
		_blinking_timer.start(rand_range(blink_time.x, blink_time.y))
		yield(_blinking_timer, "timeout")
		_eyes_texture_rect.texture = character.get_texture_set(_humor_id).texture_eye_open
