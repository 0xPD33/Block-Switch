extends Sprite

export (float) var increase_alpha_anim_duration = 1.5
export (float) var increase_alpha_multiplier_value = 0.5

onready var shader = get_material()
onready var shader_alpha_multiplier = shader.get_shader_param("alpha_mult")


func increase_alpha():
	var increase_tween = Tween.new()
	increase_tween.interpolate_property(shader, "shader_param/alpha_mult", shader_alpha_multiplier, increase_alpha_multiplier_value, increase_alpha_anim_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_tree().current_scene.add_child(increase_tween)
	increase_tween.connect("tween_all_completed", increase_tween, "queue_free")
	increase_tween.start()

