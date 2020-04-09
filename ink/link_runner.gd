extends Node

const InkRunner = preload("res://ink/ink_runner.gd")
const LinkParser = preload("res://ink/link_parser.gd")

onready var ink_runner: InkRunner = $InkRunner

var _is_story_loaded = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ink_runner.connect("story_is_loaded", self, "_on_ink_runner_story_loaded")

func _on_ink_runner_story_loaded() -> void:
	_is_story_loaded = true
	
func _process(delta: float) -> void:
	if (_is_story_loaded):
		if(Input.is_action_just_pressed("ui_accept") and ink_runner.can_continue()):
			ink_runner.continue_story()
			var parsed_story: LinkParser = ink_runner.parse_story()
			$Label.display_text(parsed_story.text)
		else:
			pass
