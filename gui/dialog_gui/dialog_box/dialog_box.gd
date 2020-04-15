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
export(int) var text_margin = 60
# When sentence is under 10 characters, will use this size as label.rect_size.x
export(int) var font_character_width = 29

onready var _starting_size_x
onready var _starting_size_y
onready var _label: RichTextLabel = $Background/RichTextLabel
onready var _label_tween: Tween = $Background/RichTextLabel/Tween 

func _ready():
	# Need to wait another frame so that rect_size is properly update in engine
	yield(get_tree(), "idle_frame")
	_starting_size_x = self.rect_size.x
	_starting_size_y = self.rect_size.y
#	display_text("MY NAME I")
#	display_text("Hello there! How do you feel today? I feel very great. \n" +
#	"I managed to change the dialog box size dynamically relative to the text size. " +
#	"It wasn't easy, there's a strange bug that forces me to wait one frame between each displays. ")


func clear():
	_label.clear()
	
func _process(delta) -> void:
	pass

# Adjust the size of the dialog box relative to its text content
func _adjust_size() -> void:
	self.rect_size.y = _label.get_content_height() * 1.2
	if _label.get_visible_line_count() <= 1:
		rect_size.x = _label.get_font("normal_font").get_string_size(_label.text).x * 1.2

# Display the given text at speed character per second
func display_text(text: String, speed: int = 25) -> void:
	_label_tween.stop_all()
	_label.visible_characters = -1
	self.rect_size.x = _starting_size_x
	self.rect_size.y = _starting_size_y
	_label.clear()
	_label.push_align(RichTextLabel.ALIGN_CENTER)
	_label.append_bbcode(text)
	# VERY DIRTY but label properties are updated at drawing...
	propagate_notification(NOTIFICATION_DRAW)
	_adjust_size()
	_label.visible_characters = 0
	
	_label_tween.interpolate_property(_label, "visible_characters", 0, text.length(),
			text.length() / speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_label_tween.start()
