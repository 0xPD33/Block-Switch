extends Area2D

var tile_size = 64


func _ready():
	snap()


func snap():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2

