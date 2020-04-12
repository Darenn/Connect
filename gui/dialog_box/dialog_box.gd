extends Control

class_name DialogBox

enum DisplayMode {
	INSTANT, # Text is displayed instant
	TYPED, # Text is displayed character by character
	FADE # Text is displayed by fading
}

export(DisplayMode) var display_mode = DisplayMode.INSTANT

onready var label: RichTextLabel = $Background/RichTextLabel
onready var label_tween: Tween = $Background/RichTextLabel/Tween 

func _ready():
	pass

# Display the given text at speed character per second
func display_text(text: String, speed: int = 10) -> void:
	label.clear()
	label.visible_characters = 0
	label.append_bbcode(text)
	label_tween.interpolate_property(self, "visible_characters", 0, text.length(),
			text.length() / speed, Tween.TRANS_QUAD, Tween.EASE_OUT)
	label_tween.start()