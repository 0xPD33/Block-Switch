extends Control

var is_open : bool = false

var level_editor

onready var goal_requirement_label = $RequirementsPanel/RequirementsContainer/GoalRequirementLabel
onready var player_requirement_label = $RequirementsPanel/RequirementsContainer/PlayerRequirementLabel
onready var playable_requirement_label = $RequirementsPanel/RequirementsContainer/PlayablePathRequirementLabel

onready var test_level_button = $BigPanel/ButtonContainer/TestLevelButton
onready var save_level_button = $BigPanel/ButtonContainer/SaveLevelButton

onready var open_options_panel_button = $OpenOptionsPanelButton

onready var move_tween = $MoveTween


func _ready():
	if get_parent().get_parent():
		if get_parent().get_parent().name == "LevelEditor":
			level_editor = get_parent().get_parent()
	test_level_button.disabled = true
	if !is_open:
		move_tween.interpolate_property(self, "rect_position:x", rect_position.x - 55, rect_position.x, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		move_tween.start()
		open_options_panel_button.text = "<"
		is_open = true


func open_options_panel():
	move_tween.interpolate_property(self, "rect_position:x", rect_position.x, rect_position.x + 55, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	move_tween.start()
	open_options_panel_button.text = "<"
	is_open = true


func close_options_panel():
	move_tween.interpolate_property(self, "rect_position:x", rect_position.x, rect_position.x - 55, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	move_tween.start()
	open_options_panel_button.text = ">"
	yield(move_tween, "tween_completed")
	is_open = false


func change_goal_requirement_text(num : int):
	if num == 0:
		goal_requirement_label.text = "Goal: 0/1"
	elif num == 1:
		goal_requirement_label.text = "Goal: 1/1"


func change_player_requirement_text(num : int):
	if num == 0:
		player_requirement_label.text = "Player: 0/1"
	elif num == 1:
		player_requirement_label.text = "Player: 1/1"


func change_testable(is_testable : bool):
	if is_testable:
		test_level_button.disabled = false
	else:
		test_level_button.disabled = true


func change_saveable(is_saveable : bool):
	if is_saveable:
		save_level_button.disabled = false
	else:
		save_level_button.disabled = true


func change_playable_requirement_text(is_playable : bool):
	if is_playable:
		playable_requirement_label.text = "Playable: Yes"
	elif !is_playable:
		playable_requirement_label.text = "Playable: No"


func change_test_level_button_text():
	if level_editor.testing_level:
		test_level_button.text = "Stop Testing"
	else:
		test_level_button.text = "Test Level"


func _on_OpenOptionsPanelButton_pressed():
	if !is_open:
		open_options_panel()
	else:
		close_options_panel()


func _on_TestLevelButton_pressed():
	if level_editor != null:
		if !level_editor.testing_level:
			level_editor.test_level()
		else:
			level_editor.stop_testing_level(false)


func _on_SaveLevelButton_pressed():
	if level_editor != null:
		level_editor.open_level_saver_confirmation()

