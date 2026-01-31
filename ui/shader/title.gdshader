shader_type canvas_item;

uniform float offset : hint_range(0.0, 2.0);
const float amplitude = 50.0;
const float frequency  = 8.0;
const float speed = 3.0;

void vertex() {
    float wave = sin((TIME + 2.0 * offset) * speed);
    VERTEX.y += wave * amplitude;
}