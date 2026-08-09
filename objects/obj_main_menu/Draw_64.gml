/// obj_main_menu — Draw GUI Event

draw_set_font(
    fnt_pixel
);

var _mouse_x =
    device_mouse_x_to_gui(0);

var _mouse_y =
    device_mouse_y_to_gui(0);

var _gui_width =
    display_get_gui_width();

var _gui_height =
    display_get_gui_height();

var _draw_menu_button = function(
    _x,
    _y,
    _width,
    _height,
    _text,
    _selected,
    _enabled
)
{
   var _button_mouse_x =
    device_mouse_x_to_gui(0);

var _button_mouse_y =
    device_mouse_y_to_gui(0);

var _hovered =
    point_in_rectangle(
        _button_mouse_x,
        _button_mouse_y,
        _x,
        _y,
        _x + _width,
        _y + _height
    );

var _button_sprite =
    menu_button_sprite;

if (_selected || _hovered)
{
    _button_sprite =
        menu_button_selected_sprite;
}

    draw_set_alpha(1);

if (
    _button_sprite != -1 &&
    sprite_exists(_button_sprite)
)
    {
        draw_sprite_stretched(
            _button_sprite,
            0,
            _x,
            _y,
            _width,
            _height
        );
    }
    else
    {
        draw_set_color(
            make_color_rgb(
                48,
                55,
                49
            )
        );

        draw_rectangle(
            _x,
            _y,
            _x + _width,
            _y + _height,
            false
        );
    }

    if (_enabled)
    {
        draw_set_color(c_white);
    }
    else
    {
        draw_set_color(c_gray);
    }

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text(
        _x + _width * 0.5,
        _y + _height * 0.5,
        _text
    );
};


if (
    menu_background_sprite != -1 &&
    sprite_exists(
        menu_background_sprite
    )
)
{
    draw_sprite_stretched(
        menu_background_sprite,
        0,
        0,
        0,
        _gui_width,
        _gui_height
    );
}
else
{
    draw_set_color(
        make_color_rgb(
            37,
            42,
            38
        )
    );

    draw_rectangle(
        0,
        0,
        _gui_width,
        _gui_height,
        false
    );
}

draw_set_alpha(0.34);
draw_set_color(c_black);

draw_rectangle(
    0,
    0,
    _gui_width,
    _gui_height,
    false
);

draw_set_alpha(1);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

draw_text(
    42,
    42,
    "OZONEFALL"
);

draw_set_color(
    make_color_rgb(
        194,
        205,
        183
    )
);

draw_text(
    44,
    72,
    "RESTORE. SURVIVE. REBUILD."
);


// ================================================================
// HOME
// ================================================================

if (menu_page == menu_home)
{
    var _labels =
    [
        "CONTINUE",
        "NEW GAME",
        "LOAD GAME",
        "SETTINGS",
        "CREDITS"
    ];

    var _latest_slot =
        save_controller
        .get_most_recent_slot();

    for (var _i = 0; _i < 5; _i++)
    {
        var _button_y =
            home_button_y +
            _i *
            (
                home_button_height +
                home_button_gap
            );

        var _enabled = true;

        if (
            _i == 0 &&
            _latest_slot == -1
        )
        {
            _enabled = false;
        }

        _draw_menu_button(
            home_button_x,
            _button_y,
            home_button_width,
            home_button_height,
            _labels[_i],
            selected_option == _i,
            _enabled
        );
    }
}


// ================================================================
// PANEL BACKGROUND
// ================================================================

if (menu_page != menu_home)
{
    draw_set_alpha(0.88);

    draw_set_color(
        make_color_rgb(
            30,
            35,
            31
        )
    );

    draw_rectangle(
        panel_x,
        panel_y,
        panel_x + panel_width,
        panel_y + panel_height,
        false
    );

    draw_set_alpha(1);

    draw_set_color(
        make_color_rgb(
            129,
            151,
            120
        )
    );

    draw_rectangle(
        panel_x,
        panel_y,
        panel_x + panel_width,
        panel_y + panel_height,
        true
    );
}


