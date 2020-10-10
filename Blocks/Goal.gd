extends Area2D

var tile_size = 64


func _ready():
	snap()


func snap():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2


func _on_Goal_area_entered(area: Area2D):
	get_tree().call_group("Game", "level_done")

