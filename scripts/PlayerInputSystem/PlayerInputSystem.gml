function PlayerInputSystem() constructor
{
    move_x = 0;
    move_y = 0;

    interact_pressed = false;
    use_pressed = false;
    sprint_held = false;

    mobile_device =
        os_type == os_android;

    force_mobile_controls = false;
    show_mobile_controls = mobile_device;

    maximum_touches = 5;

    joystick_touch = -1;
    joystick_x = 0;
    joystick_y = 0;
    joystick_knob_x = 0;
    joystick_knob_y = 0;
    joystick_radius = 120;
    joystick_deadzone = 0.18;

    interact_x = 0;
    interact_y = 0;
    interact_radius = 68;

    sprint_x = 0;
    sprint_y = 0;
    sprint_radius = 58;

    use_x = 0;
    use_y = 0;
    use_radius = 55;

    previous_interact_down = false;
    previous_use_down = false;


    static update_layout = function()
    {
        var _gui_width =
            display_get_gui_width();

        var _gui_height =
            display_get_gui_height();

        joystick_x = 170;
        joystick_y =
            _gui_height - 180;

        interact_x =
            _gui_width - 150;

        interact_y =
            _gui_height - 190;

        sprint_x =
            _gui_width - 315;

        sprint_y =
            _gui_height - 125;

        use_x =
            _gui_width - 150;

        use_y =
            _gui_height - 355;
    };


    static update = function()
    {
        update_layout();

        show_mobile_controls =
            mobile_device ||
            force_mobile_controls;

        move_x = 0;
        move_y = 0;

        interact_pressed = false;
        use_pressed = false;
        sprint_held = false;

        var _keyboard_x = 0;
        var _keyboard_y = 0;

        if (keyboard_check(ord("D")))
        {
            _keyboard_x++;
        }

        if (keyboard_check(ord("A")))
        {
            _keyboard_x--;
        }

        if (keyboard_check(ord("S")))
        {
            _keyboard_y++;
        }

        if (keyboard_check(ord("W")))
        {
            _keyboard_y--;
        }

        var _keyboard_length =
            point_distance(
                0,
                0,
                _keyboard_x,
                _keyboard_y
            );

        if (_keyboard_length > 0)
        {
            _keyboard_x /=
                _keyboard_length;

            _keyboard_y /=
                _keyboard_length;
        }

        move_x = _keyboard_x;
        move_y = _keyboard_y;

        var _keyboard_interact =
            keyboard_check_pressed(
                ord("E")
            );

        var _keyboard_use =
            keyboard_check_pressed(
                ord("F")
            );

        var _keyboard_sprint =
            keyboard_check(
                vk_shift
            );

        var _touch_interact_down = false;
        var _touch_use_down = false;
        var _touch_sprint_down = false;


        if (show_mobile_controls)
        {
            if (
                joystick_touch != -1 &&
                !device_mouse_check_button(
                    joystick_touch,
                    mb_left
                )
            )
            {
                joystick_touch = -1;
            }


            if (joystick_touch == -1)
            {
                for (
                    var _touch = 0;
                    _touch < maximum_touches;
                    _touch++
                )
                {
                    if (
                        !device_mouse_check_button(
                            _touch,
                            mb_left
                        )
                    )
                    {
                        continue;
                    }

                    var _touch_x =
                        device_mouse_x_to_gui(
                            _touch
                        );

                    var _touch_y =
                        device_mouse_y_to_gui(
                            _touch
                        );

                    if (
                        _touch_x <
                        display_get_gui_width() *
                        0.45 &&

                        point_distance(
                            joystick_x,
                            joystick_y,
                            _touch_x,
                            _touch_y
                        ) <=
                        joystick_radius * 1.65
                    )
                    {
                        joystick_touch =
                            _touch;

                        break;
                    }
                }
            }


            if (joystick_touch != -1)
            {
                var _joystick_touch_x =
                    device_mouse_x_to_gui(
                        joystick_touch
                    );

                var _joystick_touch_y =
                    device_mouse_y_to_gui(
                        joystick_touch
                    );

                var _joystick_distance =
                    point_distance(
                        joystick_x,
                        joystick_y,
                        _joystick_touch_x,
                        _joystick_touch_y
                    );

                var _joystick_direction =
                    point_direction(
                        joystick_x,
                        joystick_y,
                        _joystick_touch_x,
                        _joystick_touch_y
                    );

                var _limited_distance =
                    min(
                        joystick_radius,
                        _joystick_distance
                    );

                joystick_knob_x =
                    joystick_x +
                    lengthdir_x(
                        _limited_distance,
                        _joystick_direction
                    );

                joystick_knob_y =
                    joystick_y +
                    lengthdir_y(
                        _limited_distance,
                        _joystick_direction
                    );

                var _strength =
                    _limited_distance /
                    joystick_radius;

                if (
                    _strength >=
                    joystick_deadzone
                )
                {
                    move_x =
                        lengthdir_x(
                            _strength,
                            _joystick_direction
                        );

                    move_y =
                        lengthdir_y(
                            _strength,
                            _joystick_direction
                        );
                }
                else
                {
                    move_x = 0;
                    move_y = 0;
                }
            }
            else
            {
                joystick_knob_x =
                    joystick_x;

                joystick_knob_y =
                    joystick_y;
            }


            for (
                var _touch = 0;
                _touch < maximum_touches;
                _touch++
            )
            {
                if (
                    !device_mouse_check_button(
                        _touch,
                        mb_left
                    )
                )
                {
                    continue;
                }

                if (_touch == joystick_touch)
                {
                    continue;
                }

                var _touch_x =
                    device_mouse_x_to_gui(
                        _touch
                    );

                var _touch_y =
                    device_mouse_y_to_gui(
                        _touch
                    );

                if (
                    point_distance(
                        _touch_x,
                        _touch_y,
                        interact_x,
                        interact_y
                    ) <= interact_radius
                )
                {
                    _touch_interact_down =
                        true;
                }

                if (
                    point_distance(
                        _touch_x,
                        _touch_y,
                        sprint_x,
                        sprint_y
                    ) <= sprint_radius
                )
                {
                    _touch_sprint_down =
                        true;
                }

                if (
                    point_distance(
                        _touch_x,
                        _touch_y,
                        use_x,
                        use_y
                    ) <= use_radius
                )
                {
                    _touch_use_down =
                        true;
                }
            }
        }


        interact_pressed =
            _keyboard_interact ||
            (
                _touch_interact_down &&
                !previous_interact_down
            );

        use_pressed =
            _keyboard_use ||
            (
                _touch_use_down &&
                !previous_use_down
            );

        sprint_held =
            _keyboard_sprint ||
            _touch_sprint_down;

        previous_interact_down =
            _touch_interact_down;

        previous_use_down =
            _touch_use_down;
    };
}


function player_input_interact_pressed()
{
    if (
        !variable_global_exists(
            "player_input"
        )
    )
    {
        return keyboard_check_pressed(
            ord("E")
        );
    }

    return global.player_input
        .interact_pressed;
}


function player_input_use_pressed()
{
    if (
        !variable_global_exists(
            "player_input"
        )
    )
    {
        return keyboard_check_pressed(
            ord("F")
        );
    }

    return global.player_input
        .use_pressed;
}