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
export(Vector2) var talk_time: Vector2
export(Vector2) var talk_interval: Vector2
export(int) var max_talking_words: int

var current_humor_id: String setget set_current_humor_id
var is_shadow_visible: bool setget set_shadow_visible, get_shadow_visible
	
onready var _base_texture_rect: TextureRect = $Texture
onready var _eyes_texture_rect: TextureRect = $Eyes
onready var _mouth_texture_rect: TextureRect = $Mouth
onready var _shadow_texture_rect: TextureRect = $Texture/ShadowTexture
onready var _dialog_box_positions: Control = $DialogBoxPositions
onready var _blinking_timer: Timer = $Eyes/BlinkingTimer
onready var _talking_timer: Timer = $Mouth/TalkingTimer

# The character represented by the actor
var _character: Character
	
func init_actor(character_id: String, humor_id: String) -> void:
	_character = CharactersDB.get_character(character_id)
	self.current_humor_id = humor_id
	_shadow_texture_rect.texture = _base_texture_rect.texture
	_shadow_texture_rect.material.set_shader_param("shadow_color", _character.color)
	_shadow_texture_rect.material.set_shader_param("shadow_direction", Vector2(10, 10))
	visible = true
	_blink()

func get_dialog_box_position(position) -> Control:
	return _dialog_box_positions.get_child(position) as Control
	
func set_shadow_visible(is_visible: bool) -> void:
	_shadow_texture_rect.visible = is_visible
	
func get_shadow_visible() -> bool:
	return _shadow_texture_rect.visible
	
func talk(message: String, humor_id: String):
	self.current_humor_id = humor_id
	var word_count: int = message.split(" ", false).size()
	for i in range(min(word_count, max_talking_words)):
		_mouth_texture_rect.texture = _character.get_texture_set(current_humor_id).texture_mouth_open
		_talking_timer.start(rand_range(talk_time.x, talk_time.y))
		yield(_talking_timer, "timeout")
		_mouth_texture_rect.texture = _character.get_texture_set(current_humor_id).texture_mouth_closed
		_talking_timer.start(rand_range(talk_interval.x, talk_interval.y))
		yield(_talking_timer, "timeout")

func set_current_humor_id(humor_id: String):
	current_humor_id = humor_id
	_base_texture_rect.texture = _character.get_texture_set(humor_id).texture_base
	_eyes_texture_rect.texture = _character.get_texture_set(humor_id).texture_eye_open
	_mouth_texture_rect.texture = _character.get_texture_set(humor_id).texture_mouth_closed

func _ready():
	visible = false
	
func _blink() -> void:
	while true:
		_blinking_timer.start(rand_range(blink_interval.x, blink_interval.y))
		yield(_blinking_timer, "timeout")
		_eyes_texture_rect.texture = _character.get_texture_set(current_humor_id).texture_eye_closed
		_blinking_timer.start(rand_range(blink_time.x, blink_time.y))
		yield(_blinking_timer, "timeout")
		_eyes_texture_rect.texture = _character.get_texture_set(current_humor_id).texture_eye_open
