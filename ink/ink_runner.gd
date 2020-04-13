# ############################################################################ #
# Copyright © 2020-present Darenn Keller <keller.darenn@gmail.com>
# Licensed under the MIT License.
# See LICENSE in the project root for license information.
# ############################################################################ #

extends Node
class_name InkRunner

# ############################################################################ #
# Documentation
# ############################################################################ #

# InkRunner is an interface with the InkGD addon to manipulate ink stories and 
# setup the InkRuntime env.
# The Dialog UI should listen to the signals to display the dialog.

# ############################################################################ #
# Imports
# ############################################################################ #

const InkRuntime = preload("res://addons/inkgd/runtime.gd")
const Story = preload("res://addons/inkgd/runtime/story.gd")

# ############################################################################ #
# Imports
# ############################################################################ #

signal story_is_loaded()
signal on_dialog_paragraph_received(paragraph, actor_id, humor_id)
signal on_dialog_started()
signal on_dialog_finished()

# ############################################################################ #
# Exported Variables
# ############################################################################ #

export(String, FILE, ".json") var path_to_compiled_ink

# ############################################################################ #
# Public Properties
# ############################################################################ #

var story: Story

# ############################################################################ #
# Lifecycle
# ############################################################################ #

func _ready():
	call_deferred("_init_ink")

func _exit_tree():
	call_deferred("_remove_runtime")
	
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_accept")):
		_process_parsed_story()
	
# ############################################################################ #
# Public Methods
# ############################################################################ #

func can_continue() -> bool:
	return story.can_continue;

func continue_story() -> bool:
	if story.can_continue:
		story.continue()
		return true
	else:
		return false
	
func parse_story() -> LinkParser:
	return LinkParser.new(story)

# ############################################################################ #
# Private Methods
# ############################################################################ #

func _process_parsed_story():
	if not continue_story():
		emit_signal("on_dialog_finished")
		return
	var parsed_story: LinkParser = parse_story()
	if parsed_story.is_command:
		CommandRunner.run_command(parsed_story.text)
		_process_parsed_story()
		return
	for tag in parsed_story.tags + parsed_story.inline_tags:
		CommandRunner.run_command(tag)
	emit_signal("on_dialog_paragraph_received", 
		parsed_story.text, parsed_story.character_id,
		parsed_story.character_humor)


func _load_story(ink_story_path):
	var ink_story = File.new()
	ink_story.open(ink_story_path, File.READ)
	var content = ink_story.get_as_text()
	ink_story.close()	
	self.story = Story.new(content)

func _init_ink():
	_add_runtime()
	_load_story(path_to_compiled_ink)
	emit_signal("story_is_loaded")


func _add_runtime():
	InkRuntime.init(get_tree().root)
	

func _remove_runtime():
	InkRuntime.deinit(get_tree().root)
