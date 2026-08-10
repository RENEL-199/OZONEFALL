event_inherited();

var _pulse = 0;

if (completion_pulse_timer > 0)
{
    _pulse =
        abs(
            sin(
                completion_pulse_timer *
                0.35
            )
        ) *
        0.06;
}


if (can_interact)
{
    draw_highlight(
        sprite_index,
        image_index,
        x,
        y
    );

    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);



    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
else
{
    draw_self();
}


// Lightweight processing particles
if (is_processing)
{
    var _time =
        current_time /
        1000;

    for (
        var _i = 0;
        _i < 3;
        _i++
    )
    {
        var _particle_life =
            frac(
                _time *
                (
                    0.35 +
                    _i * 0.06
                ) +
                _i * 0.31
            );

        var _particle_x =
            x +
            sin(
                _time * 2 +
                _i * 2.4
            ) *
            (
                4 +
                _particle_life * 3
            );

        var _particle_y =
            bbox_top +
            8 -
            _particle_life * 12;

        draw_set_alpha(
            (1 - _particle_life) *
            0.60
        );

        if (_i mod 2 == 0)
        {
            draw_set_color(
                make_color_rgb(
                    115,
                    151,
                    76
                )
            );
        }
        else
        {
            draw_set_color(
                make_color_rgb(
                    153,
                    112,
                    62
                )
            );
        }

        draw_rectangle(
            _particle_x,
            _particle_y,
            _particle_x + 1,
            _particle_y + 1,
            false
        );
    }
}


// Filling or processing progress
if (
    stored_materials > 0 ||
    is_processing
)
{
    var _progress;

    if (is_processing)
    {
        _progress =
            get_processing_progress();
    }
    else
    {
        _progress =
            stored_materials /
            material_capacity;
    }

    var _bar_width = 38;
    var _bar_height = 3;

    var _bar_x =
        x -
        _bar_width * 0.5;

    var _bar_y =
        bbox_top - 23;

    draw_set_alpha(0.88);
    draw_set_color(
        progress_background_color
    );

    draw_rectangle(
        _bar_x - 1,
        _bar_y - 1,
        _bar_x +
        _bar_width + 1,
        _bar_y +
        _bar_height + 1,
        false
    );

    if (is_processing)
    {
        draw_set_color(
            processing_progress_color
        );
    }
    else
    {
        draw_set_color(
            fill_progress_color
        );
    }

    draw_rectangle(
        _bar_x,
        _bar_y,
        _bar_x +
        _bar_width *
        clamp(_progress, 0, 1),
        _bar_y +
        _bar_height,
        false
    );
}


// Interaction prompt
if (can_interact)
{
    var _prompt =
        "[E]";

    if (is_processing)
    {
        _prompt =
            "Composting...";
    }
    else if (stored_materials > 0)
    {
        _prompt =
            "[E] " +
            string(stored_materials) +
            "/" +
            string(material_capacity);
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);

    draw_text_transformed(
        x,
        bbox_top - 25,
        _prompt,
        prompt_text_scale,
        prompt_text_scale,
        0
    );
}


// Feedback message
if (
    message_timer > 0 &&
    message != ""
)
{
    draw_set_alpha(
        min(
            1,
            message_timer / 20
        )
    );

    draw_set_color(
        message_color
    );

    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);

    draw_text_transformed(
        x,
        bbox_top - 25,
        message,
        prompt_text_scale,
        prompt_text_scale,
        0
    );
}


draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);