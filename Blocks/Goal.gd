extends Area2D

var tile_size = 64

# LEVEL EDITOR VARIABLES

var editor
var editor_mode = false

#


func _ready():
	if get_tree().current_scene.name == "LevelEditor":
		editor = get_tree().current_scene
		editor_mode = true
	snap()


func snap():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2


func _on_Goal_area_entered(area: Area2D):
	if area.is_in_group("Player"):
		if editor_mode:
			editor.stop_testing_level(true)
		else:
			get_tree().call_group("Game", "level_done")

