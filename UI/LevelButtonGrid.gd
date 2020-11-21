extends GridContainer

var level_selector = null
var level_numbers := []


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
	level_numbers.sort_custom(self, "custom_sort")
	
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
		if !Global.levels_unlocked.has(num):
			level_button.disabled = true


func custom_sort(a, b):
	if typeof(a) != typeof(b):
		return typeof(a) < typeof(b)
	else:
		return a < b


func _on_level_button_pressed(num):
	Global.current_level_number = num
	level_selector.level_selected = true
	level_selector.update_panel()
	level_selector.update_buttons()

