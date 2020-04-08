# ############################################################################ #
# Copyright © 2020-present Darenn Keller <keller.darenn@gmail.com>
# Licensed under the MIT License.
# See LICENSE in the project root for license information.
# ############################################################################ #

extends Node

# ############################################################################ #
# Documentation
# ############################################################################ #

# InkRunner is an interface with the InkGD addon to manipulate ink stories.

# ############################################################################ #
# Imports
# ############################################################################ #

const InkRuntime = preload("res://addons/inkgd/runtime.gd")
const Story = preload("res://addons/inkgd/runtime/story.gd")

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

	var test = LInkParagraph.new("   lana   (   happy   ): This is a ***big*** test **sentence** to try the *convert* bbcode method")

func _exit_tree():
	call_deferred("_remove_runtime")
	
# ############################################################################ #
# Public Methods
# ############################################################################ #

func continue_story() -> String:
	if story.can_continue:
		var text: String = story.continue()
		if story.current_choices.size() > 0:
			story.choose_choice_index(0)
		return text
	return "end of story"

# ############################################################################ #
# Private Methods
# ############################################################################ #

func _load_story(ink_story_path):
	var ink_story = File.new()
	ink_story.open(ink_story_path, File.READ)
	var content = ink_story.get_as_text()
	ink_story.close()	
	self.story = Story.new(content)
	
func _init_ink():
	_add_runtime()
	_load_story(path_to_compiled_ink)

func _add_runtime():
	InkRuntime.init(get_tree().root)
	

func _remove_runtime():
	InkRuntime.deinit(get_tree().root)
