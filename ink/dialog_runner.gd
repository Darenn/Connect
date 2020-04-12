extends Node

class_name DialogRunner

signal on_new_message(message, actor_id)
signal on_dialog_over()

onready var ink_runner: InkRunner = $InkRunner

#var current_talking_character_id: String
#var characters_id_in_dialog: Array # Array<String>
#var current_message: Array # Array<String>

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_accept")):
		_process_parsed_story()
		
func _process_parsed_story():
	if not ink_runner.continue_story():
		emit_signal("on_dialog_over")
		return
	var parsed_story: LinkParser = ink_runner.parse_story()
	if parsed_story.is_command():
		CommandRunner.run_command(parsed_story.text)
		_process_parsed_story()
		return
	emit_signal("on_new_message", parsed_story.text, parsed_story.character_id)
	for tag in parsed_story.tags + parsed_story.inline_tags:
		CommandRunner.run_command(tag)

		
	
