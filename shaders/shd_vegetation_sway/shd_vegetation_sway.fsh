varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// RGB = flash color
// A = flash strength
uniform vec4 u_flash;

void main()
{
    vec4 texture_color =
        texture2D(
            gm_BaseTexture,
            v_vTexcoord
        );

    vec3 final_color =
        mix(
            texture_color.rgb,
            u_flash.rgb,
            u_flash.a
        );

    gl_FragColor =
        vec4(
            final_color,
            texture_color.a
        ) *
        v_vColour;
}