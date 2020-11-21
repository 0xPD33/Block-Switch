extends Node

const FILE_NAME = "user://savegame.json"

var save_data = {
	"level_times": {},
	"level_ratings": {}
}


func save_level_time(level_num : int, time : float):
	if save_data["level_times"].empty():
		save_data["level_times"]["Level" + str(level_num)] = time
	else:
		if time < save_data["level_times"]["Level" + str(level_num)]:
			save_data["level_times"]["Level" + str(level_num)] = time
		else:
			return


func load_level_time(level_num : int):
	if save_data["level_times"].has("Level" + str(level_num)):
		return save_data["level_times"]["Level" + str(level_num)]
	else:
		return "---"


# TODO: Fix saving of ratings

func save_level_rating(level_num : int, rating : String):
	if save_data["level_ratings"].empty():
		save_data["level_ratings"]["Level" + str(level_num)] = rating
	else:
		print(rating.to_int())


func load_level_rating(level_num : int):
	if save_data["level_ratings"].has("Level" + str(level_num)):
		return save_data["level_ratings"]["Level" + str(level_num)]
	else:
		return "---"

# TODO: Make data actually save to file

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

