extends GridContainer

var level_selector = null
var level_numbers := []

var locked_color = Color(0.7, 0.65, 0.65, 1)
var unlocked_color = Color(1, 1, 1, 1)


func count_levels():
	var dir = Directory.new()
	dir.open("res://Levels/")
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.begins_with("Level") and file.ends_with(".tscn"):
			level_numbers.append(file.to_int())
	
	dir.list_dir_end()
	level_numbers.sort_custom(Helper, "custom_sort")
	
	while level_numbers.front() == 0:
		level_numbers.pop_front()
		if level_numbers.front() != 0:
			break


func populate_grid():
	count_levels()
	for num in level_numbers:
		var level_button = Button.new()
		level_button.text = str(num)
		level_button.name = "LevelButton" + str(num)
		level_button.connect("pressed", self, "_on_level_button_pressed", [num])
		add_child(level_button)
		level_button.add_to_group("LevelButton")
		level_button.modulate = locked_color
		if num in Global.levels_unlocked:
			if Global.levels_unlocked[num - 1] == num:
				level_button.modulate = unlocked_color


func check_lock():
	if Global.current_level_number in Global.levels_unlocked:
		level_selector.level_locked = false
	else:
		level_selector.level_locked = true


func _on_level_button_pressed(num):
	Global.current_level_number = num
	check_lock()
	level_selector.level_selected = true
	level_selector.update_buttons()
	level_selector.update_panel()

