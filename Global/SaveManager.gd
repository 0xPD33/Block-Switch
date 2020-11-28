extends Node

const FILE_NAME = "user://savegame.json"

var save_data = {
	"levels_unlocked": [1],
	"level_times": {},
	"level_ratings": {}
}


func save_levels_unlocked():
	save_data["levels_unlocked"] = Global.levels_unlocked


func load_levels_unlocked():
	return save_data["levels_unlocked"]


func save_level_time(level_num : int, time : float):
	if save_data["level_times"].has("Level" + str(level_num)):
		if time < save_data["level_times"]["Level" + str(level_num)]:
			save_data["level_times"]["Level" + str(level_num)] = time
		else:
			return
	else:
		save_data["level_times"]["Level" + str(level_num)] = time


func load_level_time(level_num : int):
	if save_data["level_times"].has("Level" + str(level_num)):
		return save_data["level_times"]["Level" + str(level_num)]
	else:
		return "---"


func save_level_rating(level_num : int, rating : String):
	if save_data["level_ratings"].has("Level" + str(level_num)):
		var new_rating_num = rating.trim_suffix("/8").to_int()
		var old_rating_num = save_data["level_ratings"]["Level" + str(level_num)].trim_suffix("/8").to_int()
		if new_rating_num > old_rating_num:
			save_data["level_ratings"]["Level" + str(level_num)] = rating
		else:
			return
	else:
		save_data["level_ratings"]["Level" + str(level_num)] = rating


func load_level_rating(level_num : int):
	if save_data["level_ratings"].has("Level" + str(level_num)):
		return save_data["level_ratings"]["Level" + str(level_num)]
	else:
		return "---"


func delete_level_score(level_num : int):
	save_data["level_times"].erase("Level" + str(level_num))
	save_data["level_ratings"].erase("Level" + str(level_num))


func save_game():
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(save_data))
	file.close()


func load_game():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			save_data = data
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")


func delete_save_file():
	save_data["levels_unlocked"].clear()
	save_data["level_times"].clear()
	save_data["level_ratings"].clear()
	var dir = Directory.new()
	dir.remove("user://savegame.json")
	save_data["levels_unlocked"].append(1)

