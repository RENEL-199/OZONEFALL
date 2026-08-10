var _harvest_target =
    crop_get_harvest_target();

if (
    is_mature &&
    _harvest_target == id
)
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

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);