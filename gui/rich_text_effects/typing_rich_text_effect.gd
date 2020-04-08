tool
extends RichTextEffect
class_name TypingRichTextEffect

# Syntax: [typing speed=5][/typing]
# The speed argument is the number of characters typed per second

var bbcode := "typing"

func _process_custom_fx(char_fx : CharFXTransform):
	var speed: int = char_fx.env.get("speed", 10)
	var character_count_to_display := (speed * char_fx.elapsed_time) as int
	if char_fx.absolute_index < character_count_to_display:
		char_fx.visible = true
	else:
		char_fx.visible = false
	return true
