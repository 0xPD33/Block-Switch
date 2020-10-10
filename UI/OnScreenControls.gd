extends Node2D

var moving = false


func _on_UpButton_pressed():
	if !moving:
		moving = true
		Input.action_press("move_up")


func _on_UpButton_released():
	if moving:
		Input.action_release("move_up")
		moving = false


func _on_DownButton_pressed():
	if !moving:
		moving = true
		Input.action_press("move_down")


func _on_DownButton_released():
	if moving:
		Input.action_release("move_down")
		moving = false


func _on_LeftButton_pressed():
	if !moving:
		moving = true
		Input.action_press("move_left")


func _on_LeftButton_released():
	if moving:
		Input.action_release("move_left")
		moving = false


func _on_RightButton_pressed():
	if !moving:
		moving = true
		Input.action_press("move_right")


func _on_RightButton_released():
	if moving:
		Input.action_release("move_right")
		moving = false

