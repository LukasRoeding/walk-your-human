shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;

uniform sampler2D noise_texture: filter_nearest, repeat_enable;

uniform vec2 speed = vec2(0.001, 0.001);

uniform float distortion = 0.01;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	vec2 uv = UV + speed * TIME;

	vec2 noise = 2.0 * texture(noise_texture, uv).rg - vec2(1.0);
	// Called for every pixel the material is visible on.
	COLOR = texture(TEXTURE, UV);
	// Reduce x distortion by multiplying noise.x by a smaller factor
	vec2 reduced_noise = vec2(noise.x * 0.3, noise.y * 0.8);
	vec4 screen_color = texture(screen_texture, SCREEN_UV + reduced_noise * distortion);

	COLOR = mix(COLOR, COLOR * screen_color, 1); // Adjust 0.5 to control strength

}
