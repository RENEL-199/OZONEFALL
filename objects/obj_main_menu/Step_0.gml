if (menu_status_timer > 0)
{
    menu_status_timer--;
}

if (!instance_exists(save_controller))
{
    save_controller =
        instance_find(
            obj_save_controller,
            0
        );

    if (!instance_exists(save_controller))
    {
        exit;
    }
}

var _mouse_x =
    device_mouse_x_to_gui(0);

var _mouse_y =
    device_mouse_y_to_gui(0);

var _pressed =
    device_mouse_check_button_pressed(
        0,
        mb_left
    );

var _move_up =
    keyboard_check_pressed(vk_up) ||
    keyboard_check_pressed(ord("W"));

var _move_down =
    keyboard_check_pressed(vk_down) ||
    keyboard_check_pressed(ord("S"));

var _move_left =
    keyboard_check_pressed(vk_left) ||
    keyboard_check_pressed(ord("A"));

var _move_right =
    keyboard_check_pressed(vk_right) ||
    keyboard_check_pressed(ord("D"));

var _confirm =
    keyboard_check_pressed(vk_enter) ||
    keyboard_check_pressed(vk_space);

var _back =
    keyboard_check_pressed(vk_escape);


if (_back)
{
    if (menu_page != menu_home)
    {
        menu_page = menu_home;
        selected_option = 0;
        confirm_slot = -1;
    }
}


// ================================================================
// HOME
// ================================================================

if (menu_page == menu_home)
{
    if (_move_up)
    {
        selected_option =
            max(
                0,
                selected_option - 1
            );
    }

    if (_move_down)
    {
        selected_option =
            min(
                4,
                selected_option + 1
            );
    }

    for (var _i = 0; _i < 5; _i++)
    {
        var _button_y =
            home_button_y +
            _i *
            (
                home_button_height +
                home_button_gap
            );

        if (
            point_in_rectangle(
                _mouse_x,
                _mouse_y,
                home_button_x,
                _button_y,
                home_button_x +
                home_button_width,
                _button_y +
                home_button_height
            )
        )
        {
            selected_option = _i;

            if (_pressed)
            {
                _confirm = true;
            }
        }
    }

    if (_confirm)
    {
        switch (selected_option)
        {
            case 0:
                if (
                    !save_controller
                    .request_continue()
                )
                {
                    menu_status =
                        "No saved game found.";

                    menu_status_timer = 150;
                }
            break;

            case 1:
                save_controller
                    .refresh_all_save_slots();

                menu_page =
                    menu_new_game;

                selected_option = 0;
            break;

            case 2:
                save_controller
                    .refresh_all_save_slots();

                menu_page =
                    menu_load_game;

                selected_option = 0;
            break;

            case 3:
                menu_page =
                    menu_settings;

                selected_option = 0;
            break;

            case 4:
                menu_page =
                    menu_credits;

                selected_option = 0;
            break;
        }
    }

    exit;
}


// ================================================================
// NEW GAME AND LOAD GAME
// ================================================================

if (
    menu_page == menu_new_game ||
    menu_page == menu_load_game
)
{
    if (_move_up)
    {
        selected_option =
            max(
                0,
                selected_option - 1
            );
    }

    if (_move_down)
    {
        selected_option =
            min(
                3,
                selected_option + 1
            );
    }

    for (
        var _slot = 1;
        _slot <= 3;
        _slot++
    )
    {
        var _slot_y =
            slot_y +
            (_slot - 1) *
            (
                slot_height +
                slot_gap
            );

        if (
            point_in_rectangle(
                _mouse_x,
                _mouse_y,
                slot_x,
                _slot_y,
                slot_x + slot_width,
                _slot_y + slot_height
            )
        )
        {
            selected_option =
                _slot - 1;

            if (_pressed)
            {
                _confirm = true;
            }
        }
    }

    if (
        point_in_rectangle(
            _mouse_x,
            _mouse_y,
            back_button_x,
            back_button_y,
            back_button_x +
            back_button_width,
            back_button_y +
            back_button_height
        )
    )
    {
        selected_option = 3;

        if (_pressed)
        {
            _confirm = true;
        }
    }

    if (_confirm)
    {
        if (selected_option == 3)
        {
            menu_page = menu_home;
            selected_option = 0;
            exit;
        }

        selected_slot =
            selected_option + 1;

        var _slot_index =
            selected_slot - 1;

        if (menu_page == menu_new_game)
        {
            if (
                save_controller
                .slot_has_save[
                    _slot_index
                ]
            )
            {
                confirm_slot =
                    selected_slot;

                menu_page =
                    menu_confirm_overwrite;

                selected_option = 1;
            }
            else
            {
                var _gameplay_room =
                    asset_get_index(
                        "Main"
                    );

                if (_gameplay_room == -1)
                {
                    menu_status =
                        "Gameplay room 'main' was not found.";

                    menu_status_timer = 180;
                }
                else
                {
                    save_controller
                        .request_new_game(
                            selected_slot,
                            _gameplay_room
                        );
                }
            }
        }
        else
        {
            if (
                save_controller
                .slot_has_save[
                    _slot_index
                ]
            )
            {
                save_controller
                    .request_load(
                        selected_slot
                    );
            }
            else
            {
                menu_status =
                    "That save slot is empty.";

                menu_status_timer = 150;
            }
        }
    }

    exit;
}


