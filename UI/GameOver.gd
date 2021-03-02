extends Control

export (String, FILE) var game_over_sound = "res://Assets/SFX/game_over.wav"
export (String, FILE) var game_retry_sound = "res://Assets/SFX/game_retry.wav"


func setup():
	show()
	$AnimationPlayer.play("fade_in")
	get_tree().call_group("AudioManager", "create_audio", game_over_sound)


func _on_RetryButton_pressed():
	$AnimationPlayer.play("fade_out")
	get_tree().call_group("AudioManager", "create_audio", game_retry_sound)
	get_tree().call_group("Game", "restart_level")
	yield($AnimationPlayer, "animation_finished")
	Global.game_over = false
	get_tree().call_group("CurrentLevel", "reset_timer")


func _on_QuitButton_pressed():
	Global.game_over = false
	get_tree().change_scene("res://UI/LevelSelector.tscn")

