shader_type canvas_item;
render_mode blend_mix;

uniform vec4 ColorParameter : source_color;
uniform vec4 ColorParameter2 : source_color;
uniform sampler2D Texture2DParameter : repeat_enable;

uniform float scroll_speed = 0.3;

void fragment() {
	
	vec2 uv = UV * vec2(1.0, 0.1) * vec2(2.0*sin(1.0*UV.x), 2.0*sin(UV.x)) + vec2(TIME * scroll_speed, 0.0);
	vec4 tex = texture(Texture2DParameter, uv);
	vec4 color = mix(ColorParameter, ColorParameter2, tex);
	
	COLOR.rgb = color.xyz;
	

}
