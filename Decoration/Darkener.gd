extends Sprite

onready var shader = get_material()
onready var shader_loop_time = shader.get_shader_param("loop_time")


func _ready():
	loop()


func loop():
	var loop_tween = Tween.new()
	loop_tween.name = "LoopTween"
	loop_tween.repeat = true
	loop_tween.interpolate_property(shader, "shader_param/current_value", shader.get_shader_param("start_value"),\
									shader.get_shader_param("end_value"), shader.get_shader_param("loop_time"),\
									Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	loop_tween.interpolate_property(shader, "shader_param/current_value", shader.get_shader_param("end_value"),\
									shader.get_shader_param("start_value"), shader.get_shader_param("loop_time"),\
									Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_tree().current_scene.add_child(loop_tween)
	loop_tween.start()
	yield(loop_tween, "tween_completed")
	loop_tween.queue_free()

