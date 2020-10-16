extends Control

onready var done_label = $VBoxContainer/DoneLabel
onready var time_label = $VBoxContainer/TimeLabel
onready var rating_label = $VBoxContainer/RatingLabel


func _on_ContinueButton_pressed():
	$AnimationPlayer.play("fade_out")
	get_tree().call_group("Game", "change_level")


func _on_RetryButton_pressed():
	$AnimationPlayer.play("fade_out")
	get_tree().call_group("Game", "restart_level")


func _on_QuitButton_pressed():
	get_tree().quit()

