extends Control

export (String, FILE) var interface_click_sound = "res://Assets/SFX/interface_click.wav"

onready var title_anim = $TitleAnimation
onready var anim_player = $AnimationPlayer
onready var audio_manager = $AudioManager


func _ready():
	show_main_menu()


func show_main_menu():
	title_anim.get_node("AnimationPlayer").play("title_anim")
	yield(title_anim.get_node("AnimationPlayer"), "animation_finished")
	anim_player.play("main_menu_show")


func _on_PlayButton_pressed():
	AudioManager.create_audio(interface_click_sound, 0.9, 1.1)
	anim_player.play("main_menu_hide")
	title_anim.get_node("AnimationPlayer").play("title_hide")
	yield(anim_player, "animation_finished")
	get_tree().change_scene("res://UI/LevelSelector.tscn")


func _on_OptionsButton_pressed():
	AudioManager.create_audio(interface_click_sound, 0.9, 1.1)
	anim_player.play("main_menu_hide")
	title_anim.get_node("AnimationPlayer").play("title_hide")
	yield(anim_player, "animation_finished")
	get_tree().change_scene("res://UI/OptionsMenu.tscn")

