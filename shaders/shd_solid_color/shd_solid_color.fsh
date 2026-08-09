varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 solid_color;

void main()
{
    vec4 tex = texture2D(gm_BaseTexture, v_vTexcoord);

    if (tex.a <= 0.0)
    {
        discard;
    }

    gl_FragColor = vec4(solid_color.rgb, tex.a * solid_color.a);
}