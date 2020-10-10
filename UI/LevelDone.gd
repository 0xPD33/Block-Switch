extends Control

onready var time_label = $VBoxContainer/TimeLabel


func _on_ContinueButton_pressed():
	get_tree().call_group("Game", "change_level")
	$AnimationPlayer.play("fade_out")


func _on_QuitButton_pressed():
	get_tree().quit()

