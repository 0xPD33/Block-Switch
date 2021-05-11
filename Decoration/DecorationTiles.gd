extends TileMap

export (PackedScene) var gem_blue
export (PackedScene) var gem_yellow
export (PackedScene) var block_lock


func setup_deco():
	var deco_cells = get_used_cells()
	for cell in deco_cells:
		var index = get_cell(cell.x, cell.y)
		var tile_name = tile_set.tile_get_name(index)
		match tile_name:
			"GemBlue":
				create_deco_from_tilemap(cell, gem_blue)
			"GemYellow":
				create_deco_from_tilemap(cell, gem_yellow)
			"BlockLock":
				create_deco_from_tilemap(cell, block_lock)


func create_deco_from_tilemap(coordinates: Vector2, prefab: PackedScene):
	if !get_parent().in_editor:
		set_cellv(coordinates, -1)
	var pf = prefab.instance()
	pf.global_position = to_global(map_to_world(coordinates))
	get_parent().get_node("PlacedDecoration").add_child(pf)

