extends Node2D

var tile_size = 64

onready var anim_player = $AnimationPlayer

# LEVEL EDITOR VARIABLES

var editor_mode = false

#


func _ready():
	if get_tree().current_scene.name == "LevelEditor":
		editor_mode = true
	snap()
	
	
func snap():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2


func lock_area(action_block : Area2D):
	action_block.set_triggered(true)
	action_block.lock = self


func _on_HitArea_area_entered(area: Area2D):
	if area.is_in_group("ActionBlock") and !area.is_in_group("BlockPurple"):
		lock_area(area)

