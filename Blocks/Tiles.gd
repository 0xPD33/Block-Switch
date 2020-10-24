extends TileMap

export (PackedScene) var block_scene

export (PackedScene) var block_yellow_scene
export (Array, Vector2) var block_yellow_coordinates

export (PackedScene) var goal_scene
export (PackedScene) var void_scene

var setup_done = false


func _ready():
	call_deferred("setup_tiles")


func setup_tiles():
	var cells = get_used_cells()
	for cell in cells:
		var index = get_cell(cell.x, cell.y)
		var tile_name = tile_set.tile_get_name(index)
		match tile_name:
			"Block":
				create_instance_from_tilemap(tile_name, cell, block_scene, get_parent())
			"BlockYellow":
				create_instance_from_tilemap(tile_name, cell, block_yellow_scene, get_parent())
			"Goal":
				create_instance_from_tilemap(tile_name, cell, goal_scene, get_parent())
			"Void":
				create_instance_from_tilemap(tile_name, cell, void_scene, get_parent())


func create_instance_from_tilemap(type: String, coordinates: Vector2, prefab: PackedScene, parent: Node2D):
	var coord_x = int(coordinates.x)
	var coord_y = int(coordinates.y)
	set_cell(coord_x, coord_y, -1)
	var pf = prefab.instance()
	pf.position = map_to_world(coordinates)
	
	# if type of instance is the yellow block
	if type == "BlockYellow":
		pf.missing_block_pos = map_to_world(block_yellow_coordinates.front())
		block_yellow_coordinates.pop_front()
	
	parent.add_child(pf)
	setup_done = true

