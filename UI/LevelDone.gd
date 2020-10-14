extends Control

onready var done_label = $VBoxContainer/DoneLabel
onready var time_label = $VBoxContainer/TimeLabel
onready var rating_label = $VBoxContainer/RatingLabel


func _on_ContinueButton_pressed():
	get_tree().call_group("Game", "change_level")
	$AnimationPlayer.play("fade_out")


func _on_RetryButton_pressed():
	get_tree().call_group("Game", "restart_level")
	$AnimationPlayer.play("fade_out")


func _on_QuitButton_pressed():
	get_tree().quit()

