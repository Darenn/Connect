extends Reference
class_name LinkParser

# Represents all informations gotten from a link paragraph

const InkChoice = preload("res://addons/inkgd/runtime/choice.gd")
const InkStory = preload("res://addons/inkgd/runtime/story.gd")

const NO_ACTOR := "none"
const NO_HUMOR := "none"
const COMMAND_SYMBOL := ">>>"

var text: String = ""
var actor_id: String = NO_ACTOR
var actor_humor: String = NO_HUMOR
var tags: PoolStringArray
var choices: Array = [] # Array<Choice>
var is_command: bool = false
var ink_story: InkStory

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
		_convert_markdown_to_bbcode()
		
func _convert_markdown_to_bbcode() -> void:
	_convert_symbol_to_bbcode("***", "[b][i]", "[/b][/i]")
	_convert_symbol_to_bbcode("**", "[b]", "[/b]")
	_convert_symbol_to_bbcode("*", "[i]", "[/i]")
	_convert_symbol_to_bbcode("___", "[b][i]", "[/b][/i]")
	_convert_symbol_to_bbcode("__", "[b]", "[/b]")
	_convert_symbol_to_bbcode("_", "[i]", "[/i]")

	print(text)
	
func _convert_symbol_to_bbcode(from: String, to_open: String, to_close: String) -> void:
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
