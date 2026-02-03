shader_type canvas_item;

uniform float treshold = 1.0;
uniform float speed = 25.0;
uniform int fighter_id;

void fragment() {
	if (fighter_id == 1) {
		COLOR.rgb = vec3(0.93, 0.25, 0.14);	
	} else {
		COLOR.rgb = vec3(0.33, 0.51, 0.25);	
	}
	
	if (sin(TIME * speed) > treshold) {
		COLOR.rgb = vec3(1.0, 1.0, 1.0);
	}
}