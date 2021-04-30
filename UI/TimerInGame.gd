extends Control

var shown : bool = false

onready var time_label = $VBoxContainer/TimeLabel
onready var fade_anim = $FadeAnimation


func set_timer(time):
	time_label.set_text(str(time))


func get_time():
	return time_label.text


func _ready():
	timer_fade_in()


func timer_fade_in():
	if !shown:
		fade_anim.play("fade_in")
		yield(fade_anim, "animation_finished")
		shown = true


func timer_fade_out():
	if shown:
		fade_anim.play("fade_out")
		yield(fade_anim, "animation_finished")
		shown = false

