extends Control

var shown = false
var tutorial_state = 0
var current_values : PoolStringArray

var welcome_tutorial_values : PoolStringArray = [
	"Welcome to Block Switch! Your goal is to reach the green block as fast as possible.",
	"Hitting the translucent blocks next to the track will cause you to fail the level.",
	"Move using the arrow keys on your screen. Have fun!",
	]

var yellow_block_tutorial_values : PoolStringArray = [
	"You may notice a new block, the yellow-colored block, in this level.",
	"These blocks add missing blocks to the path. You have to trigger them to fill in the way to the goal",
]

var red_block_tutorial_values : PoolStringArray = [
	"Another new block, the red-colored block, has been introduced.",
	"It doesn't add new blocks, but rearranges the current path. You have to act fast if you don't want to lose time!",
]

onready var tutorial_text = $TutorialPanel/TutorialText
onready var anim_player = $AnimationPlayer


func _input(event):
	if shown:
		if event is InputEventScreenTouch and event.pressed:
			advance_tutorial()


func setup_tutorial(tutorial_type : String):
	match tutorial_type:
		"Welcome":
			current_values = welcome_tutorial_values
		"YellowBlock":
			current_values = yellow_block_tutorial_values
		"RedBlock":
			current_values = red_block_tutorial_values


func advance_tutorial_text():
	if tutorial_state < current_values.size():
		tutorial_text.text = current_values[tutorial_state]


func show_tutorial():
	advance_tutorial_text()
	show()
	anim_player.play("open")
	yield(anim_player, "animation_finished")
	shown = true


func advance_tutorial():
	if tutorial_state < current_values.size() - 1:
		close_tutorial(false)
		yield(anim_player, "animation_finished")
		show_tutorial()
	else:
		close_tutorial(true)


func close_tutorial(last : bool):
	if !last:
		anim_player.play("close")
		yield(anim_player, "animation_finished")
		tutorial_state += 1
		hide()
		shown = false
	else:
		anim_player.play("close")
		yield(anim_player, "animation_finished")
		hide()
		shown = false
		Global.tutorial_shown = false
		get_tree().paused = false
		tutorial_state = 0
		get_tree().call_group("CurrentLevel", "start_timer")

