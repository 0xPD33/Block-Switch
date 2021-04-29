extends Control

var level_editor
var level_editor_panel
var level_editor_options_panel

enum modes {LOAD, EXPORT}
var current_mode

var is_opened : bool = false

onready var file_dialog = $FileDialog
onready var anim_player = $AnimationPlayer


func _ready():
	if get_tree().current_scene.name == "LevelEditor":
		level_editor = get_tree().current_scene
		level_editor_panel = level_editor.get_node("UI/LevelEditorPanel")
		level_editor_options_panel = level_editor.get_node("UI/LevelEditorOptionsPanel")
	file_dialog.add_filter("*.tscn ; Custom Levels")


func open():
	if !is_opened:
		anim_player.play("open_dialog")
		is_opened = true
		if level_editor_panel.is_open:
			level_editor_panel.close_level_editor_panel()
		if level_editor_options_panel.is_open:
			level_editor_options_panel.close_options_panel()
		yield(anim_player, "animation_finished")
		get_tree().paused = true


func close():
	if is_opened:
		anim_player.play("close_dialog")
		if !level_editor_panel.is_open:
			level_editor_panel.open_level_editor_panel()
		if !level_editor_options_panel.is_open:
			level_editor_options_panel.open_options_panel()
		yield(anim_player, "animation_finished")
		is_opened = false
		get_tree().paused = false


func _on_LoadButton_pressed():
	current_mode = modes.LOAD
	file_dialog.window_title = "Open a File"
	file_dialog.show()
	file_dialog.invalidate()


func _on_ExportButton_pressed():
	current_mode = modes.EXPORT
	file_dialog.window_title = "Pick a File to Export"
	file_dialog.show()
	file_dialog.invalidate()


func _on_CancelButton_pressed():
	close()


func _on_FileDialog_file_selected(path: String):
	if current_mode == modes.LOAD:
		level_editor.load_level(path)
	elif current_mode == modes.EXPORT:
		level_editor.export_level(path)
	close()


