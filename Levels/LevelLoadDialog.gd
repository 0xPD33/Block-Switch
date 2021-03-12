extends Control

var level_editor
var level_editor_panel
var level_editor_options_panel

onready var file_dialog = $FileDialog


func _ready():
	level_editor = get_parent().get_parent()
	level_editor_panel = level_editor.get_node("UI/LevelEditorPanel")
	level_editor_options_panel = level_editor.get_node("UI/LevelEditorOptionsPanel")


func open():
	file_dialog.show()


func _on_FileDialog_file_selected(path: String):
	level_editor.load_level(path)

