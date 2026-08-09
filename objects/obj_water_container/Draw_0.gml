event_inherited()
var _old_color =
    draw_get_color();

var _old_alpha =
    draw_get_alpha();

var _old_halign =
    draw_get_halign();

var _old_valign =
    draw_get_valign();


if (can_interact)
{
    draw_highlight(
        sprite_index,
        image_index,
        x,
        y
    );
}

draw_self();


if (can_interact)
{
    var _prompt = "";

    if (
        get_selected_empty_bottle_slot()
        != -1
    )
    {
        _prompt =
            "[E] Fill Bottle | " +
            string(current_water) +
            "/" +
            string(maximum_water);
    }
    

    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    draw_set_alpha(1);

    draw_text_transformed(
        x,
        bbox_top - 4,
        _prompt,
        prompt_scale,
        prompt_scale,
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
    draw_set_alpha(1);

    draw_text_transformed(
        x,
        bbox_top - 22,
        message,
        prompt_scale,
        prompt_scale,
        0
    );
}


draw_set_color(_old_color);
draw_set_alpha(_old_alpha);
draw_set_halign(_old_halign);
draw_set_valign(_old_valign);