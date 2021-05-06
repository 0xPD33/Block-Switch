extends Node

var sfx_volume : float = 0 setget set_sfx_volume, get_sfx_volume
var music_volume : float = 0 setget set_music_volume, get_music_volume

var sfx_muted : bool = false setget set_sfx_muted, get_sfx_muted
var music_muted : bool = false setget set_music_muted, get_music_muted

var controls_position_x = 320 setget set_controls_position_x, get_controls_position_x
var controls_position_y = 110 setget set_controls_position_y, get_controls_position_y
var controls_size_x = 1 setget set_controls_size_x, get_controls_size_x
var controls_size_y = 1 setget set_controls_size_y, get_controls_size_y


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


func set_controls_position_x(value):
	controls_position_x = value


func get_controls_position_x():
	return controls_position_x


func set_controls_position_y(value):
	controls_position_y = value


func get_controls_position_y():
	return controls_position_y


func set_controls_size_x(value):
	controls_size_x = value


func get_controls_size_x():
	return controls_size_x


func set_controls_size_y(value):
	controls_size_y = value


func get_controls_size_y():
	return controls_size_y


func _ready():
	SaveManager.load_options()
	sfx_volume = SaveManager.load_sfx_volume()
	sfx_muted = SaveManager.load_sfx_muted()
	music_volume = SaveManager.load_music_volume()
	music_muted = SaveManager.load_music_muted()
	controls_position_x = SaveManager.load_controls_position_x()
	controls_position_y = SaveManager.load_controls_position_y()
	controls_size_x = SaveManager.load_controls_size_x()
	controls_size_y = SaveManager.load_controls_size_y()

