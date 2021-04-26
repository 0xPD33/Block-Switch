extends Control

export (String, FILE) var interface_click_sound = "res://Assets/SFX/interface_click.wav"

var level_selected : bool = false
var level_locked : bool = false

onready var level_button_grid = $TabContainer/MAIN/LevelSelectContainer/ScrollContainer/MarginContainer/LevelButtonGrid
onready var button_container = $TabContainer/MAIN/ButtonContainer

onready var button_anim = button_container.get_node("ButtonAnimation")
onready var play_button = button_container.get_node("LevelPlayButton")

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
	var best_time_value_label = level_details_panel.get_node("DetailsPanelContainer/BestTimeValueLabel")
	var best_time_value = SaveManager.load_level_time(Global.current_level_number)
	var best_rating_value_label = level_details_panel.get_node("DetailsPanelContainer/BestRatingValueLabel")
	var best_rating_value = SaveManager.load_level_rating(Global.current_level_number)
	var delete_score_button = level_details_panel.get_node("DeleteScoreButton")
	
	if level_selected:
		level_label.text = "Level " + str(Global.current_level_number)
	else:
		level_label.text = "Level -"
	
	if best_time_value == "---":
		delete_score_button.visible = false
	else:
		delete_score_button.visible = true
		
	best_time_value_label.text = best_time_value
	best_rating_value_label.text = best_rating_value


func update_buttons():
	if level_selected:
		if level_locked:
			if !play_button.disabled:
				disable_play_button()
		else:
			if play_button.disabled:
				enable_play_button()
	else:
		if !play_button.disabled:
			disable_play_button()


func enable_play_button():
	button_anim.play("enable_play_button")
	yield(button_anim, "animation_finished")
	play_button.disabled = false


func disable_play_button():
	play_button.disabled = true
	button_anim.play("disable_play_button")
	yield(button_anim, "animation_finished")


func _on_LevelSelectContainer_gui_input(event: InputEvent):
	if event is InputEventScreenTouch:
		Global.current_level_number = 0
		level_selected = false
		update_panel()
		update_buttons()


func _on_LevelPlayButton_pressed():
	AudioManager.create_audio(interface_click_sound, 0.9, 1.1)
	fade_out()
	yield(anim_player, "animation_finished")
	get_tree().change_scene("res://Game/Game.tscn")


func _on_ReturnToMenuButton_pressed():
	AudioManager.create_audio(interface_click_sound, 0.9, 1.1)
	fade_out()
	yield(anim_player, "animation_finished")
	get_tree().change_scene("res://UI/MainMenu.tscn")


func _on_DeleteScoreButton_pressed():
	AudioManager.create_trash_sound()
	SaveManager.delete_level_score(Global.current_level_number)
	update_panel()


func _on_CustomLevelCreateButton_pressed():
	get_tree().change_scene("res://Levels/LevelEditor.tscn")

