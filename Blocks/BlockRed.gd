extends "res://Blocks/Block.gd"

enum rotation_modes {LEFT, RIGHT}
var rotation_mode

var triggered = false

# LEVEL EDITOR VARIABLES

var editor_mode = false

#


func set_rotation_mode(value):
	if value == 1:
		rotation_mode = rotation_modes.LEFT
	elif value == 2:
		rotation_mode = rotation_modes.RIGHT


func _ready():
	if get_tree().current_scene.name == "LevelEditor":
		editor_mode = true


func spin_level(player):
	var player_pos = player.position
	if rotation_mode == rotation_modes.LEFT:
		player.rotation_degrees -= 90
		player.controls.rotate_controls(1)
	elif rotation_mode == rotation_modes.RIGHT:
		player.rotation_degrees += 90
		player.controls.rotate_controls(2)


func _on_BlockRed_area_entered(area: Area2D):
	if area.is_in_group("Player") and !triggered:
		spin_level(area)
		triggered = true

