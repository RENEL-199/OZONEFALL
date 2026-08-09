/// obj_vegetation_parent — Draw Event

var _show_highlight = false;

if (
    variable_instance_exists(
        id,
        "can_pickup"
    )
)
{
    if (can_pickup)
    {
        _show_highlight = true;
    }
}

if (
    variable_instance_exists(
        id,
        "can_harvest"
    )
)
{
    if (can_harvest)
    {
        _show_highlight = true;
    }
}

// Draw swaying white copies as the outline.
// Do not use the old draw_highlight() here.
if (_show_highlight)
{
    vegetation_sway_draw(
        id,
        sway_strength,
        sway_speed,
        1,
        -1
    );

    vegetation_sway_draw(
        id,
        sway_strength,
        sway_speed,
        1,
        1
    );
}

// Draw the normal sprite exactly once.
vegetation_sway_draw(
    id,
    sway_strength,
    sway_speed,
    0,
    0
);

shader_reset();

draw_set_color(c_white);
draw_set_alpha(1);