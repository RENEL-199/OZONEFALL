/// obj_pickable_parent — Draw Event

// A dynamic pickup may exist briefly before setup_item() is called.
if (
    item_id == ItemID.None ||
    !sprite_exists(sprite_index)
)
{
    exit;
}


// ====================================================================
// PICKUP SPRITE
// ====================================================================

if (can_pickup)
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


// ====================================================================
// PICKUP PROMPT
// ====================================================================




// ====================================================================
// RESET DRAW STATE
// ====================================================================

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);