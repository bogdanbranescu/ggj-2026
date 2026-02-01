shader_type canvas_item;

uniform float treshold = 1.0;
uniform float speed = 25.0;
uniform int fighter_id;

void fragment() {
	if (fighter_id == 1) {
		COLOR.rgb = vec3(0.0, 0.0, 0.3);	
	} else {
		COLOR.rgb = vec3(0.9, 0.0, 0.0);	
	}
	
	if (sin(TIME * speed) > treshold) {
		COLOR.rgb = vec3(0.8, 0.8, 0.8);
	}
}