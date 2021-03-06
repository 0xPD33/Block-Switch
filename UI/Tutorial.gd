extends Control

var tutorial_levels : PoolIntArray = [1, 10, 20, 50]
var tutorials_shown : Dictionary = {"Welcome": false, "YellowBlock": false, "BlueBlock": false, "MultipleWays": false}
var shown : bool = false

var changing_states : bool = false
var tutorial_state : int = 0
var current_values : PoolStringArray

var welcome_tutorial_values : PoolStringArray = [
	"Welcome to Square Swap! Your goal in this game is to reach the green block as fast as possible.",
	"Hitting the translucent blocks next to the track will cause you to fail the level.",
	"Move using the arrow keys on your screen. Have fun!",
	]

var yellow_block_tutorial_values : PoolStringArray = [
	"You may notice a new block, the yellow-colored block, in this level.",
	"These blocks add missing blocks to the path. You have to trigger them to fill in the way to the goal.",
	"The yellow gems placed around the level mark the positions where blocks are missing."
]

var blue_block_tutorial_values : PoolStringArray = [
	"Another new block, the blue-colored block, has been introduced.",
	"This block teleports you around the level. It is important to act quickly in order to not lose time.",
	"The blue gems placed around the level are an indicator for where you're headed next.",
]

var multiple_ways_tutorial_values : PoolStringArray = [
	"In some levels, like this one, there are multiple ways of advancing toward the goal.",
	"In this case you can choose which yellow blocks to trigger in the starting area (either the top 2 for the top path or the bottom 2 for the bottom path).",
	"Sometimes both ways are equally short (or long) and in other cases one is shorter. It is up to you to find out the fastest way!",
]

onready var tutorial_text = $TutorialPanel/TutorialText
onready var anim_player = $AnimationPlayer


func _input(event):
	if shown and !changing_states:
		if event is InputEventScreenTouch and event.pressed:
			AudioManager.create_interface_click_sound()
			advance_tutorial()


func choose_tutorial():
	match Global.current_level_number:
		1:
			setup_tutorial("Welcome")
		10:
			setup_tutorial("YellowBlock")
		20:
			setup_tutorial("BlueBlock")
		50:
			setup_tutorial("MultipleWays")
	show_tutorial()


func setup_tutorial(tutorial_type : String):
	match tutorial_type:
		"Welcome":
			current_values = welcome_tutorial_values
		"YellowBlock":
			current_values = yellow_block_tutorial_values
		"BlueBlock":
			current_values = blue_block_tutorial_values
		"MultipleWays":
			current_values = multiple_ways_tutorial_values
	tutorials_shown[tutorial_type] = true


func show_tutorial():
	advance_tutorial_text()
	show()
	anim_player.play("open")
	yield(anim_player, "animation_finished")
	shown = true


func advance_tutorial_text():
	if tutorial_state < current_values.size():
		tutorial_text.text = current_values[tutorial_state]


func advance_tutorial():
	changing_states = true
	if tutorial_state < current_values.size() - 1:
		anim_player.play("advance_out")
		yield(anim_player, "animation_finished")
		tutorial_state += 1
		advance_tutorial_text()
		anim_player.play("advance_in")
		yield(anim_player, "animation_finished")
		changing_states = false
	else:
		close_tutorial()


func close_tutorial():
	anim_player.play("close")
	yield(anim_player, "animation_finished")
	hide()
	shown = false
	Global.movement_locked = false
	get_tree().paused = false
	tutorial_state = 0
	changing_states = false

