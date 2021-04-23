extends Node2D

var current_block_selected
var current_coordinates : Vector2

var can_place : bool = false
var can_delete : bool = false
var can_drag : bool = false
var drag_events := {}

var saved_block_id

var placing_yellow_block : bool = false
var yellow_block_coordinates : Vector2
var last_missing_block_position : Vector2
var missing_block_placed : bool = false

var placing_blue_block : bool = false
var blue_block_coordinates : Vector2
var last_teleport_target_position : Vector2
var teleport_target_placed : bool = false

var placing_red_block : bool = false
var red_block_coordinates : Vector2

var last_goal_position
var last_player_position

var delete_level_triggered : bool = false

var goal_placed : bool = false
var player_placed : bool = false

var testing_level : bool = false
var level_tested : bool = false

var is_playable : bool = false

onready var level_editor_grid = $Grid/ParallaxLayer/LevelEditorGrid

onready var level_editor_camera_container = $LevelEditorCameraContainer
onready var level_editor_camera = level_editor_camera_container.get_node("LevelEditorCamera")

onready var level_editor_level = $LevelEditorLevel

onready var level_editor_level_saver = $LevelEditorLevelSaver
onready var level_editor_level_saver_confirmation = $UI/LevelEditorLevelSaverConfirmation

onready var level_editor_level_loader = $LevelEditorLevelLoader
onready var level_editor_level_load_dialog = $UI/LevelEditorLevelLoadDialog

onready var level_editor_panel = $UI/LevelEditorPanel
onready var level_editor_selected_block = level_editor_panel.get_node("LevelEditorSelectedBlock")
onready var level_editor_button_grid = level_editor_panel.get_node("BigPanel/MarginContainer/LevelEditorButtonGrid")
onready var level_editor_place_confirmation = $UI/LevelEditorPlaceConfirmation
onready var level_editor_choice_place_confirmation = $UI/LevelEditorChoicePlaceConfirmation
onready var level_editor_options_panel = $UI/LevelEditorOptionsPanel

onready var tiles = $LevelEditorLevel/LevelTemplate/Tiles
onready var decoration = $LevelEditorLevel/LevelTemplate/Decoration
onready var player_tile = $LevelEditorLevel/LevelTemplate/PlayerTile

onready var block_scene = tiles.block_scene
onready var block_yellow_scene = tiles.block_yellow_scene
onready var block_blue_scene = tiles.block_blue_scene
onready var block_red_scene = tiles.block_red_scene
onready var goal_scene = tiles.goal_scene
onready var void_scene = tiles.void_scene


func _check_if_placement_is_allowed():
	if current_block_selected != null and !level_editor_camera_container.move_enabled and !can_delete and !placing_yellow_block and !placing_blue_block and !placing_red_block and !testing_level:
		can_place = true
	else:
		can_place = false


func _check_if_dragging_is_allowed():
	if current_block_selected in [block_scene, void_scene] or current_block_selected == null:
		can_drag = true
	else:
		can_drag = false


func _check_if_testable():
	if goal_placed and player_placed and !placing_yellow_block and !placing_blue_block and !placing_red_block:
		level_editor_options_panel.change_testable(true)
	else:
		level_editor_options_panel.change_testable(false)
		if level_tested:
			level_tested = false


func _check_if_playable():
	if level_tested:
		is_playable = true
		level_editor_options_panel.change_playable_requirement_text(is_playable)
		level_editor_options_panel.change_saveable(true)
	else:
		is_playable = false
		level_editor_options_panel.change_playable_requirement_text(is_playable)
		level_editor_options_panel.change_saveable(false)


func _check_if_placeable(pos : Vector2):
	match current_block_selected:
		block_scene:
			if !tiles.get_cellv(pos) in [tiles.BLOCK_YELLOW_ID, tiles.BLOCK_BLUE_ID, tiles.BLOCK_RED_ID, tiles.GOAL_ID]\
			and _check_if_decoration_placed(pos) == false:
				return true
			else:
				return false
		block_yellow_scene, block_blue_scene, block_red_scene, goal_scene, void_scene:
			if !tiles.get_cellv(pos) in [tiles.BLOCK_YELLOW_ID, tiles.BLOCK_BLUE_ID, tiles.BLOCK_RED_ID, tiles.GOAL_ID]\
			and !player_tile.get_cellv(pos) == 0 and _check_if_decoration_placed(pos) == false:
				return true
			else:
				return false
		player_tile.player:
			if tiles.get_cellv(pos) == tiles.BLOCK_ID:
				return true
			else:
				return false


