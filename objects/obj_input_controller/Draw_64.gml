/// obj_input_controller — Draw GUI Event

if (
    !variable_global_exists(
        "player_input"
    )
)
{
    exit;
}

var _input =
    global.player_input;

if (!_input.show_mobile_controls)
{
    exit;
}

draw_set_font(
    fnt_pixel
);

draw_set_alpha(0.32);
draw_set_color(c_black);

draw_circle(
    _input.joystick_x,
    _input.joystick_y,
    _input.joystick_radius,
    false
);

draw_set_alpha(0.52);
draw_set_color(c_white);

draw_circle(
    _input.joystick_x,
    _input.joystick_y,
    _input.joystick_radius,
    true
);

draw_set_alpha(0.56);
draw_set_color(
    make_color_rgb(
        158,
        171,
        151
    )
);

draw_circle(
    _input.joystick_knob_x,
    _input.joystick_knob_y,
    52,
    false
);


var _draw_touch_button = function(
    _x,
    _y,
    _radius,
    _label
)
{
    draw_set_alpha(0.38);
    draw_set_color(c_black);

    draw_circle(
        _x,
        _y,
        _radius,
        false
    );

    draw_set_alpha(0.62);
    draw_set_color(c_white);

    draw_circle(
        _x,
        _y,
        _radius,
        true
    );

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text(
        _x,
        _y,
        _label
    );
};


_draw_touch_button(
    _input.interact_x,
    _input.interact_y,
    _input.interact_radius,
    "E"
);

_draw_touch_button(
    _input.sprint_x,
    _input.sprint_y,
    _input.sprint_radius,
    "RUN"
);

_draw_touch_button(
    _input.use_x,
    _input.use_y,
    _input.use_radius,
    "USE"
);

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);