extends "res://Blocks/Block.gd"

export (PackedScene) var block_scene
export (String, FILE) var add_block_sound = "res://Assets/SFX/add_block.wav"

var missing_block_pos setget set_missing_block_pos
var triggered = false setget set_triggered

# LEVEL EDITOR VARIABLES

var editor_mode = false

var void_scene = preload("res://Blocks/Void.tscn")

#


func set_triggered(value):
	triggered = value


func set_missing_block_pos(value):
	missing_block_pos = value


func _ready():
	if get_tree().current_scene.name == "LevelEditor":
		editor_mode = true


func place_void():
	var void_instance = void_scene.instance()
	void_instance.position = missing_block_pos
	get_parent().add_child(void_instance)


func add_block():
	if !triggered:
		set_triggered(true)
		var block_instance = block_scene.instance()
		block_instance.position = missing_block_pos
		block_instance.name = "MissingBlock"
		block_instance.add_to_group("MissingBlocks")
		get_tree().call_group("AudioManager", "create_audio", add_block_sound)
		get_parent().call_deferred("add_child", block_instance)


func _on_BlockYellow_area_entered(area: Area2D):
	if area.is_in_group("Player"):
		add_block()