func _check_if_not_goal_and_not_player(pos : Vector2):
	if tiles.get_cellv(pos) != tiles.GOAL_ID and player_tile.get_cellv(pos) != 0:
		return true 
	else:
		return false


func _check_if_decoration_placed(pos : Vector2):
	if decoration.get_cellv(pos) != -1:
		return true
	else:
		return false


func _check_if_tile_empty(pos : Vector2):
	if tiles.get_cellv(pos) == -1 and decoration.get_cellv(pos) == -1:
		return true
	else:
		return false


func _process(delta):
	_check_if_placement_is_allowed()


func _unhandled_input(event):
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
	if can_place:
		if event is InputEventScreenTouch:
			if event.pressed:
				var block_position : Vector2 = tiles.world_to_map(to_global(event.position * level_editor_camera.zoom.x + level_editor_camera_container.global_position))
				if current_block_selected == goal_scene:
					if !goal_placed:
						save_block_information(block_position)
						place_block(block_position)
					else:
						place_last_block()
						save_block_information(block_position)
						place_block(block_position)
				else:
					place_block(block_position)
		if event is InputEventScreenDrag:
			_check_if_dragging_is_allowed()
			if can_drag:
				drag_events[event.index] = event
				if drag_events.size() == 1:
					var block_position : Vector2 = tiles.world_to_map(to_global(event.position * level_editor_camera.zoom.x + level_editor_camera_container.global_position))
					place_block(block_position)
	if can_delete:
		if event is InputEventScreenTouch:
			if event.pressed:
				var block_position : Vector2 = tiles.world_to_map(to_global(event.position * level_editor_camera.zoom.x + level_editor_camera_container.global_position))
				delete_block(block_position)
		if event is InputEventScreenDrag:
			drag_events[event.index] = event
			if drag_events.size() == 1:
				var block_position : Vector2 = tiles.world_to_map(to_global(event.position * level_editor_camera.zoom.x + level_editor_camera_container.global_position))
				delete_block(block_position)
	if placing_yellow_block:
		if event is InputEventScreenTouch:
			if event.pressed and !missing_block_placed:
				var missing_block_position : Vector2 = tiles.world_to_map(to_global(event.position * level_editor_camera.zoom.x + level_editor_camera_container.global_position))
				tiles.yellow_blocks[yellow_block_coordinates] = missing_block_position
				if tiles.get_cellv(missing_block_position) != tiles.BLOCK_YELLOW_ID and _check_if_not_goal_and_not_player(missing_block_position) == true:
					save_block_information(missing_block_position)
					place_missing_block(missing_block_position)
			elif event.pressed and missing_block_placed:
				var missing_block_position : Vector2 = tiles.world_to_map(to_global(event.position * level_editor_camera.zoom.x + level_editor_camera_container.global_position))
				tiles.yellow_blocks[yellow_block_coordinates] = missing_block_position
				if tiles.get_cellv(missing_block_position) != tiles.BLOCK_YELLOW_ID and _check_if_not_goal_and_not_player(missing_block_position) == true:
					place_last_block()
					save_block_information(missing_block_position)
					place_missing_block(missing_block_position)
	if placing_blue_block:
		if event is InputEventScreenTouch:
			if event.pressed and !teleport_target_placed:
				var teleport_target_position : Vector2 = tiles.world_to_map(to_global(event.position * level_editor_camera.zoom.x + level_editor_camera_container.global_position))
				tiles.blue_blocks[blue_block_coordinates] = teleport_target_position
				if tiles.get_cellv(teleport_target_position) != tiles.BLOCK_BLUE_ID and _check_if_not_goal_and_not_player(teleport_target_position) == true:
					save_block_information(teleport_target_position)
					place_teleport_target(teleport_target_position)
			elif event.pressed and teleport_target_placed:
				var teleport_target_position : Vector2 = tiles.world_to_map(to_global(event.position * level_editor_camera.zoom.x + level_editor_camera_container.global_position))
				tiles.blue_blocks[blue_block_coordinates] = teleport_target_position
				if tiles.get_cellv(teleport_target_position) != tiles.BLOCK_BLUE_ID and _check_if_not_goal_and_not_player(teleport_target_position) == true:
					place_last_block()
					save_block_information(teleport_target_position)
					place_teleport_target(teleport_target_position)


