extends "res://Blocks/Block.gd"

var player

var triggered = false

# LEVEL EDITOR VARIABLES

var editor_mode = false

#


func _ready():
	if get_tree().current_scene.name == "LevelEditor":
		editor_mode = true


func spin_level():
	player = get_parent().get_parent().get_node("PlacedPlayer").get_child(0)
	var player_pos = player.position
	get_parent().rotation_degrees += 90
	player.position = player_pos
	player.rotation_degrees += 90


func _on_BlockRed_area_entered(area: Area2D):
	if area.is_in_group("Player"):
		spin_level()

