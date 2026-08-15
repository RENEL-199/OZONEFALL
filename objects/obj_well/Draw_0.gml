if (can_interact)
{
    draw_highlight(
        sprite_index,
        image_index,
        x,
        y
    );
}
else
{
    draw_self();
}


if (can_interact)
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);

    draw_set_color(c_white);
    draw_set_alpha(1);

    draw_text_transformed(
        x,
        bbox_top - 25,
        string(current_water) +
        "/" +
        string(maximum_water),
        prompt_scale,
        prompt_scale,
        0
    );
}


draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_color(c_white);
draw_set_alpha(1);