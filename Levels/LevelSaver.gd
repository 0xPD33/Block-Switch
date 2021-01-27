extends Node


func save_level(level_name : String):
	var level_to_save : PackedScene = PackedScene.new()
	var level = get_parent().get_node("LevelEditorLevel/LevelTemplate")
	for node in level.get_children():
		node.owner = level
	level_to_save.pack(level)
	var level_string : String = "res://" + level_name + ".tscn"
	ResourceSaver.save(level_string , level_to_save)

