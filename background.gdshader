shader_type canvas_item;

uniform float time_speed : hint_range(0.0, 5.0) = 1.0;
uniform float scale : hint_range(0.1, 10.0) = 3.0;
uniform vec3 color1 : source_color = vec3(0.0, 0.0, 0.0);
uniform vec3 color2 : source_color = vec3(1.0, 1.0, 1.0);

vec2 pixelate(vec2 uv, vec2 pixel_size) {
	return floor(uv / pixel_size) * pixel_size;
}

void fragment() {
	
	vec2 pixel_size = 1.0 / vec2(textureSize(TEXTURE, 0));
	
	vec2 pixel_uv = pixelate(UV, pixel_size);
	
	pixel_uv += vec2(4.*pixel_size.x*sin(TIME*3.+pixel_uv.y*100.),4.*pixel_size.y*sin(TIME*1.+pixel_uv.x*100.));
	
	vec4 tex_colour = texture(TEXTURE, pixel_uv);

	COLOR = tex_colour / 1.5;
}