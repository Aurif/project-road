shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
    vec4 color = texture(screen_texture, SCREEN_UV);
    
    // Deuteranopia simulation matrix (RGB)
    // Source: commonly used LMS-based approximations
    mat3 deutan = mat3(
    vec3(0.625, 0.375, 0.000),
    vec3(0.700, 0.300, 0.000),
    vec3(0.000, 0.300, 0.700)
    );
    

    
    vec3 simulated = deutan * color.rgb;
    
    COLOR = vec4(simulated, color.a);
}