func select_block(block_name : String):
	match block_name:
		"Block":
			current_block_selected = block_scene
		"BlockYellow":
			current_block_selected = block_yellow_scene
		"BlockBlue":
			current_block_selected = block_blue_scene
		"BlockRed":
			current_block_selected = block_red_scene
		"Goal":
			current_block_selected = goal_scene
		"Void":
			current_block_selected = void_scene
		"Player":
			current_block_selected = player_tile.player


func create_audio(block_selected, block_position : Vector2):
	match block_selected:
		block_scene:
			if _check_if_tile_empty(block_position) == true or tiles.get_cellv(block_position) == tiles.VOID_ID:
				AudioManager.create_place_block_sound()
		block_yellow_scene, block_blue_scene, block_red_scene, goal_scene:
			if _check_if_tile_empty(block_position) == true or tiles.get_cellv(block_position) in [tiles.VOID_ID, tiles.BLOCK_ID]:
				AudioManager.create_place_block_sound()
		void_scene:
			if _check_if_tile_empty(block_position) == true or tiles.get_cellv(block_position) == tiles.BLOCK_ID:
				AudioManager.create_place_block_sound()
		player_tile.player:
			if tiles.get_cellv(block_position) == tiles.BLOCK_ID:
				AudioManager.create_place_block_sound()
		null:
			AudioManager.create_delete_block_sound()
	

func save_block_information(block_position : Vector2):
	saved_block_id = tiles.get_cellv(block_position)


func place_last_block():
	if placing_yellow_block:
		tiles.set_cellv(last_missing_block_position, saved_block_id)
		decoration.set_cellv(last_missing_block_position, -1)
		if tiles.yellow_blocks.has(last_missing_block_position):
			tiles.yellow_blocks.erase(last_missing_block_position)
	elif placing_blue_block:
		tiles.set_cellv(last_teleport_target_position, saved_block_id)
		decoration.set_cellv(last_teleport_target_position, -1)
		if tiles.blue_blocks.has(last_teleport_target_position):
			tiles.blue_blocks.erase(last_teleport_target_position)
	elif current_block_selected == goal_scene:
		tiles.set_cellv(last_goal_position, saved_block_id)
		decoration.set_cellv(last_goal_position, -1)


func place_block(block_position : Vector2):
	create_audio(current_block_selected, block_position)
	match current_block_selected:
		block_scene:
			if _check_if_placeable(block_position) == true:
				tiles.set_cellv(block_position, tiles.BLOCK_ID)
				if !placing_blue_block:
					place_void_around_block(block_position)
		block_yellow_scene:
			if _check_if_placeable(block_position) == true:
				tiles.set_cellv(block_position, tiles.BLOCK_YELLOW_ID)
				yellow_block_coordinates = block_position
				placing_yellow_block = true
				level_editor_button_grid.disable_all_buttons()
				level_editor_panel.disable_buttons()
		block_blue_scene:
			if _check_if_placeable(block_position) == true:
				tiles.set_cellv(block_position, tiles.BLOCK_BLUE_ID)
				blue_block_coordinates = block_position
				placing_blue_block = true
				level_editor_button_grid.disable_all_buttons()
				level_editor_panel.disable_buttons()
		block_red_scene:
			if _check_if_placeable(block_position) == true:
				tiles.set_cellv(block_position, tiles.BLOCK_RED_ID)
				red_block_coordinates = block_position
				placing_red_block = true
				level_editor_choice_place_confirmation.confirmation_fade_in()
				level_editor_button_grid.disable_all_buttons()
				level_editor_panel.disable_buttons()
		goal_scene:
			if _check_if_placeable(block_position) == true:
				tiles.set_cellv(block_position, tiles.GOAL_ID)
				last_goal_position = block_position
				if !goal_placed:
					goal_placed = true
					level_editor_options_panel.change_goal_requirement_text(1)
		void_scene:
			if _check_if_placeable(block_position) == true:
				tiles.set_cellv(block_position, tiles.VOID_ID)
		player_tile.player:
			if _check_if_placeable(block_position) == true:
				if last_player_position != null:
					player_tile.set_cellv(last_player_position, -1)
				player_tile.set_cellv(block_position, 0)
				last_player_position = block_position
				if !player_placed:
					player_placed = true
					level_editor_options_panel.change_player_requirement_text(1)
	current_coordinates = block_position
	_check_if_testable()
	_check_if_playable()


