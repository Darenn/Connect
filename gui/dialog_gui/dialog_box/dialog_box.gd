extends Control
class_name DialogBox

"""
Displays messages in a dialog box.
"""

enum DisplayMode {
	INSTANT, # Text is displayed instant
	TYPED, # Text is displayed character by character
	FADE # Text is displayed by fading
}

export(DisplayMode) var display_mode = DisplayMode.INSTANT
# Height added to the box in pixel, a value of 0 means the box has the height
# of the current text.
export(int) var text_margin = 40
# When sentence is under 10 characters, will use this size as label.rect_size.x
export(int) var font_character_width = 29

onready var _starting_size_x = self.rect_size.x
onready var _label: RichTextLabel = $Background/RichTextLabel
onready var _label_tween: Tween = $Background/RichTextLabel/Tween 

func _ready():
	# Need to wait another frame so that rect_size is properly update in engine
	yield(get_tree(), "idle_frame")
	_starting_size_x = self.rect_size.x
	display_text("MY NAME I")
#	display_text("Hello there! How do you feel today? I feel very great. \n" +
#	"I managed to change the dialog box size dynamically relative to the text size. " +
#	"It wasn't easy, there's a strange bug that forces me to wait one frame between each displays. ")


func clear():
	_label.clear()

# Display the given text at speed character per second
# TODO: I got a strange bug, the end of the text was written above the last line! 
# Maybe a problem of size when looking at the content height? Mayby scrolling ?
# Ok seems like very long word make the bug
func display_text(text: String, speed: int = 20) -> void:
	_label.clear()
	_label.visible_characters = 0
	_label.push_align(RichTextLabel.ALIGN_CENTER)
	_label.append_bbcode(text)
	# Need to wait 1 frame so that the text is drawn, 
	# and that we can get the content height
	yield(get_tree(), "idle_frame") 
	if _label.get_total_character_count() <= 19:
		#TODO very dirty, but did not find a better solution
#		self.rect_size.x = 	label.get_font("mono_font").get_string_size(label.text).x 
		self.rect_size.x = _label.get_total_character_count() * font_character_width 
	else:
		self.rect_size.x = _starting_size_x
	self.rect_size.y = _label.get_content_height() + text_margin
	_label_tween.interpolate_property(_label, "visible_characters", 0, text.length(),
			text.length() / speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	_label_tween.start()
