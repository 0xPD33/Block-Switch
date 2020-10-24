extends Node

var sfx_volume : float = 0.0


func create_audio(audio_path : String):
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = load(audio_path)
	audio_player.set_volume_db(sfx_volume)
	audio_player.set_pitch_scale(rand_range(0.9, 1.1))
	add_child(audio_player)
	audio_player.play()

