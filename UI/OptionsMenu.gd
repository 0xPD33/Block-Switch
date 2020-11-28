extends Control

var confirmation_ready : bool = false

onready var confirmation_popup = $ConfirmationPopup

onready var anim_player = $AnimationPlayer
onready var confirmation_popup_anim = $ConfirmationPopupAnimation


func _ready():
	fade_in()


func fade_in():
	anim_player.play("options_menu_fade_in")


func fade_out():
	anim_player.play("options_menu_fade_out")


func _on_DeleteSaveButton_pressed():
	if !confirmation_popup.visible:
		confirmation_popup.popup()
		confirmation_popup_anim.play("confirmation_fade_in")
		yield(confirmation_popup_anim, "animation_finished")
		confirmation_ready = true


func _on_ConfirmationNoButton_pressed():
	if confirmation_popup.visible and confirmation_ready:
		confirmation_popup_anim.play("confirmation_fade_out")
		yield(confirmation_popup_anim, "animation_finished")
		confirmation_popup.hide()
		confirmation_ready = false


func _on_ConfirmationYesButton_pressed():
	if confirmation_popup.visible and confirmation_ready:
		SaveManager.delete_save_file()
		confirmation_popup_anim.play("confirmation_fade_out")
		yield(confirmation_popup_anim, "animation_finished")
		confirmation_popup.hide()
		confirmation_ready = false


func _on_ReturnToMenuButton_pressed():
	fade_out()
	yield(anim_player, "animation_finished")
	get_tree().change_scene("res://UI/MainMenu.tscn")


func _on_AcceptButton_pressed():
	pass

