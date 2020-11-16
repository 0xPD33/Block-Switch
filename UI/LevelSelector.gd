extends Control

var level_selected : bool = false

onready var level_button_grid = $TabContainer/MAIN/LevelSelectContainer/LevelButtonGrid
onready var button_container = $TabContainer/MAIN/LevelSelectContainer/ButtonContainer

onready var level_details_panel = $TabContainer/MAIN/LevelDetailsPanel


func _ready():
	level_button_grid.level_selector = self
	level_button_grid.populate_grid()


func update_panel():
	var level_label = level_details_panel.get_node("DetailsPanelContainer/LevelLabel")
	level_label.text = "Level " + str(Global.current_level_number)


func update_buttons():
	var button_anim = button_container.get_node("ButtonAnimation")
	var play_button = button_container.get_node("LevelPlayButton")
	
	if play_button.disabled:
		button_anim.play("enable_play_button")
		yield(button_anim, "animation_finished")
		play_button.disabled = false


func _on_LevelPlayButton_pressed():
	get_tree().change_scene("res://Game/Game.tscn")

