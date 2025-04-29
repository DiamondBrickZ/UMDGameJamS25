shader_type canvas_item;

uniform float height = 0.4;

void fragment() {
	vec4 color = texture(TEXTURE, UV);

	float luminance = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 gray = vec3(luminance);

	float mask = step(height + sin(TIME*3.0 + UV.x)/80.0, UV.y);

	vec3 final_color = mix(gray, color.xyz, mask);
	COLOR = vec4(final_color, color.a);
}
