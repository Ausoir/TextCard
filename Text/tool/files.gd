extends Node

const Template = preload("res://asset/data/template.json")
var unit = preload("res://asset/data/unit.json").get_data()
var skill = preload("res://asset/data/skill.json").get_data()


func _init():
	for key in skill:
		skill[key]["name"] = key


func is_valid(path):
	return FileAccess.file_exists(path) and FileAccess.open(path, FileAccess.READ).get_length() > 2


func save(data):
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string = JSON.stringify(data)
	save_game.store_line(json_string)


func load_json(path):
	if FileAccess.file_exists(path):
		var save_game = FileAccess.open(path, FileAccess.READ)
		while save_game.get_position() < save_game.get_length():
			var json_string = save_game.get_line()

			var json = JSON.new()
			var parse_result = json.parse(json_string)
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
				continue

			var node_data = json.get_data()
			return node_data
	return {}

