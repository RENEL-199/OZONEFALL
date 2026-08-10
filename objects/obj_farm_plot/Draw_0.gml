if (
    variable_global_exists(
        "farm_target"
    ) &&
    global.farm_target == id
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