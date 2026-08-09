varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 u_night_color;
uniform float u_dither_strength;

void main()
{
    vec4 mask =
        texture2D(
            gm_BaseTexture,
            v_vTexcoord
        );

    float darkness = mask.r;

    float pattern =
        mod(
            floor(gl_FragCoord.x) +
            floor(gl_FragCoord.y) * 2.0,
            4.0
        );

    pattern =
        pattern / 3.0 - 0.5;

    darkness = clamp(
        darkness +
        pattern *
        u_dither_strength,
        0.0,
        1.0
    );

    gl_FragColor = vec4(
        u_night_color,
        darkness * v_vColour.a
    );
}