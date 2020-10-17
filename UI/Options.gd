extends Control

var options_shown : bool = false

onready var anim_player = $AnimationPlayer


func _on_OptionsButton_pressed():
	if !options_shown:
		var opening : bool = false
		if !opening:
			anim_player.play("show_controls")
			opening = true
			yield(anim_player, "animation_finished")
			options_shown = true
			opening = false
	else:
		var closing : bool = false
		if !closing:
			anim_player.play("hide_controls")
			closing = true
			yield(anim_player, "animation_finished")
			options_shown = false
			closing = false

