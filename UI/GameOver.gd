extends Control

export (String, FILE) var interface_click_sound = "res://Assets/SFX/interface_click.wav"

export (String, FILE) var game_over_sound = "res://Assets/SFX/game_over.wav"
export (String, FILE) var game_retry_sound = "res://Assets/SFX/game_retry.wav"

var retry_pressed : bool = false


func setup():
	show()
	$AnimationPlayer.play("fade_in")
	get_tree().call_group("AudioManager", "create_audio", game_over_sound)


func _on_RetryButton_pressed():
	if !retry_pressed:
		retry_pressed = true
		AudioManager.create_audio(interface_click_sound, 0.9, 1.1)
		$AnimationPlayer.play("fade_out")
		get_tree().call_group("AudioManager", "create_audio", game_retry_sound)
		get_tree().call_group("Game", "restart_level")
		yield($AnimationPlayer, "animation_finished")
		Global.game_over = false
		get_tree().call_group("CurrentLevel", "reset_timer")
		retry_pressed = false


func _on_QuitButton_pressed():
	AudioManager.create_audio(interface_click_sound, 0.9, 1.1)
	Global.game_over = false
	get_tree().change_scene("res://UI/LevelSelector.tscn")

