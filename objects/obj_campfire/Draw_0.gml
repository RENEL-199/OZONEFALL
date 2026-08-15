if (lit)
{
    draw_set_color(
        make_color_rgb(
            105,
            55,
            28
        )
    );

    draw_set_alpha(
        0.18 *
        light_flicker
    );

    draw_ellipse(
        x - 15,
        bbox_bottom - 7,
        x + 15,
        bbox_bottom + 4,
        false
    );
}


draw_set_alpha(1);
draw_set_color(c_white);

draw_self();


// Lightweight procedural embers
if (lit)
{
    var _time =
        current_time / 1000;

    for (
        var _i = 0;
        _i < 4;
        _i++
    )
    {
        var _life =
            frac(
                _time *
                (
                    0.8 +
                    _i * 0.11
                ) +
                _i * 0.27
            );

        var _ember_x =
            x +
            sin(
                _time * 4 +
                _i * 2.1
            ) *
            (
                2 +
                _life * 4
            );

        var _ember_y =
            bbox_bottom -
            10 -
            _life * 22;

        draw_set_alpha(
            (1 - _life) * 0.85
        );

        if (_i mod 2 == 0)
        {
            draw_set_color(
                make_color_rgb(
                    255,
                    214,
                    92
                )
            );
        }
        else
        {
            draw_set_color(
                make_color_rgb(
                    255,
                    112,
                    48
                )
            );
        }

        draw_rectangle(
            _ember_x,
            _ember_y,
            _ember_x + 1,
            _ember_y + 1,
            false
        );
    }
}


// Interaction prompt
if (can_interact)
{
    var _prompt =
        "[E]" +
        string(fuel_cost) +
        "";

    if (lit)
    {
        _prompt = "[E] Cook";
    }

    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    draw_set_alpha(1);

    draw_text_transformed(
        x,
        bbox_top - 7,
        _prompt,
        0.55,
        0.55,
        0
    );
}


// Small cooking progress above the campfire
if (
    is_cooking &&
    variable_global_exists("game_time")
)
{
    var _progress =
        crafting_get_progress(
            cook_start_timestamp,
            cook_finish_timestamp
        );

    var _bar_width = 34;
    var _bar_height = 3;

    var _bar_x =
        x -
        _bar_width * 0.5;

    var _bar_y =
        bbox_top - 3;

    draw_set_alpha(0.8);
    draw_set_color(c_black);

    draw_rectangle(
        _bar_x - 1,
        _bar_y - 1,
        _bar_x + _bar_width + 1,
        _bar_y + _bar_height + 1,
        false
    );

    draw_set_color(
        cooking_ui_progress_color
    );

    draw_rectangle(
        _bar_x,
        _bar_y,
        _bar_x +
        _bar_width * _progress,
        _bar_y + _bar_height,
        false
    );
}


// World message
if (
    message_timer > 0 &&
    message != ""
)
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(
        cooking_ui_text_color
    );

    draw_set_alpha(
        min(
            1,
            message_timer / 20
        )
    );

    draw_text_transformed(
        x,
        bbox_top - 22,
        message,
        0.50,
        0.50,
        0
    );
}


draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);