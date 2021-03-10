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
	spin_and_glow()


func snap():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2


func spin_and_glow():
	anim_player.play("spin_and_glow")


func disappear():
	if !editor_mode:
		anim_player.play("disappear")
		yield(anim_player, "animation_finished")
		queue_free()


func _on_HitArea_area_entered(area: Area2D):
	if area.is_in_group("Player"):
		disappear()