// ================================================================
// OVERWRITE CONFIRMATION
// ================================================================

if (menu_page == menu_confirm_overwrite)
{
    if (_move_left || _move_right)
    {
        selected_option =
            1 - selected_option;
    }

    var _yes_x = 300;
    var _yes_y = 214;

    var _no_x = 410;
    var _no_y = 214;

    var _choice_width = 94;
    var _choice_height = 34;

    if (
        point_in_rectangle(
            _mouse_x,
            _mouse_y,
            _yes_x,
            _yes_y,
            _yes_x + _choice_width,
            _yes_y + _choice_height
        )
    )
    {
        selected_option = 0;

        if (_pressed)
        {
            _confirm = true;
        }
    }

    if (
        point_in_rectangle(
            _mouse_x,
            _mouse_y,
            _no_x,
            _no_y,
            _no_x + _choice_width,
            _no_y + _choice_height
        )
    )
    {
        selected_option = 1;

        if (_pressed)
        {
            _confirm = true;
        }
    }

    if (_confirm)
    {
        if (selected_option == 0)
        {
            var _gameplay_room =
                asset_get_index(
                    "Main"
                );

            if (_gameplay_room == -1)
            {
                menu_status =
                    "Gameplay room 'main' was not found.";

                menu_status_timer = 180;
            }
            else
            {
                save_controller
                    .request_new_game(
                        confirm_slot,
                        _gameplay_room
                    );
            }
        }
        else
        {
            menu_page =
                menu_new_game;

            selected_option =
                confirm_slot - 1;

            confirm_slot = -1;
        }
    }

    exit;
}


// ================================================================
// SETTINGS
// ================================================================

if (menu_page == menu_settings)
{
    if (_move_up || _move_down)
    {
        selected_option =
            1 - selected_option;
    }

    var _setting_x = 270;
    var _setting_y = 108;

    var _setting_width = 308;
    var _setting_height = 42;

    if (
        point_in_rectangle(
            _mouse_x,
            _mouse_y,
            _setting_x,
            _setting_y,
            _setting_x + _setting_width,
            _setting_y + _setting_height
        )
    )
    {
        selected_option = 0;

        if (_pressed)
        {
            _confirm = true;
        }
    }

    if (
        point_in_rectangle(
            _mouse_x,
            _mouse_y,
            back_button_x,
            back_button_y,
            back_button_x +
            back_button_width,
            back_button_y +
            back_button_height
        )
    )
    {
        selected_option = 1;

        if (_pressed)
        {
            _confirm = true;
        }
    }

    if (_confirm)
    {
        if (selected_option == 0)
        {
            fullscreen_enabled =
                !fullscreen_enabled;

            window_set_fullscreen(
                fullscreen_enabled
            );
        }
        else
        {
            menu_page = menu_home;
            selected_option = 0;
        }
    }

    exit;
}


// ================================================================
// CREDITS
// ================================================================

if (menu_page == menu_credits)
{
    if (
        point_in_rectangle(
            _mouse_x,
            _mouse_y,
            back_button_x,
            back_button_y,
            back_button_x +
            back_button_width,
            back_button_y +
            back_button_height
        )
    )
    {
        if (_pressed)
        {
            menu_page = menu_home;
            selected_option = 0;
        }
    }

    if (_confirm)
    {
        menu_page = menu_home;
        selected_option = 0;
    }
}