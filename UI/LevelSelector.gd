extends Control

var level_selected : bool = false

onready var level_button_grid = $TabContainer/MAIN/LevelSelectContainer/LevelButtonGrid
onready var button_container = $TabContainer/MAIN/LevelSelectContainer/ButtonContainer
onready var level_details_panel = $TabContainer/MAIN/LevelDetailsPanel
onready var anim_player = $AnimationPlayer


func _ready():
	SaveManager.load_game()
	Global.levels_unlocked = SaveManager.load_levels_unlocked()
	level_button_grid.level_selector = self
	level_button_grid.populate_grid()
	fade_in()


func fade_in():
	anim_player.play("level_selector_fade_in")


func fade_out():
	anim_player.play("level_selector_fade_out")


func update_panel():
	var level_label = level_details_panel.get_node("DetailsPanelContainer/LevelLabel")
	level_label.text = "Level " + str(Global.current_level_number)
	
	var best_time_value_label = level_details_panel.get_node("DetailsPanelContainer/BestTimeValueLabel")
	var best_time_value = SaveManager.load_level_time(Global.current_level_number)
	if typeof(best_time_value) == TYPE_REAL:
		best_time_value_label.text = str(best_time_value) + " seconds"
	else:
		best_time_value_label.text = best_time_value
	
	var best_rating_value_label = level_details_panel.get_node("DetailsPanelContainer/BestRatingValueLabel")
	var best_rating_value = SaveManager.load_level_rating(Global.current_level_number)
	best_rating_value_label.text = best_rating_value


func update_buttons():
	var button_anim = button_container.get_node("ButtonAnimation")
	var play_button = button_container.get_node("LevelPlayButton")
	
	if play_button.disabled:
		button_anim.play("enable_play_button")
		yield(button_anim, "animation_finished")
		play_button.disabled = false


func _on_LevelPlayButton_pressed():
	fade_out()
	yield(anim_player, "animation_finished")
	get_tree().change_scene("res://Game/Game.tscn")