func place_missing_block(missing_block_position : Vector2):
	place_decoration(missing_block_position)
	tiles.set_cellv(missing_block_position, tiles.VOID_ID)
	missing_block_placed = true
	last_missing_block_position = missing_block_position
	level_editor_place_confirmation.confirmation_fade_in()
	_check_if_testable()


func place_teleport_target(teleport_target_position : Vector2):
	place_decoration(teleport_target_position)
	tiles.set_cellv(teleport_target_position, tiles.BLOCK_ID)
	teleport_target_placed = true
	last_teleport_target_position = teleport_target_position
	level_editor_place_confirmation.confirmation_fade_in()
	_check_if_testable()


func place_decoration(decoration_position : Vector2):
	if placing_yellow_block:
		decoration.set_cellv(decoration_position, 1)
	elif placing_blue_block:
		decoration.set_cellv(decoration_position, 0)


func place_void_around_block(block_position : Vector2):
	if _check_if_tile_empty(block_position + Vector2(0, 1)) == true:
		tiles.set_cellv(block_position + Vector2(0, 1), tiles.VOID_ID)
	if _check_if_tile_empty(block_position + Vector2(0, -1)) == true:
		tiles.set_cellv(block_position + Vector2(0, -1), tiles.VOID_ID)
	if _check_if_tile_empty(block_position + Vector2(1, 0)) == true:
		tiles.set_cellv(block_position + Vector2(1, 0), tiles.VOID_ID)
	if _check_if_tile_empty(block_position + Vector2(-1, 0)) == true:
		tiles.set_cellv(block_position + Vector2(-1, 0), tiles.VOID_ID)
	if _check_if_tile_empty(block_position + Vector2(1, 1)) == true:
		tiles.set_cellv(block_position + Vector2(1, 1), tiles.VOID_ID)
	if _check_if_tile_empty(block_position + Vector2(1, -1)) == true:
		tiles.set_cellv(block_position + Vector2(1, -1), tiles.VOID_ID)
	if _check_if_tile_empty(block_position + Vector2(-1, 1)) == true:
		tiles.set_cellv(block_position + Vector2(-1, 1), tiles.VOID_ID)
	if _check_if_tile_empty(block_position + Vector2(-1, -1)) == true:
		tiles.set_cellv(block_position + Vector2(-1, -1), tiles.VOID_ID)


# kind of works but not finished
func remove_void_around_block(block_position : Vector2, solid_block_position, empty_block_position, remove_block_position):
	if !tiles.get_cellv(block_position + Vector2(solid_block_position)) == tiles.VOID_ID\
	and _check_if_tile_empty(block_position + Vector2(empty_block_position)) == false\
	and tiles.get_cellv(block_position + Vector2(remove_block_position)) == tiles.VOID_ID:
		tiles.set_cellv(block_position + Vector2(remove_block_position), -1)


func add_missing_void_blocks():
	var used_tiles = tiles.get_used_cells()
	remove_unnecessary_void_blocks(used_tiles)
	for tile in used_tiles:
		if tiles.get_cellv(tile) != tiles.VOID_ID or decoration.get_cellv(tile) == 1:
			place_void_around_block(tile)


func remove_unnecessary_void_blocks(used_tiles : Array):
	for tile in used_tiles:
		if tiles.get_cellv(tile) == tiles.VOID_ID:
			remove_void_around_block(tile, Vector2(0, 1), Vector2(0, 2), Vector2(0, -1))


func remove_block_coordinates(block_position : Vector2):
	if tiles.get_cellv(block_position) == tiles.BLOCK_YELLOW_ID:
		decoration.set_cellv(tiles.yellow_blocks[block_position], -1)
		tiles.set_cellv(tiles.yellow_blocks[block_position], -1)
		tiles.yellow_blocks.erase(block_position)
	elif tiles.get_cellv(block_position) == tiles.BLOCK_BLUE_ID:
		decoration.set_cellv(tiles.blue_blocks[block_position], -1)
		tiles.set_cellv(tiles.blue_blocks[block_position], -1)
		tiles.blue_blocks.erase(block_position)
	elif tiles.get_cellv(block_position) == tiles.BLOCK_RED_ID:
		tiles.red_blocks.erase(block_position)
	if decoration.get_cellv(block_position) == 1:
		var index = tiles.yellow_blocks.values().find(block_position)
		tiles.set_cellv(tiles.yellow_blocks.keys()[index], -1)
		tiles.yellow_blocks.erase(tiles.yellow_blocks.keys()[index])
	elif decoration.get_cellv(block_position) == 0:
		var index = tiles.blue_blocks.values().find(block_position)
		tiles.set_cellv(tiles.blue_blocks.keys()[index], -1)
		tiles.blue_blocks.erase(tiles.blue_blocks.keys()[index])


