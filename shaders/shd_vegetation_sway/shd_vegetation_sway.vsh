attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// x = time
// y = sway strength
// z = sway speed
uniform vec3 u_sway_data;

// x = sprite top
// y = sprite bottom
// z = unique position-based phase
uniform vec3 u_instance_data;

void main()
{
    vec3 vertex_position =
        in_Position;

    float sprite_height =
        max(
            u_instance_data.y -
            u_instance_data.x,
            1.0
        );

    // 0 at the bottom and 1 at the top.
    float height_weight =
        clamp(
            (
                u_instance_data.y -
                in_Position.y
            ) /
            sprite_height,
            0.0,
            1.0
        );

    // Keeps the base stable while bending the top.
    height_weight *=
        height_weight;

    float primary_wave =
        sin(
            u_sway_data.x *
            u_sway_data.z +
            u_instance_data.z
        );

    float secondary_wave =
        sin(
            u_sway_data.x *
            u_sway_data.z *
            0.53 +
            u_instance_data.z *
            1.73 +
            height_weight *
            1.5
        ) * 0.25;

    vertex_position.x +=
        (
            primary_wave +
            secondary_wave
        ) *
        u_sway_data.y *
        height_weight;

    vec4 object_space_position =
        vec4(
            vertex_position,
            1.0
        );

    gl_Position =
        gm_Matrices[
            MATRIX_WORLD_VIEW_PROJECTION
        ] *
        object_space_position;

    v_vColour =
        in_Colour;

    v_vTexcoord =
        in_TextureCoord;
}