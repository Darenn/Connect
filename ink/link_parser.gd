# ############################################################################ #
# Copyright © 2020-present Darenn Keller <keller.darenn@gmail.com>
# Licensed under the MIT License.
# See LICENSE in the project root for license information.
# ############################################################################ #

extends Reference
class_name LinkParser

# ############################################################################ #
# Documentation
# ############################################################################ #

# Represents all informations got from a link paragraph in a story.
# The story is parsed at contruction, filling all the public properties.

# ############################################################################ #
# Imports
# ############################################################################ #

const InkChoice = preload("res://addons/inkgd/runtime/choice.gd")
const InkStory = preload("res://addons/inkgd/runtime/story.gd")

# ############################################################################ #
# Const Variables
# ############################################################################ #

const NO_ACTOR := "none"
const NO_HUMOR := "none"

# Commands begins with this symbol
const COMMAND_SYMBOL := ">>>"

# Symbols used by inline tags
const INLINE_TAG_START_SYMBOL := "<"
const INLINE_TAG_END_SYMBOL := ">"
const INLINE_TAG_CLOSE_SYMBOL := "/"

# ############################################################################ #
# Public Properties
# ############################################################################ #

var text: String = ""
var actor_id: String = NO_ACTOR
var actor_humor: String = NO_HUMOR
var tags: PoolStringArray
var choices: Array = [] # Array<Choice>
var is_command: bool = false
var ink_story: InkStory
var inline_tags: Array = [] #Array<String>

# ############################################################################ #
# Lifecycle
# ############################################################################ #

func _init(story: InkStory):
	story = story
	text = story.get_current_text().strip_edges()
	tags = story.get_current_tags()
	choices = story.get_current_choices()
	if text.begins_with(COMMAND_SYMBOL):
		is_command = true
		text = text.lstrip(COMMAND_SYMBOL)
		return
	else:
		_parse_actor_definition()
		_convert_markdown_to_bbcode() # The RichTextLabel will use the bbcodes
		_parse_inline_tags()
	pass
		
# ############################################################################ #
# Private Methods
# ############################################################################ #

# Convert all markdown tags to bbcode tags		
func _convert_markdown_to_bbcode() -> void:
	_convert_simple_tags_to_openclose_tags("***", "[b][i]", "[/i][/b]")
	_convert_simple_tags_to_openclose_tags("**", "[b]", "[/b]")
	_convert_simple_tags_to_openclose_tags("*", "[i]", "[/i]")
	_convert_simple_tags_to_openclose_tags("___", "[b][i]", "[/i][/b]")
	_convert_simple_tags_to_openclose_tags("__", "[b]", "[/b]")
	_convert_simple_tags_to_openclose_tags("_", "[i]", "[/i]")

	print(text)

# Convert all simple tags from text property to openclose tags 
# Example : **bold** -> [b]bold[/b]
func _convert_simple_tags_to_openclose_tags(from: String, to_open: String, to_close: String) -> void:
	var splited_text := text.split(from, false)
	text = ""
	var splited_text_size := splited_text.size()
	for i in range(0, splited_text_size, 2):
		if i + 1 >= splited_text_size:
			text += splited_text[i]
		else:
			text+= splited_text[i] + to_open + splited_text[i + 1] + to_close

# Finds the actor definition 'actor_name(humor):', and if it exists,
# removes it from the text and updates the the actor_id and actor_humor.
func _parse_actor_definition() -> void:
	# Get the actor definition and remove it from text
	var marker_index := text.find(":")
	if marker_index == -1: # No actor definition
		return
	if text.length() <= marker_index + 1:
		push_error("A paragraph with actor saying nothing is invalid.")
	var actor_definition: String = text.substr(0, marker_index)
	text = text.right(marker_index + 1)
	
	# Update the actor_id and actor_humor
	actor_id = actor_definition
	var humor_marker_index = actor_definition.find("(")
	if humor_marker_index != -1:
		actor_id = actor_definition.substr(0, humor_marker_index)
		var end_marker_index = actor_definition.find(")")
		if end_marker_index != -1:
			actor_humor = actor_definition.substr(humor_marker_index + 1, end_marker_index - humor_marker_index - 1)
		else:
			push_error("No end marker ')' found for humor.")
	actor_id = actor_id.strip_edges()
	actor_humor = actor_humor.strip_edges()

# Finds all inline tags (</wait>) and adds their content to the inline_tags property.
# Note that the index in the text is added to the end of their content to be used later.
# TODO _parse_non_orphan_tags
func _parse_inline_tags():
	_parse_orphan_tags()
	
# Finds all orphane inline tags (</wait>) and adds their content to the inline_tags property.
# Note that the index in the text is added to the end of their content to be used later.
func _parse_orphan_tags():
	var new_text := text
	for i in range(text.length()):
		var c := text[i]
		if c == INLINE_TAG_START_SYMBOL:
			if text[i + 1] == INLINE_TAG_CLOSE_SYMBOL:
				var close_index := text.find(INLINE_TAG_END_SYMBOL, i + 1)
				var length := close_index - i
				var inline_tag := text.substr(i, length)
				var inline_tag_command := inline_tag.substr(2, length - 1)
				new_text.erase(i, length + 1)
				inline_tag_command += " " + String(i)
				inline_tags.append(inline_tag_command)
	text = new_text
