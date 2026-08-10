draw_self();

if (can_interact)
{
    var _prompt =
        "[E] Water Container";

    var _slot =
        farming_get_selected_slot();

    if (
        !is_undefined(_slot) &&
        _slot.item_id ==
        ItemID.Watering_Can
    )
    {
        _slot.state =
            inventory_restore_item_state(
                ItemID.Watering_Can,
                _slot.state
            );

        _prompt =
            "[E] Refill  " +
            string(
                _slot.state.current_water
            ) +
            "/500";
    }

    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    draw_set_alpha(1);

    draw_text_transformed(
        x,
        bbox_top - 5,
        _prompt,
        0.55,
        0.55,
        0
    );
}

if (
    message_timer > 0 &&
    message != ""
)
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);

    draw_set_alpha(
        min(
            1,
            message_timer / 15
        )
    );

    draw_text_transformed(
        x,
        bbox_top - 18,
        message,
        0.55,
        0.55,
        0
    );
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);