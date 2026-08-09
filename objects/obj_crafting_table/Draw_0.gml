/// obj_crafting_table — Draw Event

if (!sprite_exists(sprite_index))
{
    exit;
}

if (can_open)
{
    draw_highlight(
        sprite_index,
        image_index,
        x,
        y
    );

    shader_reset();
}

// Always draw the actual crafting-table sprite.
draw_self();

shader_reset();

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);