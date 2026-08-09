event_inherited()

sprite_index = spr_campfire;
image_speed = 0;
image_index = 0;

depth = -bbox_bottom;


interaction_range = 52;
interaction_key = ord("E");

can_interact = false;
lit = false;


fuel_cost = 10;

burn_duration_minutes =
    5 * 60;

burn_start_timestamp = 0;
burn_finish_timestamp = 0;


// Lighting
light_radius = 175;
light_strength = 0.96;
light_y_offset = -8;

light_color =
    make_color_rgb(
        255,
        160,
        65
    );

warm_glow_strength = 0.18;

light_flicker = 1;
light_flicker_target = 1;
light_flicker_timer = 0;
light_flicker_amount = 0.055;


// Animation
fire_first_frame = 1;

fire_frame_count =
    max(
        1,
        sprite_get_number(sprite_index) -
        fire_first_frame
    );

fire_animation_position = 0;
fire_animation_speed = 0.14;


// Feedback
message = "";
message_timer = 0;
completion_pulse_timer = 0;


// Cooking
cooking_ui_open = false;

selected_cooking_recipe =
    CampfireRecipeID.PurifyWater;

is_cooking = false;
active_cooking_recipe = -1;

cook_start_timestamp = 0;
cook_finish_timestamp = 0;

pending_output_item_id =
    ItemID.None;

pending_output_amount = 0;


// Replace these with sprites later.
cooking_ui_background_sprite = -1;
cooking_ui_recipe_sprite = -1;
cooking_ui_selected_recipe_sprite = -1;
cooking_ui_button_sprite = -1;
cooking_ui_progress_background_sprite = -1;
cooking_ui_progress_fill_sprite = -1;


// UI layout
cooking_ui_design_width = 760;
cooking_ui_design_height = 430;

cooking_ui_width =
    cooking_ui_design_width;

cooking_ui_height =
    cooking_ui_design_height;

cooking_ui_recipe_width = 220;
cooking_ui_recipe_height = 62;
cooking_ui_recipe_gap = 8;

cooking_ui_button_width = 170;
cooking_ui_button_height = 48;

cooking_ui_text_scale = 0.88;
cooking_ui_small_text_scale = 0.70;

cooking_ui_margin = 18;
cooking_ui_side_gap = 44;

cooking_ui_x = 0;
cooking_ui_y = 0;

cooking_ui_anchor_x = 0;
cooking_ui_anchor_y = 0;

cooking_ui_side = 0;
cooking_ui_scale = 1;
cooking_ui_open_amount = 0;


// UI colors
cooking_ui_background_color =
    make_color_rgb(40, 38, 34);

cooking_ui_panel_color =
    make_color_rgb(58, 54, 47);

cooking_ui_selected_color =
    make_color_rgb(105, 82, 50);

cooking_ui_border_color =
    make_color_rgb(22, 20, 18);

cooking_ui_text_color =
    make_color_rgb(238, 225, 194);

cooking_ui_muted_color =
    make_color_rgb(174, 160, 135);

cooking_ui_available_color =
    make_color_rgb(132, 205, 105);

cooking_ui_missing_color =
    make_color_rgb(218, 91, 75);

cooking_ui_button_color =
    make_color_rgb(113, 76, 42);

cooking_ui_button_hover_color =
    make_color_rgb(151, 103, 55);

cooking_ui_button_disabled_color =
    make_color_rgb(67, 62, 55);

cooking_ui_progress_color =
    make_color_rgb(238, 155, 59);


// Message helper
set_message = function(
    _text,
    _duration = 150
)
{
    message = _text;
    message_timer = max(1, _duration);
};


// Light the campfire
light_campfire = function()
{
    if (lit)
    {
        return false;
    }

    if (
        !variable_global_exists(
            "player_inventory"
        ) ||
        !variable_global_exists(
            "game_time"
        )
    )
    {
        return false;
    }

    var _available =
        global.player_inventory.count_item(
            ItemID.Split_log
        );

    if (_available < fuel_cost)
    {
        set_message(
            "Requires " +
            string(fuel_cost) +
            " Split Logs."
        );

        return false;
    }

    var _remaining =
        global.player_inventory.remove_item(
            ItemID.Split_log,
            fuel_cost
        );

    if (_remaining > 0)
    {
        set_message(
            "Could not remove the fuel."
        );

        return false;
    }

    burn_start_timestamp =
        global.game_time.get_timestamp();

    burn_finish_timestamp =
        global.game_time.create_timestamp(
            burn_duration_minutes
        );

    lit = true;

    fire_animation_position = 0;
    image_index = fire_first_frame;

    set_message(
        "The campfire crackles to life.",
        180
    );

    return true;
};


