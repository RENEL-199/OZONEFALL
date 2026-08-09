/// obj_harvestable_vegetation_parent — Draw Event

if (sprite_index == -1)
{
    exit;
}

if (can_harvest)
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