shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;
uniform sampler2D noise_texture: filter_nearest, repeat_enable;

uniform vec2 speed = vec2(0.1, 0.1);
uniform float distortion = 1.0;

uniform float darkness = 0.85; // 1.0 = original brightness, lower = darker
uniform vec3 warmth = vec3(1.1, 1.5, 0.6); // Reddish tint

void fragment() {
	vec2 uv = UV + speed * TIME;
	vec2 noise = 2.0 * texture(noise_texture, uv).rg - vec2(1.0);

	vec4 tex_color = texture(TEXTURE, UV + noise * distortion);
	vec4 screen_color = texture(screen_texture, SCREEN_UV + noise * distortion);
	vec4 mixed_color = mix(tex_color, tex_color * screen_color, 0.3);

	// Apply warmth and darkness
	mixed_color.rgb *= warmth;
	mixed_color.rgb *= darkness;

	COLOR = mixed_color;
}
