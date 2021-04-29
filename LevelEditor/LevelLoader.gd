extends Node


func load_level(level_to_load : String):
	var level = ResourceLoader.load(level_to_load).instance()
	get_parent().get_node("LevelEditorLevel").get_child(0).queue_free()
	get_parent().get_node("LevelEditorLevel").add_child(level)
	get_parent().tiles = level.get_node("Tiles")
	get_parent().decoration = level.get_node("Decoration")
	get_parent().player_tile = level.get_node("PlayerTile")
	get_parent().examine_loaded_level()

