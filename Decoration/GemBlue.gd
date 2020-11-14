extends Node2D

var tile_size = 64

onready var anim_player = $AnimationPlayer


func _ready():
	snap()
	spin_and_glow()


func snap():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2


func spin_and_glow():
	anim_player.play("spin_and_glow")

