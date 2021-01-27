extends Node2D

var in_editor : bool = false

onready var tiles = $Tiles
onready var player_tile = $PlayerTile
onready var decoration = $Decoration


func _ready():
	if get_tree().current_scene.name == "Game":
		tiles.setup_tiles()
		player_tile.setup_player()
		decoration.setup_gems()
		get_parent().current_level = self


func delete_tilemaps():
	tiles.queue_free()
	player_tile.queue_free()
	decoration.queue_free()

