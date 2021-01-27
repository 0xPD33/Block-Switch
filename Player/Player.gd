extends Area2D

var hit_block_sound = "res://Assets/SFX/hit_block.wav"

var tile_size = 64

# LEVEL EDITOR VARIABLES

var editor

var editor_mode = false
var starting_position

#

onready var camera = $Camera2D
onready var move_anim = $MoveAnimation


func set_cam_current():
	camera.current = true


func _ready():
	if get_tree().current_scene.name == "LevelEditor":
		editor = get_tree().current_scene
		editor_mode = true
		starting_position = position
	set_cam_current()
	snap()


func _input(_event):
	if !Global.game_over and !Global.level_done:
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
	position += dir * tile_size
	move_anim.play("move")
	get_tree().call_group("AudioManager", "create_audio", hit_block_sound)


func die():
	if editor_mode:
		respawn()
	else:
		get_tree().call_group("Game", "player_death", self)
		queue_free()


func respawn():
	position = starting_position
	snap()

