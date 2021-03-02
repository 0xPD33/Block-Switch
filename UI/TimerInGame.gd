extends Control

onready var time_label = $VBoxContainer/TimeLabel


func set_timer(time):
	time_label.set_text(str(time))


func get_time():
	return time_label.text

