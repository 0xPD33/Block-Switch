extends Control

signal placement_accepted

var is_visible : bool = false

var level_editor

onready var anim_player = $AnimationPlayer


func _ready():
	if get_parent().get_parent().name == "LevelEditor":
		level_editor = get_parent().get_parent()
	connect("placement_accepted", level_editor, "_on_place_confirmation_placement_accepted")


func confirmation_fade_in():
	if !is_visible:
		visible = true
		anim_player.play("confirmation_fade_in")
		yield(anim_player, "animation_finished")
		is_visible = true


func confirmation_fade_out():
	if is_visible:
		anim_player.play("confirmation_fade_out")
		yield(anim_player, "animation_finished")
		visible = false
		is_visible = false


func _on_AcceptButton_pressed():
	emit_signal("placement_accepted")
	confirmation_fade_out()

