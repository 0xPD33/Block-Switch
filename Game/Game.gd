extends Node2D

onready var current_level = $CurrentLevel

onready var game_over_scene = $UI/GameOver
onready var level_done_scene = $UI/LevelDone
onready var tutorial_scene = $UI/Tutorial


func _ready():
	yield(get_tree(), "idle_frame")
	if !Global.tutorial_shown:
		launch_tutorial("Welcome")


func launch_tutorial(tutorial_type : String):
	get_tree().paused = true
	tutorial_scene.setup_tutorial(tutorial_type)
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
	unlock_next_level()
	var completion_time = current_level.get_time()
	var completion_rating = current_level.calculate_rating()
	SaveManager.save_levels_unlocked()
	SaveManager.save_level_time(Global.current_level_number, completion_time)
	SaveManager.save_level_rating(Global.current_level_number, completion_rating)
	SaveManager.save_game()
	current_level.stop_timer()
	level_done_scene.done_label.text = "Level " + str(Global.current_level_number) + " done!"
	level_done_scene.time_label.text = "Time: " + str(completion_time) + " seconds"
	level_done_scene.rating_label.text = completion_rating
	level_done_scene.show()
	level_done_scene.get_node("AnimationPlayer").play("fade_in")


func unlock_next_level():
	if not Global.current_level_number + 1 in Global.levels_unlocked:
		Global.levels_unlocked.append(Global.current_level_number + 1)


func restart_level():
	current_level.restart_level()


func change_level():
	current_level.change_level()

