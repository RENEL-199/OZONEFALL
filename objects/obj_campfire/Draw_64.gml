if (!cooking_ui_open)
{
    exit;
}

var _gui_width =
    display_get_gui_width();

var _gui_height =
    display_get_gui_height();

campfire_ui_update_layout(id);

var _panel_x =
    cooking_ui_x;

var _panel_y =
    cooking_ui_y;

var _mouse_x =
    device_mouse_x_to_gui(0);

var _mouse_y =
    device_mouse_y_to_gui(0);

// Focus overlay
draw_set_color(c_black);

draw_set_alpha(
    0.22 *
    cooking_ui_open_amount
);

draw_rectangle(
    0,
    0,
    _gui_width,
    _gui_height,
    false
);


// Panel shadow
draw_set_color(c_black);

draw_set_alpha(
    0.48 *
    cooking_ui_open_amount
);

draw_rectangle(
    _panel_x + 7,
    _panel_y + 8,
    _panel_x +
    cooking_ui_width + 7,
    _panel_y +
    cooking_ui_height + 8,
    false
);


// Visual connection to the campfire
if (cooking_ui_side != 0)
{
    var _connection_x =
        _panel_x;

    if (cooking_ui_side < 0)
    {
        _connection_x =
            _panel_x +
            cooking_ui_width;
    }

    var _connection_y =
        clamp(
            cooking_ui_anchor_y,
            _panel_y + 52,
            _panel_y +
            cooking_ui_height - 52
        );

    draw_set_color(
        make_color_rgb(
            238,
            151,
            62
        )
    );

    draw_set_alpha(
        0.60 *
        cooking_ui_open_amount
    );

    draw_line_width(
        cooking_ui_anchor_x,
        cooking_ui_anchor_y,
        _connection_x,
        _connection_y,
        max(
            1,
            2 * cooking_ui_scale
        )
    );

    draw_circle(
        cooking_ui_anchor_x,
        cooking_ui_anchor_y,
        max(
            2,
            4 * cooking_ui_scale
        ),
        false
    );
}

draw_set_alpha(1);
draw_set_color(c_white);
// Background
if (
    sprite_exists(
        cooking_ui_background_sprite
    )
)
{
    draw_sprite_stretched(
        cooking_ui_background_sprite,
        0,
        _panel_x,
        _panel_y,
        cooking_ui_width,
        cooking_ui_height
    );
}
else
{
    draw_set_alpha(0.97);
    draw_set_color(
        cooking_ui_background_color
    );

    draw_rectangle(
        _panel_x,
        _panel_y,
        _panel_x +
        cooking_ui_width,
        _panel_y +
        cooking_ui_height,
        false
    );

    draw_set_alpha(1);
    draw_set_color(
        cooking_ui_border_color
    );

    draw_rectangle(
        _panel_x,
        _panel_y,
        _panel_x +
        cooking_ui_width,
        _panel_y +
        cooking_ui_height,
        true
    );
}


// Title
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(
    cooking_ui_text_color
);

draw_text_transformed(
    _panel_x + 16,
    _panel_y + 15,
    "CAMPFIRE COOKING",
    cooking_ui_text_scale,
    cooking_ui_text_scale,
    0
);


// Close button
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_text_transformed(
    _panel_x +
    cooking_ui_width - 22,
    _panel_y + 22,
    "X",
    cooking_ui_text_scale,
    cooking_ui_text_scale,
    0
);


// Remaining fuel
if (
    lit &&
    variable_global_exists("game_time")
)
{
    var _fuel_minutes =
        global.game_time.minutes_until(
            burn_finish_timestamp
        );

    var _fuel_hours =
        _fuel_minutes div 60;

    var _fuel_minute_part =
        _fuel_minutes mod 60;

    var _fuel_text =
        "Fuel: " +
        string(_fuel_hours) +
        "h " +
        string(_fuel_minute_part) +
        "m";

    draw_set_halign(fa_right);
    draw_set_valign(fa_top);
    draw_set_color(
        cooking_ui_muted_color
    );

    draw_text_transformed(
        _panel_x +
        cooking_ui_width - 48,
        _panel_y + 17,
        _fuel_text,
        cooking_ui_small_text_scale,
        cooking_ui_small_text_scale,
        0
    );
}


// Recipe list
var _recipe_count =
    array_length(
        global.campfire_recipes
    );

var _recipe_x =
    _panel_x + 16;

var _recipe_y =
    _panel_y + 54;

