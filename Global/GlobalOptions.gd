extends Node

var sfx_volume : float = 0 setget set_sfx_volume, get_sfx_volume
var music_volume : float = 0 setget set_music_volume, get_music_volume

var sfx_muted : bool = false setget set_sfx_muted, get_sfx_muted
var music_muted : bool = false setget set_music_muted, get_music_muted

var controls_position = null setget set_controls_position, get_controls_position
var controls_size = null setget set_controls_size, get_controls_size


func set_sfx_volume(value):
	sfx_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)


func get_sfx_volume():
	return sfx_volume


func set_music_volume(value):
	music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)


func get_music_volume():
	return music_volume


func set_sfx_muted(value):
	sfx_muted = value
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), value)


func get_sfx_muted():
	return sfx_muted


func set_music_muted(value):
	music_muted = value
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), value)


func get_music_muted():
	return music_muted


func set_controls_position(value):
	controls_position = value


func get_controls_position():
	return controls_position


func set_controls_size(value):
	controls_size = value


func get_controls_size():
	return controls_size


func _ready():
	SaveManager.load_options()
	sfx_volume = SaveManager.load_sfx_volume()
	sfx_muted = SaveManager.load_sfx_muted()
	music_volume = SaveManager.load_music_volume()
	music_muted = SaveManager.load_music_muted()

