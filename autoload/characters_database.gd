extends Node

"""
Contains all characters data.
"""

# Dictionary<character_id: String, char: Character>
export(Dictionary) var character_data_by_id

func get_character(id: String) -> Character:
	return character_data_by_id[id]
