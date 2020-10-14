extends Node2D

var game_over = false

onready var current_level = $CurrentLevel

onready var game_over_scene = $UI/GameOver
onready var level_done_scene = $UI/LevelDone
onready var tutorial_scene = $UI/Tutorial


func _ready():
	get_tree().call_group("Player", "set_cam_current")
	if !Global.tutorial_shown:
		get_tree().paused = true
		tutorial_scene.setup_tutorial("Welcome")
		tutorial_scene.show_tutorial()


func create_death_cam(pos, zoom):
	var death_cam = Camera2D.new()
	death_cam.zoom = zoom
	death_cam.position = pos
	death_cam.name = "DeathCamera"
	get_tree().current_scene.add_child(death_cam)
	death_cam.current = true
	create_death_animation(death_cam)


func create_death_animation(camera):
	var death_tween = Tween.new()
	var anim_duration = 60.0
	death_tween.interpolate_property(camera, "zoom", Vector2(3, 3), Vector2(10, 10), anim_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_tree().current_scene.add_child(death_tween)
	death_tween.start()


func prompt_retry():
	if Global.game_over:
		game_over_scene.show()
		game_over_scene.get_node("AnimationPlayer").play("fade_in")


func player_death(player):
	Global.game_over = true
	var player_cam = player.get_node("Camera2D")
	create_death_cam(player.position, player_cam.zoom)
	prompt_retry()


func level_done():
	Global.level_done = true
	var completion_time = current_level.get_time()
	var completion_rating = current_level.calculate_rating()
	current_level.stop_timer()
	level_done_scene.done_label.text = "Level " + str(current_level.level_number) + " done!"
	level_done_scene.time_label.text = str(completion_time)
	level_done_scene.rating_label.text = completion_rating
	level_done_scene.show()
	level_done_scene.get_node("AnimationPlayer").play("fade_in")


func restart_level():
	if Global.level_done:
		Global.level_done = false
	current_level.restart_level()
	get_tree().call_group("Player", "set_cam_current")


func change_level():
	current_level.change_level()

