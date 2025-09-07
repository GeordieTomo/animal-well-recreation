shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE:  filter_nearest_mipmap;

uniform vec3 water_tint_colour : source_color;

uniform float y_level = 180.0;

float pixelate(float raw_value, float pixel_size) {
	float new_val = floor(raw_value / pixel_size) * pixel_size;
	return new_val;
}

void fragment() {
	vec2 screen_uv = SCREEN_UV;

	vec2 pixel_size = 1.0 / vec2(textureSize(SCREEN_TEXTURE, 0));

	vec2 pixel_uv = floor(UV / pixel_size);

	vec4 behind = vec4(0.,0.,0.,1.);
	
	if (pixel_uv.y > y_level) {
		
		float y_dist = 2.*pixel_size.y*(y_level-pixel_uv.y);
		
		float x_distort = pixelate(5.*y_dist*y_dist * sin(pixel_uv.y + TIME)/25.,pixel_size.x);
		
		behind = texture(SCREEN_TEXTURE, UV + vec2(x_distort,y_dist));
		behind.rgb *= water_tint_colour;
	}
	else {
		behind = vec4(0.);
	}
	
	COLOR = behind;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
