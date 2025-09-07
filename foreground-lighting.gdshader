shader_type canvas_item;

uniform float time_speed : hint_range(0.0, 5.0) = 1.0;
uniform float scale : hint_range(0.1, 10.0) = 3.0;
uniform vec3 color1 : source_color = vec3(0.0, 0.0, 0.0);
uniform vec3 color2 : source_color = vec3(1.0, 1.0, 1.0);

vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) + 0.5;
}

float layered_noise(vec2 uv) {
	float val = 0.;
	uv*=1.;
	float amp = 0.4;
	for (int i = 0; i < 5; i++) {
		val += noise(uv + vec2(TIME *time_speed* (0.1 + 0.05 * float(i)), TIME *time_speed* (0.1 + 0.05 * float(i)))) * amp;
		amp = amp * 0.5;
		uv *= 1.2;
		uv += vec2(cos(uv.y * 2. + TIME / amp * 0.1 * time_speed), sin(uv.x* 2.+ TIME/ amp * 0.1 * time_speed));
		uv = vec2(noise(uv), noise(uv));
	}
	return val;
}

vec2 pixelate(vec2 uv, vec2 pixel_size) {
	return floor(uv / pixel_size) * pixel_size;
}

void fragment() {
	
    vec4 tex_colour = texture(TEXTURE, UV);
    vec2 pixel_size = 1.0 / vec2(textureSize(TEXTURE, 0));
	
	vec2 pixel_uv = pixelate(UV, pixel_size);

	vec4 above_colour = texture(TEXTURE, UV + vec2(0.0,-pixel_size.y));
	vec4 right_colour = texture(TEXTURE, UV + vec2(pixel_size.x,0.0));
	vec4 left_colour = texture(TEXTURE, UV + vec2(-pixel_size.x,0.0));
	vec4 down_colour = texture(TEXTURE, UV + vec2(0.0,-pixel_size.y));
	
	vec2 noise_offset = (-0.5 + noise(UV*100.)) * pixel_size*3.;
	vec4 above_check = texture(TEXTURE, UV - noise_offset + vec2(8.*pixel_size.x,-8.*pixel_size.y));
	vec4 right_check = texture(TEXTURE, UV - noise_offset + vec2(8.*pixel_size.x,8.*pixel_size.y));
	vec4 left_check = texture(TEXTURE, UV - noise_offset + vec2(-8.*pixel_size.x,-8.*pixel_size.y));
	vec4 down_check = texture(TEXTURE, UV - noise_offset + vec2(-8.*pixel_size.x,8.*pixel_size.y));
	
	if ((above_colour.a * down_colour.a * left_colour.a * right_colour.a == 0.0) && tex_colour.a == 1.) {
		//float lum = dot(tex_colour.rgb, vec3(0.2126, 0.7152, 0.0722));
		tex_colour.rgb *= 1.5;
	}
	else if ((above_check.a * right_check.a * left_check.a * down_check.a != 0.0) && tex_colour.a == 1.) {
		tex_colour.rgb = vec3(0.);
	}
	else {
		// 2D noise that evolves over time
	    float n = layered_noise(pixel_uv);
		float s1 = 0.2 + 0.2 * step(0.4,n) + 0.2 * step(0.5,n) + 0.2 * step(0.6,n);
		tex_colour.rgb *= vec3(s1);
	}
	
    COLOR = tex_colour;
}