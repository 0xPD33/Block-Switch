extends Node

const SAVE_FILE_NAME = "user://savegame.json"
const OPTIONS_FILE_NAME = "user://options.json"

var save_data = {
	"levels_unlocked": [1],
	"level_times": {},
	"level_ratings": {},
	"tutorials_shown": {}
}

var options_data = {
	"sfx_volume": 0,
	"music_volume": 0,
	"sfx_muted": false,
	"music_muted": false,
	"controls_position_x": 320,
	"controls_position_y": 110,
	"controls_size_x": 1,
	"controls_size_y": 1
}


func save_levels_unlocked():
	save_data["levels_unlocked"] = Global.levels_unlocked


func load_levels_unlocked():
	return save_data["levels_unlocked"]


func save_level_time(level_num : int, time : String):
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
	save_game()


func save_sfx_volume():
	options_data["sfx_volume"] = GlobalOptions.sfx_volume
	options_data["sfx_muted"] = GlobalOptions.sfx_muted


func save_music_volume():
	options_data["music_volume"] = GlobalOptions.music_volume
	options_data["music_muted"] = GlobalOptions.music_muted


func save_controls_position():
	options_data["controls_position_x"] = GlobalOptions.controls_position_x
	options_data["controls_position_y"] = GlobalOptions.controls_position_y


func save_controls_size():
	options_data["controls_size_x"] = GlobalOptions.controls_size_x
	options_data["controls_size_y"] = GlobalOptions.controls_size_y


func load_master_volume():
	if options_data.has("master_volume"):
		return options_data["master_volume"]


func load_master_muted():
	if options_data.has("master_muted"):
		return options_data["master_muted"]


func load_sfx_volume():
	if options_data.has("sfx_volume"):
		return options_data["sfx_volume"]


func load_sfx_muted():
	if options_data.has("sfx_muted"):
		return options_data["sfx_muted"]


func load_music_volume():
	if options_data.has("music_volume"):
		return options_data["music_volume"]


func load_music_muted():
	if options_data.has("music_muted"):
		return options_data["music_muted"]


func load_controls_position_x():
	if options_data.has("controls_position_x"):
		return options_data["controls_position_x"]


func load_controls_position_y():
	if options_data.has("controls_position_y"):
		return options_data["controls_position_y"]


func load_controls_size_x():
	if options_data.has("controls_size_x"):
		return options_data["controls_size_x"]


func load_controls_size_y():
	if options_data.has("controls_size_y"):
		return options_data["controls_size_y"]


func save_game():
	var file = File.new()
	file.open(SAVE_FILE_NAME, File.WRITE)
	file.store_string(to_json(save_data))
	file.close()


func save_options():
	var file = File.new()
	file.open(OPTIONS_FILE_NAME, File.WRITE)
	file.store_string(to_json(options_data))
	file.close()


func load_game():
	var file = File.new()
	if file.file_exists(SAVE_FILE_NAME):
		file.open(SAVE_FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			save_data = data
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")


func load_options():
	var file = File.new()
	if file.file_exists(OPTIONS_FILE_NAME):
		file.open(OPTIONS_FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			options_data = data
		else:
			printerr("Corrupted options data!")
	else:
		printerr("No saved options data!")


func delete_save_file():
	save_data["levels_unlocked"].clear()
	save_data["level_times"].clear()
	save_data["level_ratings"].clear()
	var dir = Directory.new()
	dir.remove(SAVE_FILE_NAME)
	save_data["levels_unlocked"].append(1)


func delete_options_file():
	options_data.clear()
	var dir = Directory.new()
	dir.remove(OPTIONS_FILE_NAME)
	options_data["sfx_volume"] = 0
	options_data["music_volume"] = 0
	options_data["sfx_muted"] = false
	options_data["music_muted"] = false
	options_data["controls_position_x"] = 320
	options_data["controls_position_y"] = 110
	options_data["controls_size_x"] = 1
	options_data["controls_size_y"] = 1

