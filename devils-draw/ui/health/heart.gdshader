shader_type canvas_item;

uniform float height = 0.4;
uniform float burning = 0.0;
uniform sampler2D fire : repeat_enable;
uniform vec4 color1 : source_color;
uniform vec4 color2 : source_color;

void fragment() {
	vec4 color = texture(TEXTURE, UV);

	// Fluid behavior
	float luminance = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 gray = vec3(luminance);
	float mask = step(height + sin(TIME*3.0 + UV.x)/80.0, UV.y);

	// Burning
	vec2 fire_uv = UV*vec2(0.4, 1.0) + vec2(0.0, TIME*0.4);
	vec4 fire_tex = texture(fire, fire_uv);
	fire_tex = mix(color1, color2, fire_tex) * float(burning);

	vec3 final_color = mix(gray, color.xyz + fire_tex.xyz, mask);

	//final_color -= fire_tex.xyz * vec3(float(burning));

	COLOR = vec4(final_color, color.a);
}
