extends Node

export(Dictionary) var character_data_by_id

func get_character(id: String) -> Character:
	return character_data_by_id[id]
