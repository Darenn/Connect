tool
extends RichTextEffect
class_name FadeInRichTextEffect

# Syntax: [fade_in speed=5][/fade_in]
# The speed argument is the number of characters fade in per second

var bbcode := "ffade_in"

func _process_custom_fx(char_fx : CharFXTransform):
	var speed: int = char_fx.env.get("speed", 5)
	var character_count_to_fade_in := (speed * char_fx.elapsed_time) as float
	if char_fx.absolute_index < character_count_to_fade_in:
		char_fx.color.a = \
				clamp(character_count_to_fade_in - char_fx.absolute_index, 0, 1)
	else:
		char_fx.color.a = 0
	return true
