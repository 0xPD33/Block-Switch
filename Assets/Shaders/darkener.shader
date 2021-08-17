shader_type canvas_item;

uniform float current_value;
uniform float start_value = 0.6;
uniform float end_value = 0.9;

uniform float loop_time = 1.5;

void fragment(){
	COLOR.rgba = vec4(0.0, 0.0, 0.0, current_value);
}