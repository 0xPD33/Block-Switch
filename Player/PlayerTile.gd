extends TileMap

var setup_done = false

export (PackedScene) var player


func setup_player():
	var player_cell = get_used_cells()
	for cell in player_cell:
		var index = get_cell(cell.x, cell.y)
		var tile_name = tile_set.tile_get_name(index)
		match tile_name:
			"Player":
				create_player_from_tilemap(cell, player, get_parent())


func create_player_from_tilemap(coordinates: Vector2, prefab: PackedScene, parent: Node2D):
	var coord_x = int(coordinates.x)
	var coord_y = int(coordinates.y)
	set_cell(coord_x, coord_y, -1)
	var pf = prefab.instance()
	pf.position = map_to_world(coordinates)
	parent.add_child(pf)
	setup_done = true