// ================================================================
// SLOT PAGES
// ================================================================

if (
    menu_page == menu_new_game ||
    menu_page == menu_load_game
)
{
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);

    if (menu_page == menu_new_game)
    {
        draw_text(
            slot_x,
            67,
            "SELECT A NEW GAME SLOT"
        );
    }
    else
    {
        draw_text(
            slot_x,
            67,
            "LOAD GAME"
        );
    }

    for (
        var _slot = 1;
        _slot <= 3;
        _slot++
    )
    {
        var _index =
            _slot - 1;

        var _slot_draw_y =
            slot_y +
            _index *
            (
                slot_height +
                slot_gap
            );

        var _slot_text =
            "SLOT " +
            string(_slot) +
            "  -  " +
            save_controller
            .slot_summaries[_index];

        _draw_menu_button(
            slot_x,
            _slot_draw_y,
            slot_width,
            slot_height,
            _slot_text,
            selected_option == _index,
            true
        );
    }

    _draw_menu_button(
        back_button_x,
        back_button_y,
        back_button_width,
        back_button_height,
        "BACK",
        selected_option == 3,
        true
    );
}


// ================================================================
// OVERWRITE CONFIRMATION
// ================================================================

if (menu_page == menu_confirm_overwrite)
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);

    draw_text(
        panel_x + panel_width * 0.5,
        126,
        "OVERWRITE SLOT " +
        string(confirm_slot) +
        "?"
    );

    draw_set_color(
        make_color_rgb(
            205,
            199,
            186
        )
    );

    draw_text(
        panel_x + panel_width * 0.5,
        166,
        "THE EXISTING SAVE WILL BE DELETED."
    );

    _draw_menu_button(
        300,
        214,
        94,
        34,
        "YES",
        selected_option == 0,
        true
    );

    _draw_menu_button(
        410,
        214,
        94,
        34,
        "NO",
        selected_option == 1,
        true
    );
}


// ================================================================
// SETTINGS
// ================================================================

if (menu_page == menu_settings)
{
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);

    draw_text(
        270,
        67,
        "SETTINGS"
    );

    var _fullscreen_text =
        "FULLSCREEN: OFF";

    if (fullscreen_enabled)
    {
        _fullscreen_text =
            "FULLSCREEN: ON";
    }

    _draw_menu_button(
        270,
        108,
        308,
        42,
        _fullscreen_text,
        selected_option == 0,
        true
    );

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_color(
        make_color_rgb(
            189,
            194,
            181
        )
    );

    draw_text_ext(
        270,
        174,
        "Audio and mobile control settings will be added here later.",
        18,
        290
    );

    _draw_menu_button(
        back_button_x,
        back_button_y,
        back_button_width,
        back_button_height,
        "BACK",
        selected_option == 1,
        true
    );
}


// ================================================================
// CREDITS
// ================================================================

if (menu_page == menu_credits)
{
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);

    draw_text(
        270,
        67,
        "CREDITS"
    );

    draw_set_color(
        make_color_rgb(
            205,
            199,
            186
        )
    );

    draw_text_ext(
        270,
        108,
        "OZONEFALL\n\nCreated by Sam Renly R. Cruzado\n\nA survival game about restoring a ruined world.",
        22,
        290
    );

    _draw_menu_button(
        back_button_x,
        back_button_y,
        back_button_width,
        back_button_height,
        "BACK",
        false,
        true
    );
}


// ================================================================
// STATUS MESSAGE
// ================================================================

var _status_text = "";

if (menu_status_timer > 0)
{
    _status_text = menu_status;
}
else if (
    instance_exists(save_controller) &&
    save_controller.status_message_timer > 0
)
{
    _status_text =
        save_controller.status_message;
}

if (_status_text != "")
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);

    draw_text(
        _gui_width * 0.5,
        _gui_height - 12,
        _status_text
    );
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);