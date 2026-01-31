shader_type canvas_item;

uniform vec2 direction = vec2(1.0, -1.0);
uniform float speed = 0.12;

void fragment() {
	COLOR = texture(TEXTURE, fract(UV + (direction * TIME * speed)));
	COLOR.xyz += vec3(
		sin(TIME + 1.0) / 2.0, 
		cos(TIME + 1.0) / 2.0, 
		-cos(TIME + 1.0) / 2.0
	);
}