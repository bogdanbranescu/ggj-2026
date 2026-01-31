shader_type canvas_item;

uniform float treshold = 1.0;
uniform float speed = 30.0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (sin(TIME * speed) > treshold) {
		COLOR.rgb = vec3(0.8, 0.8, 0.8);
	}
}