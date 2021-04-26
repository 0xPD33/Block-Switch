extends Area2D

var hit_block_sound = "res://Assets/SFX/hit_block.wav"

var tile_size = 64

# LEVEL EDITOR VARIABLES

var editor

var editor_mode = false
var starting_position

#

onready var camera = $Camera2D
onready var controls = $OnScreenControls
onready var move_anim = $MoveAnimation


func set_cam_current():
	camera.current = true


func _ready():
	if get_tree().current_scene.name == "LevelEditor":
		editor = get_tree().current_scene
		editor_mode = true
		starting_position = position
		controls.fade_in()
	else:
		get_tree().current_scene.player = self
		if !get_tree().current_scene.restarting:
			controls.fade_in()
	snap()


func _input(_event):
	if !Global.movement_locked and !Global.game_over and !Global.level_done:
		if Input.is_action_just_pressed("move_up"):
			move(Vector2.UP)
		if Input.is_action_just_pressed("move_down"):
			move(Vector2.DOWN)
		if Input.is_action_just_pressed("move_left"):
			move(Vector2.LEFT)
		if Input.is_action_just_pressed("move_right"):
			move(Vector2.RIGHT)


func snap():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2


func move(dir):
	if get_tree().current_scene.name == "Game":
		get_tree().current_scene.get_node("CurrentLevel").start_timer()
	position += dir * tile_size
	move_anim.play("move")
	AudioManager.create_audio(hit_block_sound, 0.9, 1.1)


func die():
	if editor_mode:
		reset_level()
	else:
		get_tree().call_group("Game", "player_death")
		queue_free()


func respawn():
	rotation_degrees = 0
	controls.reset_control_rotation()
	position = starting_position
	snap()


func reset_level():
	for block in get_tree().get_nodes_in_group("MissingBlocks"):
		block.queue_free()
	for yellow_block in get_tree().get_nodes_in_group("BlockYellow"):
		if yellow_block.triggered:
			yellow_block.set_triggered(false)
			yellow_block.place_void()
	for red_block in get_tree().get_nodes_in_group("BlockRed"):
		if red_block.triggered:
			red_block.set_triggered(false)
	respawn()
	
