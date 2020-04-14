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
onready var label: RichTextLabel = $Background/RichTextLabel
onready var label_tween: Tween = $Background/RichTextLabel/Tween 

func _ready():
	pass
#	display_text("Hello there! How do you feel today? I feel very great. \n" +
#	"I managed to change the dialog box size dynamically relative to the text size. " +
#	"It wasn't easy, there's a strange bug that forces me to wait one frame between each displays. ")


func clear():
	label.clear()

# Display the given text at speed character per second
# TODO: I got a strange bug, the end of the text was written above the last line! 
# Maybe a problem of size when looking at the content height? Mayby scrolling ?
func display_text(text: String, speed: int = 20) -> void:
	label.clear()
	label.visible_characters = 0
	label.push_align(RichTextLabel.ALIGN_CENTER)
	label.append_bbcode(text)
	# Need to wait 1 frame so that the text is drawn, 
	# and that we can get the content height
	yield(get_tree(), "idle_frame") 
	self.rect_size.y = label.get_content_height() + text_margin
	label_tween.interpolate_property(label, "visible_characters", 0, text.length(),
			text.length() / speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	label_tween.start()
