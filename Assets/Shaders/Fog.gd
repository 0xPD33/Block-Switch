extends Sprite

export (float) var increase_alpha_anim_duration = 1.2
export (float) var increased_alpha_multiplier_value = 1.5

export (float) var decrease_alpha_anim_duration = 0.6

onready var shader = get_material()
onready var shader_alpha_multiplier = shader.get_shader_param("alpha_mult")


func increase_alpha():
	var increase_tween = Tween.new()
	increase_tween.name = "IncreaseTween"
	increase_tween.interpolate_property(shader, "shader_param/alpha_mult", shader_alpha_multiplier, increased_alpha_multiplier_value, increase_alpha_anim_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_tree().current_scene.add_child(increase_tween)
	increase_tween.start()
	yield(increase_tween, "tween_completed")
	increase_tween.queue_free()


func decrease_alpha():
	var decrease_tween = Tween.new()
	decrease_tween.name = "DecreaseTween"
	decrease_tween.interpolate_property(shader, "shader_param/alpha_mult", increased_alpha_multiplier_value, 0.5, decrease_alpha_anim_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_tree().current_scene.add_child(decrease_tween)
	decrease_tween.start()
	yield(decrease_tween, "tween_completed")
	decrease_tween.queue_free()

