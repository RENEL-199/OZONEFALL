if (can_open)
{
    draw_highlight(
        sprite_index,
        image_index,
        x,
        y
    );

    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);



    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
else
{
    draw_self();
}