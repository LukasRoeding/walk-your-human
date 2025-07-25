shader_type canvas_item;

uniform float wave_amplitude = 3.0;
uniform float wave_frequency = 8.0;
uniform float wave_speed = 2.0;

void fragment() {
    // Create wave offset in pixels (based on screen resolution)
	float offset_px = sin(UV.x * wave_frequency + TIME * wave_speed) * wave_amplitude;
    // Convert that offset to UV space (how far that is in normalized coords)
    float offset_uv = offset_px * SCREEN_PIXEL_SIZE.y;

    COLOR = texture(TEXTURE, vec2(UV.x, UV.y + offset_uv));
}
