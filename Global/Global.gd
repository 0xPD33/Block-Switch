extends Node

var current_level_number : int
var levels_unlocked := [1]

var game_over = false
var level_done = false

var movement_locked = false


func _ready():
	OS.low_processor_usage_mode = false

