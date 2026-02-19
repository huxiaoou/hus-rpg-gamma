shader_type canvas_item;

uniform vec2 stretch_scale = vec2(2.0, 2.0);
uniform vec2 shift_speed = vec2(1.0, 1.0);


void vertex() {
	// Called for every vertex the material is visible on.
    UV = UV * stretch_scale;
}

void fragment() {
	// Called for every pixel the material is visible on.
    vec2 shifted_uv = UV - TIME * shift_speed;
    COLOR = texture(TEXTURE, shifted_uv);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
