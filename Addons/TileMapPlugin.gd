tool
extends EditorPlugin

var tileMap: MyTileMap = null

var selectedCoords = null
var lineWidth := 3.0
var antialiased := true
var hoveredColor := Color.yellow
var selectedColor := Color.green


func handles(object: Object) -> bool:
	tileMap = object as MyTileMap
	return tileMap != null


func forward_canvas_gui_input(event: InputEvent) -> bool:
	if not tileMap or not tileMap.is_inside_tree():
		return false
	
	if event is InputEventMouse:
		var coords = tileMap.world_to_map(tileMap.get_local_mouse_position())
		var cell = tileMap.get_cellv(coords)
		
		if cell == MyTileMap.BLOCK_YELLOW_ID:
			if not tileMap.yellow_blocks.has(coords):
				tileMap.yellow_blocks[coords] = Vector2.ZERO
				get_editor_interface().get_inspector().refresh()
		else:
			if tileMap.yellow_blocks.has(coords):
				tileMap.yellow_blocks.erase(coords)
				get_editor_interface().get_inspector().refresh()
				
				if selectedCoords == coords:
					selectedCoords = null
		update_overlays()
	
	elif event is InputEventKey:
		if event.control and event.pressed:
			match event.scancode:
				KEY_QUOTELEFT:
					selectedCoords = null
					update_overlays()
				KEY_1:
					var coords = tileMap.world_to_map(tileMap.get_local_mouse_position())
					if tileMap.yellow_blocks.has(coords):
						selectedCoords = coords
						update_overlays()
				KEY_2:
					if selectedCoords != null:
						tileMap.yellow_blocks[selectedCoords] = tileMap.world_to_map(tileMap.get_local_mouse_position())
						get_editor_interface().get_inspector().refresh()
						update_overlays()
	
	return false


func forward_canvas_draw_over_viewport(overlay: Control) -> void:
	if not tileMap or not tileMap.is_inside_tree():
		return
	
	var tileMapToOverlayTransform = getLocalToScreenTransform(overlay).affine_inverse() * getLocalToScreenTransform(tileMap)
	
	var coords = tileMap.world_to_map(tileMap.get_local_mouse_position())
	if tileMap.yellow_blocks.has(coords):
		var cellCenterPosition = tileMap.map_to_world(coords) + 0.5 * tileMap.cell_size
		var targetCellCenterPosition = tileMap.map_to_world(tileMap.yellow_blocks[coords]) + 0.5 * tileMap.cell_size
		overlay.draw_line(tileMapToOverlayTransform * cellCenterPosition, tileMapToOverlayTransform * targetCellCenterPosition, hoveredColor, lineWidth, antialiased)
	
	if selectedCoords != null:
		var cellRect := Rect2(tileMap.map_to_world(selectedCoords), tileMap.cell_size)
		overlay.draw_rect(tileMapToOverlayTransform.xform(cellRect), selectedColor, false, lineWidth, antialiased)
		
		var cellCenterPosition = tileMap.map_to_world(selectedCoords) + 0.5 * tileMap.cell_size
		var targetCellCenterPosition = tileMap.map_to_world(tileMap.yellow_blocks[selectedCoords]) + 0.5 * tileMap.cell_size
		overlay.draw_line(tileMapToOverlayTransform * cellCenterPosition, tileMapToOverlayTransform * targetCellCenterPosition, selectedColor, lineWidth, antialiased)


func getLocalToScreenTransform(ci: CanvasItem) -> Transform2D:
	var screenTransform = ci.get_viewport_transform() * ci.get_global_transform()
	var vc := ci.get_viewport().get_parent() as ViewportContainer
	while vc:
		screenTransform = vc.get_viewport_transform() * vc.get_global_transform() * screenTransform
		vc = vc.get_viewport().get_parent() as ViewportContainer
	return screenTransform

