extends Control

onready var gameplay_video_loop = $GameplayVideoLoop
onready var anim_player = $AnimationPlayer


func _ready():
	show_main_menu()


func show_main_menu():
	anim_player.play("main_menu_show")


func start_video():
	gameplay_video_loop.play()


func stop_video():
	gameplay_video_loop.stop()


func _on_GameplayVideoLoop_finished():
	gameplay_video_loop.play()


func _on_PlayButton_pressed():
	anim_player.play("main_menu_hide")
	yield(anim_player, "animation_finished")
	get_tree().change_scene("res://UI/LevelSelector.tscn")

