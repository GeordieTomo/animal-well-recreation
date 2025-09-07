shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE:filter_nearest_mipmap;

uniform vec3 water_tint_colour : source_color;
uniform vec3 water_droplet_colour : source_color;

vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float hash1(float x) {
	// cheap hash returning [0,1)
	return fract(sin(x) * 43758.5453123);
}

float fade(float t) {
	// classic Perlin fade (6t^5 - 15t^4 + 10t^3)
	return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

float grad1(float ix) {
	// gradient in {-1, +1}
	return hash1(ix) * 2.0 - 1.0;
}

float perlin1(float x) {
	// integer lattice points
	float xi = floor(x);
	float xf = x - xi;

	// gradients at xi and xi+1
	float g0 = grad1(xi);
	float g1 = grad1(xi + 1.0);

	// contribution (dot product in 1D is just multiply by offset)
	float n0 = g0 * xf;
	float n1 = g1 * (xf - 1.0);

	// interpolate with smooth fade
	float u = fade(xf);
	return mix(n0, n1, u);
}

float hash(vec2 p) {
    // cheap hash, deterministic for integer lattice
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

vec2 grad(vec2 p) {
    // map hash → gradient in unit circle
    float h = hash(p) * 6.2831853; // [0, 2π)
    return vec2(cos(h), sin(h));
}

float perlin2(vec2 p) {
    // integer lattice points
    vec2 i = floor(p);
    vec2 f = fract(p);

    // gradients
    vec2 g00 = grad(i + vec2(0.0, 0.0));
    vec2 g10 = grad(i + vec2(1.0, 0.0));
    vec2 g01 = grad(i + vec2(0.0, 1.0));
    vec2 g11 = grad(i + vec2(1.0, 1.0));

    // offset vectors
    vec2 d00 = f - vec2(0.0, 0.0);
    vec2 d10 = f - vec2(1.0, 0.0);
    vec2 d01 = f - vec2(0.0, 1.0);
    vec2 d11 = f - vec2(1.0, 1.0);

    // dot products
    float n00 = dot(g00, d00);
    float n10 = dot(g10, d10);
    float n01 = dot(g01, d01);
    float n11 = dot(g11, d11);

    // fade interpolation
    vec2 u = vec2(fade(f.x), fade(f.y));
    float nx0 = mix(n00, n10, u.x);
    float nx1 = mix(n01, n11, u.x);
    float nxy = mix(nx0, nx1, u.y);

    return nxy; // range ~ [-1, 1]
}

void fragment() {
	vec4 behind = vec4(0.);
	
	vec2 pixel_size = 1.0 / vec2(textureSize(SCREEN_TEXTURE, 0));

	vec2 pixel_uv = floor(SCREEN_UV / pixel_size) * pixel_size;
		
	float y_distort = floor(0.5+1.0*sin(TIME*10.+ 640.*pixel_uv.x)) * pixel_size.y;
	
	behind = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.,y_distort));
	behind.a = 1.0;
	
	float speed = -TIME*5.*(0.25+0.75*hash1(pixel_uv.x));
	float water_overlay = step(0.2,perlin2(vec2(pixel_uv.y*10.+speed,TIME/15.)));
	
	behind.rgb = mix(behind.rgb*water_tint_colour,water_droplet_colour,water_overlay*0.5);
	
	COLOR=behind;
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
