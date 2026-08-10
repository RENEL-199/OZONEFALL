if (
    !initialized ||
    !sprite_exists(sprite_index)
)
{
    exit;
}

var _highlight = false;

if (
    variable_global_exists(
        "farm_target"
    )
)
{
    _highlight =
        global.farm_target == id &&
        is_mature;
}

if (_highlight)
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