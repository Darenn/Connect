extends Control



enum DisplayMode {
	INSTANT, # Text is displayed instant
	TYPED, # Text is displayed character by character
	FADE # Text is displayed by fading
}

export(DisplayMode) var display_mode = DisplayMode.INSTANT

func _ready():
	pass
	#display_text("This is a [s]t[/s]est", 2)

# Display the given text at speed character per second
func display_text(text: String, speed: int = 10) -> void:
	$label.clear()
	$label.visible_characters = 0
	$label.append_bbcode(text)
	$Tween.interpolate_property(self, "visible_characters", 0, text.length(),
			text.length() / speed, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()
