extends Node

var level_string_in_engine : NodePath

var level_saved : bool = false
var last_level_name : String
var saved_level_names : Array = []


func save_level(level_name : String):
	var level_to_save : PackedScene = PackedScene.new()
	var level_string = "user://" + level_name + ".tscn"
	if check_if_level_exists(level_string) == false:
		if !level_saved:
			level_string_in_engine = "LevelEditorLevel/LevelTemplate"
		else:
			level_string_in_engine = "LevelEditorLevel/" + last_level_name
		var level = get_parent().get_node(level_string_in_engine)
		for node in level.get_children():
			node.owner = level
		level.name = level_name
		level_to_save.pack(level)
		ResourceSaver.save(level_string , level_to_save)
		last_level_name = level_name
		saved_level_names.append(level_name)
		level_saved = true
	else:
		print("level exists already, aborting")


func check_if_level_exists(path):
	var dir = Directory.new()
	var check_if_exists = dir.file_exists(path)
	return check_if_exists

