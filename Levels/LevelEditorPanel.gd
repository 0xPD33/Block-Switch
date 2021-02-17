extends Control

var level_editor
var level_editor_camera_container

var is_open : bool = false

onready var level_editor_selected_block = $LevelEditorSelectedBlock
onready var level_editor_button_grid = $BigPanel/MarginContainer/LevelEditorButtonGrid

onready var open_panel_button = $OpenPanelButton

onready var move_tween = $MoveTween


func _ready():
	level_editor_button_grid.level_editor_panel = self
	level_editor_button_grid.connect_buttons()
	if get_parent().get_parent():
		if get_parent().get_parent().name == "LevelEditor":
			level_editor = get_parent().get_parent()
			level_editor_camera_container = level_editor.get_node("LevelEditorCameraContainer")
	if !is_open:
		move_tween.interpolate_property(self, "rect_position:x", rect_position.x + 55, rect_position.x, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		move_tween.start()
		open_panel_button.text = ">"
		is_open = true


func open_level_editor_panel():
	move_tween.interpolate_property(self, "rect_position:x", rect_position.x, rect_position.x - 55, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	move_tween.start()
	open_panel_button.text = ">"
	is_open = true


func close_level_editor_panel():
	move_tween.interpolate_property(self, "rect_position:x", rect_position.x, rect_position.x + 55, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	move_tween.start()
	open_panel_button.text = "<"
	yield(move_tween, "tween_completed")
	is_open = false


func disable_buttons():
	$SmallPanel/ButtonContainer/MoveButton.disabled = true
	$SmallPanel/ButtonContainer/DeleteButton.disabled = true


func enable_buttons():
	$SmallPanel/ButtonContainer/MoveButton.disabled = false
	$SmallPanel/ButtonContainer/DeleteButton.disabled = false


func _on_button_pressed(block_name : String, block_image: Texture, block_modulate: Color):
	level_editor.select_block(block_name)
	level_editor_selected_block.change_selected_block(block_name, block_image, block_modulate)
	level_editor_camera_container.move_enabled = false
	level_editor.can_delete = false
	$SmallPanel/ButtonContainer/MoveButton.pressed = false
	$SmallPanel/ButtonContainer/DeleteButton.pressed = false


func _on_MoveButton_pressed():
	level_editor_camera_container.move_enabled = !level_editor_camera_container.move_enabled
	level_editor_selected_block.remove_selected_block()
	level_editor.current_block_selected = null
	level_editor.can_delete = false
	$SmallPanel/ButtonContainer/DeleteButton.pressed = false


func _on_DeleteButton_pressed():
	level_editor.can_delete = !level_editor.can_delete
	level_editor_selected_block.remove_selected_block()
	level_editor.current_block_selected = null
	level_editor_camera_container.move_enabled = false
	$SmallPanel/ButtonContainer/MoveButton.pressed = false


func _on_OpenPanelButton_pressed():
	if !is_open:
		open_level_editor_panel()
	else:
		close_level_editor_panel()