func remove_player_position():
	last_player_position = null
	player_placed = false
	level_editor_options_panel.change_player_requirement_text(0)


func delete_block(block_position : Vector2):
	remove_block_coordinates(block_position)
	if tiles.get_cellv(block_position) != -1:
		create_audio(null, block_position)
	if tiles.get_cellv(block_position) == tiles.GOAL_ID:
		goal_placed = false
		level_editor_options_panel.change_goal_requirement_text(0)
	tiles.set_cellv(block_position, -1)
	decoration.set_cellv(block_position, -1)
	if player_tile.get_cellv(block_position) == 0:
		player_tile.set_cellv(block_position, -1)
		player_placed = false
		level_editor_options_panel.change_player_requirement_text(0)
	_check_if_testable()
	_check_if_playable()


func delete_whole_level():
	if !delete_level_triggered:
		delete_level_triggered = true
		AudioManager.create_trash_audio()
		for tile in tiles.get_used_cells():
			tiles.set_cellv(tile, -1)
			decoration.set_cellv(tile, -1)
			player_tile.set_cellv(tile, -1)
		tiles.yellow_blocks.clear()
		tiles.blue_blocks.clear()
		goal_placed = false
		player_placed = false
		level_editor_options_panel.change_goal_requirement_text(0)
		level_editor_options_panel.change_player_requirement_text(0)
		_check_if_testable()
		_check_if_playable()


func hide_tiles():
	tiles.hide()
	player_tile.hide()
	decoration.hide()


func show_tiles():
	tiles.show()
	player_tile.show()
	decoration.show()


func test_level():
	if !testing_level:
		testing_level = true
		add_missing_void_blocks()
		if level_editor_panel.is_open:
			level_editor_panel.close_level_editor_panel()
		if level_editor_options_panel.is_open:
			level_editor_options_panel.close_options_panel()
		level_editor_options_panel.change_test_level_button_text()
		level_editor_grid.visible = false
		level_editor_level.setup_level()
		hide_tiles()


func stop_testing_level(goal_reached : bool):
	if testing_level:
		testing_level = false
		level_tested = goal_reached
		if !level_editor_panel.is_open:
			level_editor_panel.open_level_editor_panel()
		if !level_editor_options_panel.is_open:
			level_editor_options_panel.open_options_panel()
		level_editor_options_panel.change_test_level_button_text()
		level_editor_grid.visible = true
		level_editor_level.destroy_placed_tiles()
		level_editor_camera.current = true
		show_tiles()
		_check_if_playable()


func open_level_saver_confirmation():
	level_editor_level_saver_confirmation.open()


func save_level(level_name : String):
	level_editor_level_saver.save_level(level_name)


func open_level_load_dialog():
	level_editor_level_load_dialog.open()


func load_level(level_to_load : String):
	level_editor_level_loader.load_level(level_to_load)


func examine_loaded_level():
	for goal in tiles.get_used_cells_by_id(tiles.GOAL_ID):
		goal_placed = true
		last_goal_position = goal
		level_editor_options_panel.change_goal_requirement_text(1)
	for player in player_tile.get_used_cells_by_id(0):
		player_placed = true
		last_player_position = player
		level_editor_options_panel.change_player_requirement_text(1)
	_check_if_testable()
	

func _on_place_confirmation_placement_accepted():
	if placing_yellow_block:
		placing_yellow_block = false
		missing_block_placed = false
	elif placing_blue_block:
		placing_blue_block = false
		teleport_target_placed = false
	current_block_selected = null
	level_editor_selected_block.remove_selected_block()
	level_editor_button_grid.enable_all_buttons()
	level_editor_panel.enable_buttons()
	_check_if_testable()


func _on_choice_place_confirmation_placement_accepted(choice):
	tiles.red_blocks[red_block_coordinates] = choice
	placing_red_block = false
	current_block_selected = null
	level_editor_selected_block.remove_selected_block()
	level_editor_button_grid.enable_all_buttons()
	level_editor_panel.enable_buttons()
	_check_if_testable()

