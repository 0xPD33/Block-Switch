extends "res://Blocks/Block.gd"

enum rotation_modes {LEFT, RIGHT}
var rotation_mode

var triggered = false

# LEVEL EDITOR VARIABLES

var editor_mode = false

#


func _ready():
	if get_tree().current_scene.name == "LevelEditor":
		editor_mode = true


func spin_level(player):
	pass
#	var player_pos = player.position
#	get_parent().rotation_degrees += 90
#	player.position = player_pos
#	player.rotation_degrees += 90


func _on_BlockRed_area_entered(area: Area2D):
	if area.is_in_group("Player"):
		spin_level(area)

