shader_type canvas_item;

uniform vec4 color1: source_color;
uniform vec4 color2: source_color;

void fragment(){
	COLOR.a = mix(0.0, 1.0-0.1*sin(TIME + UV.x*10.0), UV.y);
	COLOR.xyz = mix(color1.xyz, color2.xyz, UV.y);
	//COLOR.a = texture(TEXTURE,UV).a;
}