can_interact = false;

if (message_timer > 0)
{
    message_timer--;
}

if (completion_pulse_timer > 0)
{
    completion_pulse_timer--;
}


// Fire animation and light flicker
if (lit)
{
    fire_animation_position +=
        fire_animation_speed;

    if (
        fire_animation_position >=
        fire_frame_count
    )
    {
        fire_animation_position -=
            fire_frame_count;
    }

    image_index =
        fire_first_frame +
        floor(
            fire_animation_position
        );


    light_flicker_timer--;

    if (light_flicker_timer <= 0)
    {
        light_flicker_target =
            random_range(
                1 - light_flicker_amount,
                1 + light_flicker_amount
            );

        light_flicker_timer =
            irandom_range(3, 7);
    }

    light_flicker =
        lerp(
            light_flicker,
            light_flicker_target,
            0.18
        );
}
else
{
    image_index = 0;
    light_flicker = 1;
}


// Complete cooking before checking fuel expiration
if (
    is_cooking &&
    variable_global_exists("game_time") &&
    global.game_time.timestamp_reached(
        cook_finish_timestamp
    )
)
{
    complete_cooking();
}


// Fuel expiration
if (
    lit &&
    variable_global_exists("game_time") &&
    global.game_time.timestamp_reached(
        burn_finish_timestamp
    )
)
{
    extinguish();
}


if (pending_output_amount > 0)
{
    deliver_output();
}


// Player interaction
var _player =
    instance_find(
        obj_player,
        0
    );

if (!instance_exists(_player))
{
    cooking_ui_open = false;
    exit;
}

var _distance =
    point_distance(
        x,
        bbox_bottom,
        _player.x,
        _player.bbox_bottom
    );

var _nearest_campfire =
    instance_nearest(
        _player.x,
        _player.y,
        obj_campfire
    );

can_interact =
    _distance <= interaction_range &&
    _nearest_campfire == id;


if (
    cooking_ui_open &&
    (
        _distance >
        interaction_range + 32 ||
        keyboard_check_pressed(vk_escape)
    )
)
{
    cooking_ui_open = false;
}


var _interact_pressed =
    keyboard_check_pressed(
        interaction_key
    );

if (
    variable_global_exists(
        "player_input"
    )
)
{
    _interact_pressed =
        _interact_pressed ||
        global.player_input.interact_pressed;
}


if (
    can_interact &&
    _interact_pressed
)
{
    if (!lit)
    {
        light_campfire();
    }
    else
    {
        var _new_open_state =
            !cooking_ui_open;

        with (obj_campfire)
        {
            cooking_ui_open = false;
        }

        cooking_ui_open =
            _new_open_state;
    }
}


// Cooking UI input
// Cooking UI input
if (!cooking_ui_open)
{
    cooking_ui_open_amount = 0;
    exit;
}

cooking_ui_open_amount =
    lerp(
        cooking_ui_open_amount,
        1,
        0.18
    );

if (cooking_ui_open_amount > 0.995)
{
    cooking_ui_open_amount = 1;
}

campfire_ui_update_layout(id);

var _gui_width =
    display_get_gui_width();

var _gui_height =
    display_get_gui_height();

var _panel_x =
    cooking_ui_x;

var _panel_y =
    cooking_ui_y;

var _mouse_x =
    device_mouse_x_to_gui(0);

var _mouse_y =
    device_mouse_y_to_gui(0);

var _clicked =
    device_mouse_check_button_pressed(
        0,
        mb_left
    );

if (!_clicked)
{
    exit;
}


// Close button
if (
    point_in_rectangle(
        _mouse_x,
        _mouse_y,
        _panel_x +
        cooking_ui_width - 34,
        _panel_y + 10,
        _panel_x +
        cooking_ui_width - 10,
        _panel_y + 34
    )
)
{
    cooking_ui_open = false;
    exit;
}


// Recipe selection
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
    var _row_y =
        _recipe_y +
        _i *
        (
            cooking_ui_recipe_height +
            cooking_ui_recipe_gap
        );

    if (
        point_in_rectangle(
            _mouse_x,
            _mouse_y,
            _recipe_x,
            _row_y,
            _recipe_x +
            cooking_ui_recipe_width,
            _row_y +
            cooking_ui_recipe_height
        )
    )
    {
        selected_cooking_recipe =
            _i;

        exit;
    }
}


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

if (
    point_in_rectangle(
        _mouse_x,
        _mouse_y,
        _button_x,
        _button_y,
        _button_x +
        cooking_ui_button_width,
        _button_y +
        cooking_ui_button_height
    )
)
{
    start_cooking(
        selected_cooking_recipe
    );
}