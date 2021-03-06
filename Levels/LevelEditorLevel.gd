extends Node2D

var level


func setup_level():
	level = get_child(0)
	level.in_editor = true
	level.tiles.setup_tiles()
	level.player_tile.setup_player()
	level.decoration.setup_gems()


func destroy_placed_tiles():
	for placed_tile in level.get_node("PlacedTiles").get_children():
		placed_tile.queue_free()
	for placed_decoration in level.get_node("PlacedDecoration").get_children():
		placed_decoration.queue_free()
	for placed_player in level.get_node("PlacedPlayer").get_children():
		placed_player.queue_free()
