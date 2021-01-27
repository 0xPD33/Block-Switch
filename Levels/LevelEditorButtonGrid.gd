extends GridContainer

var level_editor_panel = null

onready var goal_button = $GoalButton
onready var player_button = $PlayerButton


func connect_buttons():
	for button in get_children():
		button.name = button.name.trim_suffix("Button")
		button.connect("pressed", level_editor_panel, "_on_button_pressed", [button.name, button.texture_normal, button.modulate])


func enable_all_buttons():
	for button in get_children():
		button.disabled = false


func disable_all_buttons():
	for button in get_children():
		button.disabled = true

