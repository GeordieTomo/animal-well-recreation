shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;


void fragment() {
	vec2 screen_uv = SCREEN_UV;
	vec2 pixel_size = 1.0 / vec2(textureSize(SCREEN_TEXTURE, 0));

	vec4 blur_behind = texture(SCREEN_TEXTURE, screen_uv, .7);
	vec4 normal_behind = texture(SCREEN_TEXTURE, screen_uv, 0.);

	float x_scan = 0.5 + 0.5 * sin((UV.x/pixel_size.x)*2.*PI/6.-1.5);
	float y_scan = 0.5 + 0.5 * sin((UV.y/pixel_size.y)*2.*PI/6.-1.5);
	float res = x_scan * y_scan;

	vec4 final_blur = mix(blur_behind, normal_behind,res/2.);

	COLOR = blur_behind;

}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
