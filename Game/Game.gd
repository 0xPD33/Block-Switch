extends Node2D

var player

var restarting : bool = false

onready var current_level = $CurrentLevel

onready var game_over_scene = $UI/GameOver
onready var level_done_scene = $UI/LevelDone
onready var tutorial_scene = $UI/Tutorial
onready var timer_in_game = $UI/TimerInGame

onready var level_fade_anim = $LevelFadeAnimation


func _ready():
	yield(get_tree(), "idle_frame")
	Global.movement_locked = true
	level_fade_anim.play("level_fade_in")
	yield(level_fade_anim, "animation_finished")
	if Global.current_level_number in tutorial_scene.tutorial_levels:
		launch_tutorial()
	else:
		Global.movement_locked = false


func _process(delta: float):
	if !Global.game_over and !Global.level_done:
		timer_in_game.set_timer(current_level.get_time())


func launch_tutorial():
	get_tree().paused = true
	tutorial_scene.choose_tutorial()


func create_death_cam(pos, zoom):
	var death_cam = Camera2D.new()
	death_cam.position = pos
	death_cam.zoom = zoom
	death_cam.name = "DeathCamera"
	get_tree().current_scene.add_child(death_cam)
	death_cam.current = true
	create_death_animation(death_cam)


func create_death_animation(camera):
	var death_tween = Tween.new()
	death_tween.name = "DeathTween"
	var anim_duration = 60.0
	death_tween.interpolate_property(camera, "zoom", Vector2(3, 3), Vector2(10, 10), anim_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_tree().current_scene.add_child(death_tween)
	death_tween.start()


func create_retry_cam(pos, zoom):
	var retry_cam = Camera2D.new()
	retry_cam.position = pos
	retry_cam.zoom = zoom
	retry_cam.name = "RetryCamera"
	get_tree().current_scene.add_child(retry_cam)
	retry_cam.current = true
	create_retry_animation(retry_cam)


func create_retry_animation(camera):
	var retry_tween = Tween.new()
	retry_tween.name = "RetryTween"
	var anim_duration = 0.6
	retry_tween.interpolate_property(camera, "zoom", camera.zoom, Vector2(3, 3), anim_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	retry_tween.interpolate_property(camera, "position", camera.position, player.position, anim_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_tree().current_scene.add_child(retry_tween)
	retry_tween.start()


func player_death():
	Global.game_over = true
	current_level.stop_timer()
	var player_cam = player.get_node("Camera2D")
	create_death_cam(player.position, player_cam.zoom)
	game_over_scene.setup()


func player_restart():
	if Global.level_done:
		return
	player.controls.set_visible(false)
	create_retry_cam(get_node("DeathCamera").position, get_node("DeathCamera").zoom)
	yield(get_node("RetryTween"), "tween_completed")
	player.set_cam_current()
	player.controls.fade_in()
	get_node("DeathTween").queue_free()
	get_node("DeathCamera").queue_free()
	get_node("RetryTween").queue_free()
	get_node("RetryCamera").queue_free()
	restarting = false


func level_done():
	Global.level_done = true
	level_fade_anim.play("level_fade_out")
	var completion_time = current_level.get_time()
	var completion_rating = current_level.calculate_rating()
	save_progress(completion_time, completion_rating)
	current_level.stop_timer()
	player.controls.set_visible(false)
	level_done_scene.setup(completion_time, completion_rating)


func unlock_next_level():
	if not Global.current_level_number + 1 in Global.levels_unlocked:
		Global.levels_unlocked.append(Global.current_level_number + 1)


func save_progress(time, rating):
	unlock_next_level()
	SaveManager.save_levels_unlocked()
	SaveManager.save_level_time(Global.current_level_number, time)
	SaveManager.save_level_rating(Global.current_level_number, rating)
	SaveManager.save_game()


func restart_level():
	if Global.game_over:
		restarting = true
	elif Global.level_done:
		level_fade_anim.play("level_fade_in")
		player.controls.fade_in()
	current_level.restart_level()


func change_level():
	current_level.change_level()
	level_fade_anim.play("level_fade_in")

