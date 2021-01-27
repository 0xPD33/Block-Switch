extends Control

onready var title_anim = $TitleAnimation
onready var anim_player = $AnimationPlayer


func _ready():
	show_main_menu()


func show_main_menu():
	title_anim.get_node("AnimationPlayer").play("title_anim")
	yield(title_anim.get_node("AnimationPlayer"), "animation_finished")
	anim_player.play("main_menu_show")


func _on_PlayButton_pressed():
	anim_player.play("main_menu_hide")
	title_anim.get_node("AnimationPlayer").play("title_hide")
	yield(anim_player, "animation_finished")
	get_tree().change_scene("res://UI/LevelSelector.tscn")


func _on_OptionsButton_pressed():
	anim_player.play("main_menu_hide")
	title_anim.get_node("AnimationPlayer").play("title_hide")
	yield(anim_player, "animation_finished")
	get_tree().change_scene("res://UI/OptionsMenu.tscn")

