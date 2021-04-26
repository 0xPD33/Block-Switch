extends Control

export (Texture) var sfx_loud_texture
export (Texture) var sfx_mute_texture

export (Texture) var music_loud_texture
export (Texture) var music_mute_texture

export (Color) var volume_loud_color
export (Color) var volume_mute_color

var options_loaded : bool = false

var sfx_volume : float setget set_sfx_volume
var music_volume : float setget set_music_volume

var sfx_muted : bool = false
var music_muted : bool = false

var confirmation_ready : bool = false

onready var sfx_volume_slider = $TabContainer/AUDIO/OptionsContainer/SFXVolumeContainer/SFXVolumeSlider
onready var sfx_mute_button = $TabContainer/AUDIO/OptionsContainer/SFXVolumeContainer/SFXMuteButton

onready var music_volume_slider = $TabContainer/AUDIO/OptionsContainer/MusicVolumeContainer/MusicVolumeSlider
onready var music_mute_button = $TabContainer/AUDIO/OptionsContainer/MusicVolumeContainer/MusicMuteButton

onready var anim_player = $AnimationPlayer

onready var confirmation_popup = $ConfirmationPopup
onready var confirmation_popup_anim = $ConfirmationPopupAnimation


func set_sfx_volume(value):
	sfx_volume = value


func set_music_volume(value):
	music_volume = value


func _ready():
	load_options()
	fade_in()


func fade_in():
	anim_player.play("options_menu_fade_in")


func fade_out():
	anim_player.play("options_menu_fade_out")


func load_options():
	SaveManager.load_options()
	
	sfx_volume = SaveManager.load_sfx_volume()
	sfx_muted = SaveManager.load_sfx_muted()
	music_volume = SaveManager.load_music_volume()
	music_muted = SaveManager.load_music_muted()
	
	sfx_volume_slider.value = sfx_volume
	music_volume_slider.value = music_volume
	
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), sfx_muted)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), music_muted)
	
	for string in ["SFX", "Music"]:
		change_mute_button_texture(string)
	
	options_loaded = true


func save_options():
	GlobalOptions.set_sfx_volume(sfx_volume)
	GlobalOptions.set_sfx_muted(sfx_muted)
	GlobalOptions.set_music_volume(music_volume)
	GlobalOptions.set_music_muted(music_muted)
	SaveManager.save_sfx_volume()
	SaveManager.save_music_volume()
	SaveManager.save_options()


func create_test_audio(bus : String):
	var test_audio = "res://Assets/SFX/hit_block.wav"
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = load(test_audio)
	audio_player.set_bus(bus)
	
	if bus == "SFX":
		audio_player.set_volume_db(sfx_volume)
	elif bus == "Music":
		audio_player.set_volume_db(music_volume)
	
	add_child(audio_player)
	audio_player.connect("finished", audio_player, "queue_free")
	audio_player.play()


func change_mute_button_texture(audio_type : String):
	match audio_type:
		"SFX":
			if sfx_muted:
				sfx_mute_button.texture_normal = sfx_mute_texture
				sfx_mute_button.modulate = volume_mute_color
			else:
				sfx_mute_button.texture_normal = sfx_loud_texture
				sfx_mute_button.modulate = volume_loud_color
		"Music":
			if music_muted:
				music_mute_button.texture_normal = music_mute_texture
				music_mute_button.modulate = volume_mute_color
			else:
				music_mute_button.texture_normal = music_loud_texture
				music_mute_button.modulate = volume_loud_color


func switch_mute(bus : String):
	match bus:
		"SFX":
			sfx_muted = !sfx_muted
			AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), sfx_muted)
		"Music":
			music_muted = !music_muted
			AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), music_muted)
	
	change_mute_button_texture(bus)


func _on_SFXVolumeSlider_value_changed(value: float):
	sfx_volume = value
	if options_loaded:
		create_test_audio("SFX")


func _on_MusicVolumeSlider_value_changed(value: float):
	music_volume = value


func _on_DeleteSaveButton_pressed():
	if !confirmation_popup.visible:
		AudioManager.create_interface_click_sound()
		confirmation_popup.popup()
		confirmation_popup_anim.play("confirmation_fade_in")
		yield(confirmation_popup_anim, "animation_finished")
		confirmation_ready = true


func _on_ConfirmationNoButton_pressed():
	if confirmation_popup.visible and confirmation_ready:
		AudioManager.create_interface_click_sound()
		confirmation_popup_anim.play("confirmation_fade_out")
		yield(confirmation_popup_anim, "animation_finished")
		confirmation_popup.hide()
		confirmation_ready = false


func _on_ConfirmationYesButton_pressed():
	if confirmation_popup.visible and confirmation_ready:
		AudioManager.create_interface_click_sound()
		SaveManager.delete_save_file()
		confirmation_popup_anim.play("confirmation_fade_out")
		yield(confirmation_popup_anim, "animation_finished")
		confirmation_popup.hide()
		confirmation_ready = false


func _on_ReturnToMenuButton_pressed():
	AudioManager.create_interface_click_sound()
	fade_out()
	yield(anim_player, "animation_finished")
	get_tree().change_scene("res://UI/MainMenu.tscn")


func _on_AcceptButton_pressed():
	AudioManager.create_interface_click_sound()
	save_options()
	fade_out()
	yield(anim_player, "animation_finished")
	get_tree().change_scene("res://UI/MainMenu.tscn")


func _on_SFXMuteButton_pressed():
	switch_mute("SFX")


func _on_MusicMuteButton_pressed():
	switch_mute("Music")

