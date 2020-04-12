extends Node

export(Dictionary) var _character_data_by_id

func get_character(id: String) -> Character:
	return _character_data_by_id[id]
