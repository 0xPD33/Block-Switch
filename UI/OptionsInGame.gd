extends Control

var options_shown : bool = false

var edit_mode = false
var moving_controls = false
var scaling_controls = false

onready var options_button_panel = $OptionsButtonPanel
onready var accept_button_panel = $AcceptButtonPanel
onready var cancel_button_panel = $CancelButtonPanel

onready var anim_player = $AnimationPlayer


func options_open():
	var opening : bool = false
	if !opening:
		get_tree().paused = true
		anim_player.play("show_controls")
		opening = true
		yield(anim_player, "animation_finished")
		options_shown = true
		opening = false


func options_close():
	var closing : bool = false
	if !closing:
		anim_player.play("hide_controls")
		closing = true
		yield(anim_player, "animation_finished")
		options_shown = false
		closing = false
		if !edit_mode:
			get_tree().paused = false


func options_button_change_visibility():
	if options_button_panel.is_visible():
		options_button_panel.hide()
	else:
		options_button_panel.show()


func edit_buttons_change_visiblity():
	if edit_mode:
		accept_button_panel.show()
		cancel_button_panel.show()
	else:
		accept_button_panel.hide()
		cancel_button_panel.hide()


func move_controls_start():
	if !edit_mode:
		edit_mode = true
		moving_controls = true
		options_close()
		options_button_change_visibility()
		edit_buttons_change_visiblity()
		get_tree().call_group("ScreenDarkener", "fade_in")
		get_tree().call_group("Controls", "set_repositioning", true)


func move_controls_end():
	if edit_mode:
		edit_mode = false
		moving_controls = false
		options_open()
		options_button_change_visibility()
		edit_buttons_change_visiblity()
		get_tree().call_group("ScreenDarkener", "fade_out")
		get_tree().call_group("Controls", "set_repositioning", false)


func resize_controls_start():
	if !edit_mode:
		edit_mode = true
		scaling_controls = true
		options_close()
		options_button_change_visibility()
		edit_buttons_change_visiblity()
		get_tree().call_group("ScreenDarkener", "fade_in")
		get_tree().call_group("Controls", "set_resizing", true)


func resize_controls_end():
	if edit_mode:
		edit_mode = false
		scaling_controls = false
		options_open()
		options_button_change_visibility()
		edit_buttons_change_visiblity()
		get_tree().call_group("ScreenDarkener", "fade_out")
		get_tree().call_group("Controls", "set_resizing", false)


func _on_OptionsButton_pressed():
	if !options_shown:
		options_open()
	else:
		options_close()


func _on_MoveControlsButton_pressed():
	if options_shown:
		move_controls_start()


func _on_ScaleControlsButton_pressed():
	if options_shown:
		resize_controls_start()


func _on_AcceptButton_pressed():
	if edit_mode:
		if moving_controls:
			move_controls_end()
			get_tree().call_group("Controls", "save_position")
		if scaling_controls:
			resize_controls_end()
			get_tree().call_group("Controls", "save_size")


func _on_CancelButton_pressed():
	if edit_mode:
		if moving_controls:
			move_controls_end()
			get_tree().call_group("Controls", "reset_position")
		if scaling_controls:
			resize_controls_end()
			get_tree().call_group("Controls", "reset_size")

