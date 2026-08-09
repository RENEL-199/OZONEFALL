var p = instance_find(obj_player, 0);

if (instance_exists(p))
{
    player_inside = point_in_rectangle(
        p.x,
        p.bbox_bottom,
        x,
        y,
        x + trigger_width,
        y + trigger_height
    );
}
else
{
    player_inside = false;
}

// Control the roof
if (instance_exists(roof))
{
    if (player_inside)
    {
        roof.target_alpha = 0;
    }
    else
    {
        roof.target_alpha = 1;
    }
}