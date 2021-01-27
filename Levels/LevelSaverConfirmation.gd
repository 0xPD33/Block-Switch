extends Control

var level_editor
var level_editor_panel
var level_editor_options_panel

var is_opened : bool = false

onready var level_name_edit = $LevelSaverPanel/VBoxContainer/LevelNameEdit
onready var anim_player = $AnimationPlayer


func _ready():
	level_editor = get_parent().get_parent()
	level_editor_panel = level_editor.get_node("UI/LevelEditorPanel")
	level_editor_options_panel = level_editor.get_node("UI/LevelEditorOptionsPanel")


func open():
	if !is_opened:
		anim_player.play("open_confirmation")
		is_opened = true
		if level_editor_panel.is_open:
			level_editor_panel.close_level_editor_panel()
		if level_editor_options_panel.is_open:
			level_editor_options_panel.close_options_panel()
		yield(anim_player, "animation_finished")
		get_tree().paused = true
	

func close():
	if is_opened:
		anim_player.play("close_confirmation")
		if !level_editor_panel.is_open:
			level_editor_panel.open_level_editor_panel()
		if !level_editor_options_panel.is_open:
			level_editor_options_panel.open_options_panel()
		yield(anim_player, "animation_finished")
		is_opened = false
		get_tree().paused = false


func _on_AcceptButton_pressed():
	var level_name : String = level_name_edit.text
	level_editor.save_level(level_name)
	close()


func _on_CancelButton_pressed():
	close()

