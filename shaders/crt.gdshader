shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec2 screen_uv = SCREEN_UV;

	vec2 pixel_size = 1.0 / vec2(textureSize(SCREEN_TEXTURE, 0));

	vec4 behind = texture(SCREEN_TEXTURE, screen_uv);

	float scan_line = smoothstep(0.,1., 0.5+0.5*sin((UV.y)/pixel_size.y*(2.*PI)/6.+1.5));
	behind.rgb *= mix(1.0,0.4,scan_line);

	COLOR = behind;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
