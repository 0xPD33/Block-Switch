extends "res://Blocks/Block.gd"

export (String, FILE) var teleport_sound_1 = "res://Assets/SFX/teleport_sound1.wav"
export (String, FILE) var teleport_sound_2 = "res://Assets/SFX/teleport_sound2.wav"

var teleport_pos setget set_teleport_pos
var triggered = false

onready var teleport_sounds = [teleport_sound_1, teleport_sound_2]


func set_teleport_pos(value):
	teleport_pos = value


func teleport(player):
	if !triggered:
		triggered = true
		player.global_position = teleport_pos
		player.snap()
		play_teleport_sound()


func play_teleport_sound():
	randomize()
	var sound = teleport_sounds[randi() % teleport_sounds.size()]
	get_tree().call_group("AudioManager", "create_audio", sound)


func _on_BlockBlue_area_entered(area: Area2D):
	if area.is_in_group("Player"):
		teleport(area)

