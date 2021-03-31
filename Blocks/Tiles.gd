class_name MyTileMap
extends TileMap

export (Dictionary) var yellow_blocks := {}
export (Dictionary) var blue_blocks := {}
export (Dictionary) var red_blocks := {}

export (PackedScene) var block_scene
export (PackedScene) var block_yellow_scene
export (PackedScene) var block_blue_scene
export (PackedScene) var block_red_scene
export (PackedScene) var goal_scene
export (PackedScene) var void_scene

const BLOCK_ID = 0
const BLOCK_YELLOW_ID = 1
const BLOCK_BLUE_ID = 4
const BLOCK_RED_ID = 5
const GOAL_ID = 2
const VOID_ID = 3


func setup_tiles():
	var cells = get_used_cells()
	for cell in cells:
		var index = get_cellv(cell)
		var tile_name = tile_set.tile_get_name(index)
		match tile_name:
			"Block":
				create_instance_from_tilemap(cell, block_scene)
			"Goal":
				create_instance_from_tilemap(cell, goal_scene)
			"Void":
				create_instance_from_tilemap(cell, void_scene)
	create_yellow_blocks()
	create_blue_blocks()
	create_red_blocks()
	if !get_parent().in_editor:
		get_parent().delete_tilemaps()


func create_instance_from_tilemap(coordinates: Vector2, prefab: PackedScene):
	if !get_parent().in_editor:
		set_cellv(coordinates, -1)
	var pf = prefab.instance()
	pf.global_position = to_global(map_to_world(coordinates))
	get_parent().get_node("PlacedTiles").add_child(pf)


func create_yellow_blocks():
	var yellow_blocks_placed = 0
	for key in yellow_blocks.keys():
		if !get_parent().in_editor:
			set_cellv(key, -1)
		var yellow_block_instance = block_yellow_scene.instance()
		yellow_block_instance.global_position = to_global(map_to_world(key))
		yellow_block_instance.missing_block_pos = map_to_world(yellow_blocks.values()[yellow_blocks_placed])
		get_parent().get_node("PlacedTiles").add_child(yellow_block_instance)
		yellow_blocks_placed += 1


func create_blue_blocks():
	var blue_blocks_placed = 0
	for key in blue_blocks.keys():
		if !get_parent().in_editor:
			set_cellv(key, -1)
		var blue_block_instance = block_blue_scene.instance()
		blue_block_instance.global_position = to_global(map_to_world(key))
		blue_block_instance.teleport_pos = map_to_world(blue_blocks.values()[blue_blocks_placed])
		get_parent().get_node("PlacedTiles").add_child(blue_block_instance)
		blue_blocks_placed += 1


func create_red_blocks():
	var red_blocks_placed = 0
	for key in red_blocks.keys():
		if !get_parent().in_editor:
			set_cellv(key, -1)
		var red_block_instance = block_red_scene.instance()
		red_block_instance.global_position = to_global(map_to_world(key))
		red_block_instance.rotation_mode = red_blocks.values()[red_blocks_placed]
		get_parent().get_node("PlacedTiles").add_child(red_block_instance)
		red_blocks_placed += 1

