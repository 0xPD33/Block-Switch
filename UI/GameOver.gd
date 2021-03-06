extends Control

var retry_pressed : bool = false


func setup():
	show()
	$AnimationPlayer.play("fade_in")
	AudioManager.create_game_over_sound()


func _on_RetryButton_pressed():
	if !retry_pressed:
		retry_pressed = true
		AudioManager.create_interface_click_sound()
		$AnimationPlayer.play("fade_out")
		AudioManager.create_game_retry_sound()
		get_tree().call_group("Game", "restart_level")
		yield($AnimationPlayer, "animation_finished")
		Global.game_over = false
		get_tree().call_group("CurrentLevel", "reset_timer")
		retry_pressed = false


func _on_QuitButton_pressed():
	AudioManager.create_interface_click_sound()
	Global.game_over = false
	get_tree().change_scene("res://UI/LevelSelector.tscn")