// Extinguish
extinguish = function()
{
    lit = false;

    burn_start_timestamp = 0;
    burn_finish_timestamp = 0;

    image_index = 0;
    cooking_ui_open = false;

    if (is_cooking)
    {
        is_cooking = false;
        active_cooking_recipe = -1;

        cook_start_timestamp = 0;
        cook_finish_timestamp = 0;

        set_message(
            "The fire died before the food finished."
        );
    }
    else
    {
        set_message(
            "The campfire went out."
        );
    }
};


// Check cooking requirements
can_start_cooking = function(
    _recipe_id
)
{
    if (
        !lit ||
        is_cooking ||
        pending_output_amount > 0
    )
    {
        return false;
    }

    if (
        !variable_global_exists(
            "player_inventory"
        ) ||
        !variable_global_exists(
            "game_time"
        )
    )
    {
        return false;
    }

    var _recipe =
        campfire_recipe_get(
            _recipe_id
        );

    if (is_undefined(_recipe))
    {
        return false;
    }

    var _fuel_remaining =
        global.game_time.minutes_until(
            burn_finish_timestamp
        );

    if (
        _fuel_remaining <
        _recipe.duration_minutes
    )
    {
        return false;
    }

    return crafting_has_materials(
        global.player_inventory,
        _recipe
    );
};


// Start cooking
start_cooking = function(
    _recipe_id
)
{
    if (!lit)
    {
        set_message(
            "The campfire is not burning."
        );

        return false;
    }

    if (is_cooking)
    {
        set_message(
            "Something is already cooking."
        );

        return false;
    }

    if (pending_output_amount > 0)
    {
        set_message(
            "Make room for the cooked item."
        );

        return false;
    }

    var _recipe =
        campfire_recipe_get(
            _recipe_id
        );

    if (is_undefined(_recipe))
    {
        return false;
    }

    var _fuel_remaining =
        global.game_time.minutes_until(
            burn_finish_timestamp
        );

    if (
        _fuel_remaining <
        _recipe.duration_minutes
    )
    {
        set_message(
            "Not enough fire time remains."
        );

        return false;
    }

    if (
        !crafting_has_materials(
            global.player_inventory,
            _recipe
        )
    )
    {
        set_message(
            "Missing ingredients."
        );

        return false;
    }

    if (
        !crafting_consume_materials(
            global.player_inventory,
            _recipe
        )
    )
    {
        set_message(
            "Could not consume ingredients."
        );

        return false;
    }

    active_cooking_recipe =
        _recipe_id;

    cook_start_timestamp =
        global.game_time.get_timestamp();

    cook_finish_timestamp =
        global.game_time.create_timestamp(
            _recipe.duration_minutes
        );

    is_cooking = true;

    set_message(
        "Cooking " +
        _recipe.name +
        "..."
    );

    return true;
};


// Deliver finished output
deliver_output = function()
{
    if (pending_output_amount <= 0)
    {
        return true;
    }

    if (
        !variable_global_exists(
            "player_inventory"
        )
    )
    {
        return false;
    }

    var _remaining =
        global.player_inventory.add_item(
            pending_output_item_id,
            pending_output_amount
        );

    pending_output_amount =
        _remaining;

    if (pending_output_amount <= 0)
    {
        pending_output_item_id =
            ItemID.None;

        return true;
    }

    return false;
};


// Finish cooking
complete_cooking = function()
{
    if (!is_cooking)
    {
        return false;
    }

    var _recipe =
        campfire_recipe_get(
            active_cooking_recipe
        );

    if (is_undefined(_recipe))
    {
        is_cooking = false;
        active_cooking_recipe = -1;

        return false;
    }

    pending_output_item_id =
        _recipe.output_item_id;

    pending_output_amount +=
        _recipe.output_amount;

    is_cooking = false;
    active_cooking_recipe = -1;

    cook_start_timestamp = 0;
    cook_finish_timestamp = 0;

    completion_pulse_timer = 30;

    set_message(
        _recipe.name +
        " is ready!",
        210
    );

    deliver_output();

    return true;
};