for (
    var _i = 0;
    _i < _recipe_count;
    _i++
)
{
    var _recipe =
        campfire_recipe_get(_i);

    var _row_y =
        _recipe_y +
        _i *
        (
            cooking_ui_recipe_height +
            cooking_ui_recipe_gap
        );

    var _selected =
        selected_cooking_recipe == _i;

    var _row_sprite =
        cooking_ui_recipe_sprite;

    if (_selected)
    {
        _row_sprite =
            cooking_ui_selected_recipe_sprite;
    }

    if (sprite_exists(_row_sprite))
    {
        draw_sprite_stretched(
            _row_sprite,
            0,
            _recipe_x,
            _row_y,
            cooking_ui_recipe_width,
            cooking_ui_recipe_height
        );
    }
    else
    {
        if (_selected)
        {
            draw_set_color(
                cooking_ui_selected_color
            );
        }
        else
        {
            draw_set_color(
                cooking_ui_panel_color
            );
        }

        draw_rectangle(
            _recipe_x,
            _row_y,
            _recipe_x +
            cooking_ui_recipe_width,
            _row_y +
            cooking_ui_recipe_height,
            false
        );

        draw_set_color(
            cooking_ui_border_color
        );

        draw_rectangle(
            _recipe_x,
            _row_y,
            _recipe_x +
            cooking_ui_recipe_width,
            _row_y +
            cooking_ui_recipe_height,
            true
        );
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(
        cooking_ui_text_color
    );

    draw_text_transformed(
        _recipe_x + 10,
        _row_y +
        cooking_ui_recipe_height * 0.5,
        _recipe.name,
        cooking_ui_small_text_scale,
        cooking_ui_small_text_scale,
        0
    );
}


// Selected recipe details
var _selected_recipe =
    campfire_recipe_get(
        selected_cooking_recipe
    );

if (!is_undefined(_selected_recipe))
{
    var _detail_x =
        _panel_x +
        cooking_ui_recipe_width +
        42;

    var _detail_y =
        _panel_y + 55;

    var _output_data =
        item_get_data(
            _selected_recipe.output_item_id
        );

    if (
        !is_undefined(_output_data) &&
        sprite_exists(_output_data.sprite)
    )
    {
        var _output_scale =
            min(
                68 /
                sprite_get_width(
                    _output_data.sprite
                ),

                68 /
                sprite_get_height(
                    _output_data.sprite
                )
            );

        var _pulse_scale = 1;

        if (completion_pulse_timer > 0)
        {
            _pulse_scale +=
                sin(
                    completion_pulse_timer *
                    0.45
                ) * 0.08;
        }

        draw_sprite_ext(
            _output_data.sprite,
            0,
            _detail_x + 24,
            _detail_y + 26,
            _output_scale *
            _pulse_scale,
            _output_scale *
            _pulse_scale,
            0,
            c_white,
            1
        );
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(
        cooking_ui_text_color
    );

    draw_text_transformed(
        _detail_x + 58,
        _detail_y + 2,
        _selected_recipe.name,
        cooking_ui_text_scale,
        cooking_ui_text_scale,
        0
    );

    draw_set_color(
        cooking_ui_muted_color
    );

    draw_text_transformed(
        _detail_x + 58,
        _detail_y + 25,
        "Output x" +
        string(
            _selected_recipe.output_amount
        ),
        cooking_ui_small_text_scale,
        cooking_ui_small_text_scale,
        0
    );


    var _ingredient_y =
        _detail_y + 70;

    var _ingredient_count =
        array_length(
            _selected_recipe.ingredients
        );

    for (
        var _ingredient_index = 0;
        _ingredient_index <
        _ingredient_count;
        _ingredient_index++
    )
    {
        var _ingredient =
            _selected_recipe.ingredients[
                _ingredient_index
            ];

        var _ingredient_data =
            item_get_data(
                _ingredient.item_id
            );

        var _available =
            global.player_inventory.count_item(
                _ingredient.item_id
            );

        var _line_y =
            _ingredient_y +
            _ingredient_index * 38;

        if (
            !is_undefined(_ingredient_data) &&
            sprite_exists(
                _ingredient_data.sprite
            )
        )
        {
            var _ingredient_scale =
                min(
                    42 /
                    sprite_get_width(
                        _ingredient_data.sprite
                    ),

                    42 /
                    sprite_get_height(
                        _ingredient_data.sprite
                    )
                );

            draw_sprite_ext(
                _ingredient_data.sprite,
                0,
                _detail_x + 15,
                _line_y + 14,
                _ingredient_scale,
                _ingredient_scale,
                0,
                c_white,
                1
            );
        }

        if (
            _available >=
            _ingredient.amount
        )
        {
            draw_set_color(
                cooking_ui_available_color
            );
        }
        else
        {
            draw_set_color(
                cooking_ui_missing_color
            );
        }

        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);

        var _ingredient_name =
            "Unknown Item";

        if (
            !is_undefined(
                _ingredient_data
            )
        )
        {
            _ingredient_name =
                _ingredient_data.name;
        }

        draw_text_transformed(
            _detail_x + 36,
            _line_y + 14,
            _ingredient_name +
            "  " +
            string(_available) +
            "/" +
            string(_ingredient.amount),
            cooking_ui_small_text_scale,
            cooking_ui_small_text_scale,
            0
        );
    }
}


// Progress bar
var _progress_x =
    _panel_x +
    cooking_ui_recipe_width +
    42;

var _progress_y =
    _panel_y +
    cooking_ui_height - 71;

var _progress_width =
    cooking_ui_width -
    cooking_ui_recipe_width -
    cooking_ui_button_width -
    86;

var _progress = 0;

if (is_cooking)
{
    _progress =
        crafting_get_progress(
            cook_start_timestamp,
            cook_finish_timestamp
        );
}

draw_set_color(
    cooking_ui_border_color
);

draw_rectangle(
    _progress_x - 1,
    _progress_y - 1,
    _progress_x +
    _progress_width + 1,
    _progress_y + 13,
    false
);

draw_set_color(
    cooking_ui_panel_color
);

draw_rectangle(
    _progress_x,
    _progress_y,
    _progress_x +
    _progress_width,
    _progress_y + 12,
    false
);

draw_set_color(
    cooking_ui_progress_color
);

draw_rectangle(
    _progress_x,
    _progress_y,
    _progress_x +
    _progress_width *
    _progress,
    _progress_y + 12,
    false
);


// Cook button
var _button_x =
    _panel_x +
    cooking_ui_width -
    cooking_ui_button_width -
    18;

var _button_y =
    _panel_y +
    cooking_ui_height -
    cooking_ui_button_height -
    16;

var _button_hovered =
    point_in_rectangle(
        _mouse_x,
        _mouse_y,
        _button_x,
        _button_y,
        _button_x +
        cooking_ui_button_width,
        _button_y +
        cooking_ui_button_height
    );

var _button_enabled =
    can_start_cooking(
        selected_cooking_recipe
    );

var _button_color =
    cooking_ui_button_disabled_color;

if (_button_enabled)
{
    if (_button_hovered)
    {
        _button_color =
            cooking_ui_button_hover_color;
    }
    else
    {
        _button_color =
            cooking_ui_button_color;
    }
}

if (
    sprite_exists(
        cooking_ui_button_sprite
    )
)
{
    draw_sprite_stretched_ext(
        cooking_ui_button_sprite,
        0,
        _button_x,
        _button_y,
        cooking_ui_button_width,
        cooking_ui_button_height,
        c_white,
        1
    );
}
else
{
    draw_set_color(
        _button_color
    );

    draw_rectangle(
        _button_x,
        _button_y,
        _button_x +
        cooking_ui_button_width,
        _button_y +
        cooking_ui_button_height,
        false
    );

    draw_set_color(
        cooking_ui_border_color
    );

    draw_rectangle(
        _button_x,
        _button_y,
        _button_x +
        cooking_ui_button_width,
        _button_y +
        cooking_ui_button_height,
        true
    );
}

var _button_text = "COOK";

if (is_cooking)
{
    _button_text = "COOKING";
}
else if (pending_output_amount > 0)
{
    _button_text = "OUTPUT WAITING";
}

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

if (_button_enabled)
{
    draw_set_color(
        cooking_ui_text_color
    );
}
else
{
    draw_set_color(
        cooking_ui_muted_color
    );
}

draw_text_transformed(
    _button_x +
    cooking_ui_button_width * 0.5,
    _button_y +
    cooking_ui_button_height * 0.5,
    _button_text,
    cooking_ui_small_text_scale,
    cooking_ui_small_text_scale,
    0
);


// Message
if (
    message_timer > 0 &&
    message != ""
)
{
    draw_set_halign(fa_left);
    draw_set_valign(fa_bottom);
    draw_set_color(
        cooking_ui_muted_color
    );

    draw_text_transformed(
        _panel_x + 18,
        _panel_y +
        cooking_ui_height - 18,
        message,
        cooking_ui_small_text_scale,
        cooking_ui_small_text_scale,
        0
    );
}


draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);