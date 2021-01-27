extends Node2D

var min_zoom = Vector2(3, 3)
var max_zoom = Vector2(4, 4)
var zoom_step : float = 0.1

var move_enabled : bool = false

onready var level_editor_cam = $LevelEditorCamera


func _unhandled_input(event):
	if move_enabled:
		if event is InputEventScreenDrag:
			global_position -= event.relative * level_editor_cam.zoom.x

