extends Control

export (String, FILE) var interface_click_sound = "res://Assets/SFX/interface_click.wav"

onready var done_label = $VBoxContainer/DoneLabel
onready var time_value_label = $VBoxContainer/TimeValueLabel
onready var rating_label = $VBoxContainer/RatingLabel
onready var anim_player = $AnimationPlayer

var continue_pressed : bool = false
var retry_pressed : bool = false


func setup(time, rating):
	done_label.text = "Level " + str(Global.current_level_number) + " done!"
	time_value_label.text = time
	rating_label.text = rating
	show()
	anim_player.play("fade_in")


func _on_ContinueButton_pressed():
	if !continue_pressed:
		continue_pressed = true
		AudioManager.create_audio(interface_click_sound, 0.9, 1.1)
		$AnimationPlayer.play("fade_out")
		get_tree().call_group("Game", "change_level")
		yield($AnimationPlayer, "animation_finished")
		Global.level_done = false
		get_tree().call_group("CurrentLevel", "reset_timer")
		continue_pressed = false


func _on_RetryButton_pressed():
	if !retry_pressed:
		retry_pressed = true
		AudioManager.create_audio(interface_click_sound, 0.9, 1.1)
		$AnimationPlayer.play("fade_out")
		get_tree().call_group("Game", "restart_level")
		yield($AnimationPlayer, "animation_finished")
		Global.level_done = false
		get_tree().call_group("CurrentLevel", "reset_timer")
		retry_pressed = false


func _on_QuitButton_pressed():
	AudioManager.create_audio(interface_click_sound, 0.9, 1.1)
	Global.level_done = false
	get_tree().change_scene("res://UI/LevelSelector.tscn")

