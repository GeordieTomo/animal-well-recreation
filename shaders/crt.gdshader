shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec2 screen_uv = SCREEN_UV;

	vec2 pixel_size = 1.0 / vec2(textureSize(SCREEN_TEXTURE, 0));

	vec4 behind = texture(SCREEN_TEXTURE, screen_uv);

	float scan_line = 0.5 * step(4., mod(UV.y / pixel_size.y-1.,6.)) + 0.5 * step(2., mod(UV.y / pixel_size.y-2.,6.)) ;
	
	vec4 colour = vec4(0.);
	for (int x=0;x<3;x++){
		colour += 1./6. * texture(SCREEN_TEXTURE, screen_uv+vec2(pixel_size.x*float(x),0.));
		colour += 1./6. * texture(SCREEN_TEXTURE, screen_uv+vec2(-pixel_size.x*float(x),0.));
	}
	//for (int y =1; y<3; y++){
		//colour += 1./8. * texture(SCREEN_TEXTURE, screen_uv+vec2(0.,pixel_size.y*float(y)));
		//colour += 1./8. * texture(SCREEN_TEXTURE, screen_uv+vec2(0.,-pixel_size.y*float(y)));
	//}
	colour.rgb *= 1. - (0.5*scan_line-0.5*(colour.r*0.3+colour.g*0.59+colour.b*0.11));
	
	COLOR = colour;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
