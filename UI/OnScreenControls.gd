extends Node2D

var moving = false

var repositioning = false setget set_repositioning
var resizing = false setget set_resizing

onready var anim_player = $AnimationPlayer


func set_repositioning(value):
	repositioning = value
	highlight_controls(value)


func set_resizing(value):
	resizing = value
	highlight_controls(value)


func _ready():
	check_saved_position()
	check_saved_size()


func _input(event):
	if repositioning:
		if event is InputEventScreenDrag:
			position += event.relative 
	if resizing:
		if event is InputEventScreenDrag:
			scale += event.relative / 50


func rotate_controls(direction : int):
	match direction:
		1:
			position.x = 381
			position.y = 110
			rotation_degrees = 90
		2:
			position.x = 320
			position.y = 171
			rotation_degrees = -90


func reset_control_rotation():
	position.x = 320
	position.y = 110
	rotation_degrees = 0


func fade_in():
	set_visible(true)
	anim_player.play("fade_in")


func fade_out():
	anim_player.play("fade_out")
	yield(anim_player, "animation_finished")
	set_visible(false)


func highlight_controls(changing_controls : bool):
	for child in get_children():
		if child is TouchScreenButton:
			if changing_controls:
				child.modulate = Color(2, 2, 2)
			else:
				child.modulate = Color(1, 1, 1)


func check_saved_position():
	if GlobalOptions.get_controls_position() == null:
		GlobalOptions.set_controls_position(position)
	else:
		position = GlobalOptions.get_controls_position()


func check_saved_size():
	if GlobalOptions.get_controls_size() == null:
		GlobalOptions.set_controls_size(scale)
	else:
		scale = GlobalOptions.get_controls_size()


func save_position():
	GlobalOptions.set_controls_position(position)


func reset_position():
	position = GlobalOptions.get_controls_position()


func save_size():
	GlobalOptions.set_controls_size(scale)


func reset_size():
	scale = GlobalOptions.get_controls_size()


func _on_UpButton_pressed():
	if !moving and !repositioning and !resizing:
		moving = true
		Input.action_press("move_up")


func _on_UpButton_released():
	if moving and !repositioning and !resizing:
		Input.action_release("move_up")
		moving = false


func _on_DownButton_pressed():
	if !moving and !repositioning and !resizing:
		moving = true
		Input.action_press("move_down")


func _on_DownButton_released():
	if moving and !repositioning and !resizing:
		Input.action_release("move_down")
		moving = false


func _on_LeftButton_pressed():
	if !moving and !repositioning and !resizing:
		moving = true
		Input.action_press("move_left")


func _on_LeftButton_released():
	if moving and !repositioning and !resizing:
		Input.action_release("move_left")
		moving = false


func _on_RightButton_pressed():
	if !moving and !repositioning and !resizing:
		moving = true
		Input.action_press("move_right")


func _on_RightButton_released():
	if moving and !repositioning and !resizing:
		Input.action_release("move_right")
		moving = false

