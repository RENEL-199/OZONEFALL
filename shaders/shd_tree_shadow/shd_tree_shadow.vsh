attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying float v_shadow_distance;

uniform vec2 u_sprite_bounds;
uniform vec2 u_shadow_direction;

void main()
{
    vec3 vertex_position =
        in_Position;

    float sprite_top =
        u_sprite_bounds.x;

    float sprite_bottom =
        u_sprite_bounds.y;

    float sprite_height =
        max(
            sprite_bottom -
            sprite_top,
            1.0
        );

    float height_weight =
        clamp(
            (
                sprite_bottom -
                in_Position.y
            ) /
            sprite_height,
            0.0,
            1.0
        );

    float projection_weight =
        height_weight *
        height_weight *
        (
            3.0 -
            2.0 *
            height_weight
        );

    vertex_position.x +=
        projection_weight *
        sprite_height *
        u_shadow_direction.x;

    vertex_position.y =
        sprite_bottom +
        projection_weight *
        sprite_height *
        u_shadow_direction.y;

    gl_Position =
        gm_Matrices[
            MATRIX_WORLD_VIEW_PROJECTION
        ] *
        vec4(
            vertex_position,
            1.0
        );

    v_vTexcoord =
        in_TextureCoord;

    v_vColour =
        in_Colour;

    v_shadow_distance =
        projection_weight;
}