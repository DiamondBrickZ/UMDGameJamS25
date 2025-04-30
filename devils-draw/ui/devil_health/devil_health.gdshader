shader_type canvas_item;
render_mode blend_mix;

uniform vec4 ColorParameter : source_color;
uniform vec4 ColorParameter2 : source_color;
uniform sampler2D Texture2DParameter : repeat_enable;

uniform float scroll_speed = 0.3;
uniform float amount : hint_range(0.0, 1.0) = 1.0;
uniform float start = 0.0;
uniform float end = 1.0;

void fragment() {

	vec2 uv = UV * vec2(1.0, 0.1) * vec2(2.0*sin(1.0*UV.x), 2.0*sin(UV.x)) + vec2(TIME * scroll_speed, 0.0);
	vec4 tex = texture(Texture2DParameter, uv);
	vec4 color = mix(ColorParameter, ColorParameter2, tex);

	COLOR.rgb = color.xyz;

	float threshold = start + (amount - 0.0) * (end - start)/(1.0-0.0) -1.0;
	float final = threshold + 0.004*sin(UV.y*TIME/15.0 + 3.0*TIME);
	COLOR.a = step(-UV.x, final) * COLOR.a;

}
