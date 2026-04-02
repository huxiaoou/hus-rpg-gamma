shader_type spatial;

uniform sampler2D hex_texture : source_color;
uniform vec4 side_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	// Check if the face normal is pointing Up or Down
	// NORMAL.y is ~1.0 for the top cap and ~-1.0 for the bottom cap
	if (abs(NORMAL.y) > 0.5) {
		// Use the vertex position (X and Z) to create a flat UV projection
		// VERTEX.xz usually ranges from -0.5 to 0.5 for a default cylinder
		// We add 0.5 to map that range to 0.0 - 1.0 for the texture
		vec2 cap_uv = VERTEX.xz + 0.5;
		
		vec4 tex = texture(hex_texture, cap_uv);
		
		ALBEDO = tex.rgb;
		ALPHA = tex.a;
	} else {
		// This applies to the 6 vertical sides of your cylinder
		ALBEDO = side_color.rgb;
		ALPHA = 1.0;
	}
}