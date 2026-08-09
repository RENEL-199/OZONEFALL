/// obj_dead_narra — Draw Event

var _shake_x = 0;

if (hit_shake_timer > 0)
{
    _shake_x =
        choose(
            -hit_shake_amount,
            hit_shake_amount
        );
}


// ====================================================================
// WHITE HIT FLASH
// ====================================================================

if (hit_flash_timer > 0)
{
    shader_set(shd_solid_color);

    var _uniform =
        shader_get_uniform(
            shd_solid_color,
            "solid_color"
        );

    shader_set_uniform_f(
        _uniform,
        1,
        1,
        1,
        image_alpha
    );

    draw_sprite_ext(
        sprite_index,
        image_index,
        x + _shake_x,
        y,
        image_xscale,
        image_yscale,
        image_angle,
        c_white,
        image_alpha
    );

    shader_reset();
}
else
{
    draw_sprite_ext(
        sprite_index,
        image_index,
        x + _shake_x,
        y,
        image_xscale,
        image_yscale,
        image_angle,
        image_blend,
        image_alpha
    );
}


// ====================================================================
// CHOPPING PROMPT
// ====================================================================




// ====================================================================
// RESET DRAW STATE
// ====================================================================

shader_reset();

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);