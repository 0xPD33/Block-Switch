extends Area2D

var tile_size = 64


func _ready():
	snap()


func snap():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2


func _on_Void_area_entered(area: Area2D):
	if area.is_in_group("Player"):
		area.die()
	elif area.is_in_group("Block"):
		queue_free()

