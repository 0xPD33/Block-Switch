extends Area2D

export (Vector2) var missing_block_pos

var block_scene = preload("res://Blocks/Block.tscn")

var tile_size = 64
var triggered = false


func _ready():
	snap()


func add_block():
	if !triggered:
		triggered = true
		var block_instance = block_scene.instance()
		block_instance.position = missing_block_pos
		get_parent().call_deferred("add_child", block_instance)


func snap():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2


func _on_BlockYellow_area_entered(area: Area2D):
	if area.is_in_group("Player"):
		add_block()

