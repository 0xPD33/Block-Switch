extends Node2D

var min_zoom = 3
var max_zoom = 4
var zoom_sensitivity = 10
var zoom_step = 0.05

var events := {}
var last_drag_distance = 0

var move_enabled : bool = false

onready var level_editor_grid = get_parent().get_node("Grid/ParallaxLayer/LevelEditorGrid")
onready var level_editor_cam = $LevelEditorCamera


func _unhandled_input(event):
	if move_enabled:
		if event is InputEventScreenTouch:
			if event.pressed:
				events[event.index] = event
			else:
				events.erase(event.index)
		if event is InputEventScreenDrag:
			events[event.index] = event
			if events.size() == 1:
				global_position -= event.relative * level_editor_cam.zoom.x
			elif events.size() == 2:
				var drag_distance = events[0].position.distance_to(events[1].position)
				if abs(drag_distance - last_drag_distance) > zoom_sensitivity:
					var new_zoom = (1 + zoom_step) if drag_distance < last_drag_distance else (1 - zoom_step)
					new_zoom = clamp(level_editor_cam.zoom.x * new_zoom, min_zoom, max_zoom)
					level_editor_cam.zoom = Vector2.ONE * new_zoom
					print(level_editor_grid.region_rect)
					last_drag_distance = drag_distance

