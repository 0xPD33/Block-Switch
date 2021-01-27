extends TileMap

export (PackedScene) var gem_blue
export (PackedScene) var gem_yellow


func setup_gems():
	var gem_cells = get_used_cells()
	for cell in gem_cells:
		var index = get_cell(cell.x, cell.y)
		var tile_name = tile_set.tile_get_name(index)
		match tile_name:
			"GemBlue":
				create_gem_from_tilemap(cell, gem_blue)
			"GemYellow":
				create_gem_from_tilemap(cell, gem_yellow)


func create_gem_from_tilemap(coordinates: Vector2, prefab: PackedScene):
	if !get_parent().in_editor:
		set_cellv(coordinates, -1)
	var pf = prefab.instance()
	pf.global_position = to_global(map_to_world(coordinates))
	get_parent().get_node("PlacedDecoration").add_child(pf)

