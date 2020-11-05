extends Control

var shown = false

onready var anim_player = $AnimationPlayer


func fade_in():
	if !shown:
		anim_player.play("fade_in")
		yield(anim_player, "animation_finished")
		shown = true


func fade_out():
	if shown:
		anim_player.play("fade_out")
		yield(anim_player, "animation_finished")
		shown = false

