shader_type spatial;

uniform float height_scale = 0.5;
uniform float speed = 0.5;
uniform float amount = 1.0;
uniform float min_height = 0.0;
uniform float swirl_scale = 1.0;
uniform float emission_strength = 1.0;
uniform sampler2D displacement;

uniform vec3 base_color: source_color;

varying vec2 tex_position;

void vertex() {
	tex_position = VERTEX.xz / 2.0 + 0.5 + vec2(TIME * speed, 0.0);
	float height = texture(displacement, tex_position).x;
	
	float influence = smoothstep(min_height, min_height + 0.1, VERTEX.y);
	
	VERTEX.y += (amount + height * height_scale) * influence;
}

void fragment() {
    vec2 uv = UV * swirl_scale; // Scale the swirly pattern
    float swirl = sin(uv.x + uv.y + TIME * speed * 4.0) * 0.5 + 0.5; // Swirly effect
    
    // Color gradient between purple and blue
    //vec3 base_color = mix(vec3(0.3, 0.0, 0.6), vec3(0.0, 0.4, 1.0), swirl);
    
    // Emission effect
    EMISSION = base_color * emission_strength * swirl;
    
    ALBEDO = base_color;
}