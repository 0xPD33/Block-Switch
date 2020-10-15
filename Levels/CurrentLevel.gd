extends Node2D

var current_level
var next_level
var level_number : int

# rating calculation: count amount of blocks in level and divide by time or something idk
var possible_ratings : PoolStringArray = ["What are you doing?", "Bad.", "Meh.", "Fine.", "Good!", "Great!", "Awesome!", "Perfect!"]
var max_rating_level : int = possible_ratings.size() - 1
var rating_level : int

var timer_started : bool = false
var total_time : float

var time setget set_time, get_time


func set_time(value):
	time = value


func get_time():
	return time


func _ready():
	current_level = load("res://Levels/Level1.tscn")
	level_number = 1


func _process(delta):
	if timer_started:
		total_time += delta
		set_time(stepify(total_time, 0.01))


func restart_level():
	stop_timer()
	
	var level = get_child(0)
	remove_child(level)
	level.call_deferred("free")
	
	var restarted_level_resource = load("res://Levels/Level" + str(level_number) + ".tscn")
	var restarted_level = restarted_level_resource.instance()
	add_child(restarted_level)
	
	Global.game_over = false


func change_level():
	level_number += 1
	# change the number to desired level below
	#level_number = 7
	load_next_level()


func load_next_level():
	stop_timer()
	
	var level = get_child(0)
	remove_child(level)
	level.call_deferred("free")
	
	var next_level_resource = load("res://Levels/Level" + str(level_number) + ".tscn")
	var next_level = next_level_resource.instance()
	add_child(next_level)
	
	current_level = next_level
	Global.level_done = false
	
	if level_number == 7:
		get_parent().launch_tutorial("YellowBlock")


func calculate_rating():
	var number_of_blocks = get_tree().get_nodes_in_group("Block").size()
	
	rating_level = number_of_blocks / total_time * 1.25
	var rating : String 
	
	if rating_level <= max_rating_level:
		rating = possible_ratings[rating_level]
	else:
		rating_level = max_rating_level
		rating = possible_ratings[rating_level]
	
	return rating


func start_timer():
	timer_started = true


func stop_timer():
	timer_started = false
	total_time = 0

