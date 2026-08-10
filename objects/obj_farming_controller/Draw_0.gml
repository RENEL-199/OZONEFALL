if (instance_exists(target_soil))
{
    var _grid_size = 16;

    if (
        variable_instance_exists(
            target_soil,
            "grid_size"
        )
    )
    {
        _grid_size =
            target_soil.grid_size;
    }

    var _half_size =
        _grid_size * 0.5;

    var _pulse =
        0.70 +
        sin(
            current_time / 140
        ) * 0.20;

    var _left =
        round(
            target_soil.x -
            _half_size
        );

    var _top =
        round(
            target_soil.y -
            _half_size
        );

    var _right =
        _left +
        _grid_size;

    var _bottom =
        _top +
        _grid_size;


    // Subtle dark backing
    draw_set_color(
        make_color_rgb(
            30,
            34,
            42
        )
    );

    draw_set_alpha(
        _pulse * 0.55
    );

    draw_rectangle(
        _left - 1,
        _top - 1,
        _right + 1,
        _bottom + 1,
        true
    );


    // Main tile outline
    draw_set_color(
        make_color_rgb(
            245,
            239,
            210
        )
    );

    draw_set_alpha(_pulse);

    draw_rectangle(
        _left,
        _top,
        _right,
        _bottom,
        true
    );
}


draw_set_color(c_white);
draw_set_alpha(1);

draw_set_halign(fa_left);
draw_set_valign(fa_top);