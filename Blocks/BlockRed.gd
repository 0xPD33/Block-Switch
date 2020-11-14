extends Area2D

var tile_size = 64
var triggered = false


func _ready():
	snap()


func spin_level():
	get_parent().rotation_degrees = 90


func snap():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2


func _on_BlockRed_area_entered(area: Area2D):
	if area.is_in_group("Player"):
		spin_level()

