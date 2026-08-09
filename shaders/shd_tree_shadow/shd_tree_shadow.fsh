varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying float v_shadow_distance;

uniform vec4 u_shadow_colour;

void main()
{
    vec4 texture_colour =
        texture2D(
            gm_BaseTexture,
            v_vTexcoord
        );

    if (texture_colour.a <= 0.01)
    {
        discard;
    }

    float distance_fade =
        mix(
            1.0,
            0.58,
            v_shadow_distance
        );

    float shadow_alpha =
        texture_colour.a *
        v_vColour.a *
        u_shadow_colour.a *
        distance_fade;

    gl_FragColor =
        vec4(
            u_shadow_colour.rgb,
            shadow_alpha
        );
}