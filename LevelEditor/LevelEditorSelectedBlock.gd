extends Control

var level_editor

onready var selected_block_image = $Panel/VBoxContainer/HBoxContainer/SelectedBlockImage
onready var selected_block_name = $Panel/VBoxContainer/HBoxContainer/SelectedBlockNameLabel


func _ready():
	if get_tree().current_scene.name == "LevelEditor":
		level_editor = get_tree().current_scene
	remove_selected_block()


func change_selected_block(name: String, image : Texture, modulate : Color):
	selected_block_name.text = name
	selected_block_image.texture = image
	selected_block_image.modulate = modulate


func remove_selected_block():
	selected_block_name.text = "None"
	if selected_block_image.texture:
		selected_block_image.texture = null

