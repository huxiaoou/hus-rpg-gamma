shader_type spatial;
render_mode unshaded, cull_disabled; // Makes the border "pure" color regardless of lighting

uniform sampler2D tex : source_color, filter_nearest;
uniform vec4 border_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float border_width : hint_range(0, 10) = 5.0;

void fragment() {
    // Get the size of a single pixel in UV space
    vec2 size = fwidth(UV) * border_width;
    
    // Sample the texture at the current UV and 4 neighbors
    vec4 current_pixel = texture(tex, UV); // [cite: 4]
    float au = texture(tex, UV + vec2(0.0, size.y)).a;
    float ad = texture(tex, UV - vec2(0.0, size.y)).a;
    float al = texture(tex, UV - vec2(size.x, 0.0)).a;
    float ar = texture(tex, UV + vec2(size.x, 0.0)).a;
    
    // Check if any neighbor has an alpha value
    float border = max(max(au, ad), max(al, ar));
    
    // If the current pixel is transparent but a neighbor isn't, draw border
    vec4 final_color = mix(current_pixel, border_color, border - current_pixel.a);
    
    ALBEDO = final_color.rgb; // [cite: 29]
    ALPHA = final_color.a; // [cite: 30]
}