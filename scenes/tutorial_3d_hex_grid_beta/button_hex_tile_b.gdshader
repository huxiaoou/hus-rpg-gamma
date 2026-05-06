shader_type canvas_item;

uniform bool enabled = false;
uniform vec4 tint: source_color = vec4(1.0, 1.0, 1.0, 0.0);
uniform vec4 shine_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float border_width : hint_range(0.0, 0.1) = 0.040;
uniform float shine_size : hint_range(0.0, 0.5) = 0.2;
uniform float speed : hint_range(0.0, 5.0) = 0.3;


void fragment() {
    vec2 uv = UV;
    
	// Check if we are within the border area
    float left = step(uv.x, border_width);
    float right = step(1.0 - border_width, uv.x);
    float top = step(uv.y, border_width);
    float bottom = step(1.0 - border_width, uv.y);

    // 1 if is in border scope else 0
    float is_border = max(max(left, right), max(top, bottom));
    
    if (enabled) {
        if (is_border > 0.0) {
             float progress = fract(TIME * speed);

            // Map UV to a 1D perimeter value
            float perimeter_pos = 0.0;
            if (top > 0.0 && left < 1.0) perimeter_pos = uv.x * 0.25; // Top
            else if (right > 0.0) perimeter_pos = 0.25 + (uv.y - border_width) / (1.0 - border_width) * 0.25; // Right
            else if (bottom > 0.0) perimeter_pos = 0.5 + (1.0 - uv.x - border_width) / ( 1.0 - border_width) * 0.25; // Bottom
            else if (left > 0.0) perimeter_pos = 0.75 + (1.0 - uv.y - border_width) / (1.0 - border_width) * 0.25; // Left

            // Calculate the shine intensity based on distance to the progress point
            float dist = abs(perimeter_pos - progress);

            // Handle the wrap-around case (1.0 back to 0.0)
            dist = min(dist, 1.0 - dist);
            float shine_mask = 1.0 - smoothstep(0.0, shine_size, dist);

            // Mix the colors
            COLOR = mix(COLOR, shine_color, shine_mask);
        }
    }
}

