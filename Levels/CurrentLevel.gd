extends Node2D

var current_level
var next_level
var level_number : int = 0

var possible_ratings : PoolStringArray = ["What are you doing?", "Bad.", "Meh.", "Fine.", "Good!", "Great!", "Awesome!", "Perfect!"]
var max_rating_level : int = possible_ratings.size()
var rating_level : int

var timer_started : bool = false
var total_time : float

var time setget set_time, get_time


func set_time(value):
	time = value


func get_time():
	return time


func _ready():
	change_level()


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


func change_level():
	level_number += 1
	# change the number to desired level below
	#level_number = 10
	load_next_level()


func load_next_level():
	stop_timer()
	
	var level = get_child(0)
	remove_child(level)
	level.call_deferred("free")
	
	var next_level_resource = load("res://Levels/Level" + str(level_number) + ".tscn")
	var next_level_instance = next_level_resource.instance()
	add_child(next_level_instance)
	
	if level_number == 7:
		get_parent().launch_tutorial("YellowBlock")
	else:
		start_timer()


func calculate_rating():
	var number_of_normal_blocks = get_tree().get_nodes_in_group("Block").size()
	var number_of_yellow_blocks = get_tree().get_nodes_in_group("BlockYellow").size()
	#var number_of_red_blocks = get_tree().get_nodes_in_group("BlockRed").size()
	
	rating_level = (number_of_normal_blocks + (number_of_yellow_blocks * 4)) / total_time * 1.33
	var rating : String 
	
	if rating_level <= max_rating_level:
		rating = possible_ratings[rating_level - 1]
	else:
		rating_level = max_rating_level
		rating = possible_ratings[rating_level - 1]
	
	return rating + " " + str(rating_level) + "/" + str(max_rating_level)


func start_timer():
	timer_started = true


func stop_timer():
	timer_started = false
	total_time = 0

