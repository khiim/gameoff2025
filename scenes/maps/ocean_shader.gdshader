shader_type canvas_item;

uniform float wobble_speed;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 offset = vec2(sin(UV.x * wobble_speed + TIME * 0.5), cos(UV.y * wobble_speed + TIME * 0.5)) * 0.01;
	
	COLOR = texture(TEXTURE, UV + offset * 0.2);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
