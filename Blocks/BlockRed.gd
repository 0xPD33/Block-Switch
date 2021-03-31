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
		get_parent().rotation_degrees -= 90
	elif rotation_mode == rotation_modes.RIGHT:
		get_parent().rotation_degrees += 90
	player.position = player_pos 


func _on_BlockRed_area_entered(area: Area2D):
	if area.is_in_group("Player"):
		spin_level(area)

