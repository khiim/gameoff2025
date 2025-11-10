shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float alpha : hint_range(0.0, 1.0) = 1.0;
uniform vec4 edge_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float edge_width : hint_range(0.01, 0.5) = 0.1;
uniform float glow_intensity : hint_range(0.0, 5.0) = 1.0;
uniform float pulse_speed : hint_range(0.0, 10.0) = 3.0;
uniform vec2 direction = vec2(1.0, 0.0);
uniform float radius = 50.0;

void fragment() {
	vec2 uv = (UV - vec2(0.5)) * 10.0;
	float dist = length(uv);

	float norm = dist;

	float outer_edge = 1.0;
	float inner_edge = 1.0 - edge_width;

	float edge_mask = smoothstep(inner_edge, outer_edge, norm) - smoothstep(outer_edge, outer_edge + 0.01, norm);
	
	vec2 dir = normalize(direction);
	float hemi = dot(normalize(uv), dir);
	float hemisphere_mask = smoothstep(-0.2, 0.15, hemi);

	float fade = (1.0 - progress * 0.7);

	vec3 final_color = edge_color.rgb;
	float final_alpha = edge_mask * alpha * hemisphere_mask * fade;

	COLOR = vec4(edge_color.rgb, final_alpha);
}
