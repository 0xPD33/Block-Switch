extends Node


func load_level(level_to_load : String):
	var level = ResourceLoader.load(level_to_load).instance()
	get_parent().get_node("LevelEditorLevel").get_child(0).queue_free()
	get_parent().get_node("LevelEditorLevel").add_child(level)
	get_parent().tiles = level.get_node("Tiles")
	get_parent().decoration = level.get_node("Decoration")
	get_parent().player_tile = level.get_node("PlayerTile")
	get_parent().examine_loaded_level()


func export_level(level_to_export : String):
	var dir = Directory.new()
	# this shit is bugged (check https://godotengine.org/qa/101388/how-can-get-directory-copy-work-when-using-acces-file-system?show=101388#q101388)
	var downloads_folder = str(OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS))
	print(downloads_folder)
	print(dir.copy(level_to_export, downloads_folder))
	if dir.open(downloads_folder) == OK:
		dir.copy(level_to_export, downloads_folder)

