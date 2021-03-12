extends Node

var interface_click_sound = "res://Assets/SFX/interface_click.wav"
var interface_click_secondary_sound = "res://Assets/SFX/interface_click_secondary.wav"

var game_over_sound = "res://Assets/SFX/game_over.wav"
var game_retry_sound = "res://Assets/SFX/game_retry.wav"

var place_block_sound = "res://Assets/SFX/add_block.wav"
var delete_block_sound = "res://Assets/SFX/delete_block.wav"
var trash_sound = "res://Assets/SFX/trash_sound.wav"

var add_block_sound = "res://Assets/SFX/add_block.wav"

var teleport_sound_1 = "res://Assets/SFX/teleport_1.wav"
var teleport_sound_2 = "res://Assets/SFX/teleport_2.wav"

var gem_disappear_sound

var sfx_volume : float = 0

onready var teleport_sounds = [AudioManager.teleport_sound_1, AudioManager.teleport_sound_2]


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


func create_trash_audio():
	create_audio(trash_sound, 0.9, 1.1)


func create_add_block_sound():
	create_audio(add_block_sound, 0.9, 1.1)


func create_teleport_sound():
	randomize()
	var teleport_sound = teleport_sounds[randi() % teleport_sounds.size()]
	create_audio(teleport_sound, 0.9, 1.1)

