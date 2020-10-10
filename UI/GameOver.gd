extends Control


func _on_RestartButton_pressed():
	get_tree().call_group("Game", "restart_level")
	$AnimationPlayer.play("fade_out")


func _on_QuitButton_pressed():
	get_tree().quit()

