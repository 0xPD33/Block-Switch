extends "res://Blocks/Block.gd"

var teleport_pos setget set_teleport_pos
var triggered = false setget set_triggered

# LEVEL EDITOR VARIABLES

var editor_mode = false

#


func set_triggered(value):
	triggered = value


func set_teleport_pos(value):
	teleport_pos = value


func _ready():
	if get_tree().current_scene.name == "LevelEditor":
		editor_mode = true


func teleport(player):
	if !triggered:
		if !editor_mode:
			set_triggered(true)
		player.global_position = teleport_pos
		player.snap()
		AudioManager.create_teleport_sound()


func _on_BlockBlue_area_entered(area: Area2D):
	if area.is_in_group("Player"):
		teleport(area)

