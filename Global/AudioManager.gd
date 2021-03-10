extends Node

export (String, FILE) var interface_click_sound = "res://Assets/SFX/interface_click.wav"
export (String, FILE) var interface_click_secondary_sound = "res://Assets/SFX/interface_click_secondary.wav"

export (String, FILE) var game_over_sound = "res://Assets/SFX/game_over.wav"
export (String, FILE) var game_retry_sound = "res://Assets/SFX/game_retry.wav"

export (String, FILE) var place_block_sound = "res://Assets/SFX/add_block.wav"
export (String, FILE) var delete_block_sound = "res://Assets/SFX/delete_block.wav"

export (String, FILE) var teleport_sound_1 = "res://Assets/SFX/teleport_1.wav"
export (String, FILE) var teleport_sound_2 = "res://Assets/SFX/teleport_2.wav"

export (String, FILE) var gem_disappear_sound

var sfx_volume : float = 0


func _ready():
	if GlobalOptions.sfx_volume:
		sfx_volume = GlobalOptions.sfx_volume


func create_audio(audio_path : String, pitch_range_start : float = 1, pitch_range_end : float = 1):
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = load(audio_path)
	audio_player.set_bus("SFX")
	audio_player.set_volume_db(sfx_volume)
	audio_player.set_pitch_scale(rand_range(pitch_range_start, pitch_range_end))
	add_child(audio_player)
	audio_player.connect("finished", audio_player, "queue_free")
	audio_player.play()


func create_interface_click_sound():
	create_audio(interface_click_sound, 0.9, 1.1)


func create_interface_click_secondary_sound():
	create_audio(interface_click_secondary_sound, 0.9, 1.1)


func create_game_over_sound():
	create_audio(game_over_sound)


func create_game_retry_sound():
	create_audio(game_retry_sound)


func create_place_block_sound():
	create_audio(place_block_sound, 0.9, 1.1)


func create_delete_block_sound():
	create_audio(delete_block_sound, 0.9, 1.1)

