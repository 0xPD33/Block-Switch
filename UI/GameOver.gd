extends Control


func _on_RestartButton_pressed():
	$AnimationPlayer.play("fade_out")
	get_tree().call_group("Game", "restart_level")


func _on_QuitButton_pressed():
	get_tree().quit()

