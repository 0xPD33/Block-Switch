extends Node2D

var current_level
var next_level
var level_number : int
var level_loaded = false

var ms = 0
var s = 0
var m = 0

var time setget set_time, get_time


func set_time(value):
	time = value


func get_time():
	return time


func _ready():
	current_level = load("res://Levels/Level1.tscn")
	level_number = 1


func restart_level():
	stop_timer()
	
	var level = get_node("Level" + str(level_number))
	remove_child(level)
	level.call_deferred("free")
	
	var restarted_level_resource = load("res://Levels/Level" + str(level_number) + ".tscn")
	var restarted_level = restarted_level_resource.instance()
	add_child(restarted_level)
	
	Global.game_over = false


func change_level():
	level_number += 1
	load_next_level()


func load_next_level():
	stop_timer()
	
	var level = get_node("Level" + str(level_number - 1))
	remove_child(level)
	level.call_deferred("free")
	
	var next_level_resource = load("res://Levels/Level" + str(level_number) + ".tscn")
	var next_level = next_level_resource.instance()
	add_child(next_level)
	
	current_level = next_level
	
	Global.level_done = false


func _process(delta):
	# I need to format this. Working with timers is too inaccurate.
	var OS_ms = OS.get_ticks_msec()
	
	if ms > 999:
		s += 1
		ms = 0
	
	if s > 59:
		m += 1
		s = 0
	
	
	set_time(str(m) + ":" + str(s) + ":" + str(ms))
	print(time)


func start_timer():
	ms = 0
	s = 0
	m = 0
	var timer = Timer.new()
	timer.wait_time = 0.01
	timer.name = "CompletionTimer" + str(level_number)
	add_child(timer)
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.start()


func stop_timer():
	for node in get_children():
		if node is Timer:
			node.queue_free()


func _on_timer_timeout():
	ms += 10

