extends Node2D

onready var tiles = $Tiles
onready var player_tile = $PlayerTile


func _ready():
	tiles.setup_tiles()
	player_tile.setup_player()
	get_parent().current_level = self


func delete_tilemaps():
	tiles.queue_free()
	player_tile.queue_free()

