extends "res://Blocks/Block.gd"

var locked_block_pos : Vector2 setget set_locked_block_pos
var triggered : bool = false setget set_triggered


func set_triggered(value):
	triggered = value


func set_locked_block_pos(value):
	locked_block_pos = value


func _ready():
	if get_tree().current_scene.name == "LevelEditor":
		editor_mode = true


func unlock_block():
	if !triggered:
		set_triggered(true)


func _on_BlockPurple_area_entered(area: Area2D):
	if area.is_in_group("Player"):
		unlock_block()

