extends Control

var options_shown : bool = false

onready var anim_player = $AnimationPlayer


func _on_OptionsButton_pressed():
	if !options_shown:
		open_controls()
	else:
		close_controls()


func open_controls():
	var opening : bool = false
	if !opening:
		anim_player.play("show_controls")
		opening = true
		yield(anim_player, "animation_finished")
		options_shown = true
		opening = false
		get_tree().paused = true


func close_controls():
	var closing : bool = false
	if !closing:
		anim_player.play("hide_controls")
		closing = true
		yield(anim_player, "animation_finished")
		options_shown = false
		closing = false
		get_tree().paused = false


func _on_MoveControlsButton_pressed():
	get_tree().call_group("Controls", "set_repositioning", true)

