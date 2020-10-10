extends Node2D


func _ready():
	call_deferred("start_timer")
	get_parent().current_level = self


func start_timer():
	get_parent().start_timer()

