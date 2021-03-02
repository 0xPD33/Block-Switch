extends Node

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

