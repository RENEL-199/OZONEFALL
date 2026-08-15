/// obj_crafting_table_1 - Create Event

event_inherited();


// ====================================================================
// WORLD VISUALS
// ====================================================================

target_alpha = 1;
image_alpha = 1;

fade_alpha = 0.35;
fade_speed = 0.1;

depth = -bbox_bottom;


// ====================================================================
// INTERACTION
// ====================================================================

interaction_range = 48;
interaction_key = ord("E");

can_open = false;
is_open = false;

// This is a SALVAGE station.
is_crafting_station = true;
is_salvage_station = true;


// ====================================================================
// TIME CONTROL
// ====================================================================

craft_original_time_speed = 0;
craft_time_speed_active = false;

craft_minimum_real_seconds = 3;
craft_maximum_real_seconds = 12;
craft_real_seconds_per_hour = 1.5;


// ====================================================================
// MATERIAL INVENTORY
// ====================================================================
//
// Items placed into the station before salvaging.
//

material_inventory =
    new Inventory(
        5,
        "Salvage Materials"
    );


// ====================================================================
// RECIPE SELECTION
// ====================================================================

selected_recipe_id =
    SalvageID.clock_items;

active_recipe_id = -1;

recipe_scroll_index = 0;


// ====================================================================
// SALVAGE STATE
// ====================================================================

is_crafting = false;

craft_start_timestamp = 0;
craft_finish_timestamp = 0;


// ====================================================================
// PENDING OUTPUTS
// ====================================================================
//
// Salvage can produce MULTIPLE items.
//
// Example:
//
// Clock x1
//      |
//      +-- Wire x3
//      |
//      +-- Electronic Part x1
//
//

pending_outputs = [];


// ====================================================================
// MESSAGES
// ====================================================================

craft_message = "";
craft_message_timer = 0;


// ====================================================================
// UI SETTINGS
// ====================================================================

craft_ui_width = 760;
craft_ui_height = 560;

craft_ui_margin = 24;
craft_ui_panel_gap = 24;
craft_ui_padding = 48;

craft_ui_header_height = 40;
craft_ui_list_ratio = 0.37;


// Recipe list
recipe_row_height = 46;
recipe_row_gap = 16;
recipe_scrollbar_width = 8;


// Material slots
material_slot_size = 56;
material_gap = 8;


// Button
craft_button_width = 160;
craft_button_height = 48;


// Icons
recipe_icon_size = 72;
ingredient_icon_size = 38;
output_icon_size = 42;


// Progress
progress_bar_height = 18;


// ====================================================================
// UI COLORS
// ====================================================================

craft_ui_background_color =
    make_color_rgb(
        61,
        126,
        82
    );

craft_ui_panel_color =
    make_color_rgb(
        70,
        139,
        91
    );

craft_ui_border_color =
    make_color_rgb(
        30,
        65,
        43
    );

craft_ui_line_color =
    make_color_rgb(
        104,
        177,
        123
    );

craft_ui_selected_color =
    make_color_rgb(
        207,
        55,
        55
    );

craft_ui_text_color =
    c_white;

craft_ui_disabled_color =
    make_color_rgb(
        105,
        120,
        107
    );

craft_ui_missing_color =
    make_color_rgb(
        225,
        110,
        100
    );

craft_ui_available_color =
    make_color_rgb(
        220,
        245,
        218
    );


// ====================================================================
// UI FEEDBACK
// ====================================================================

craft_button_press_timer = 0;
craft_complete_flash_timer = 0;


// ====================================================================
// RELEASE CRAFTING / SALVAGE LOCK
// ====================================================================

release_crafting_lock = function()
{
    if (
        variable_global_exists(
            "gameplay_lock_owner"
        ) &&
        global.gameplay_lock_owner == id
    )
    {
        global.gameplay_lock_owner = noone;
    }


    if (
        craft_time_speed_active &&
        variable_global_exists(
            "game_time"
        )
    )
    {
        global.game_time.minutes_per_real_second =
            craft_original_time_speed;
    }


    craft_time_speed_active = false;

    return true;
};


// ====================================================================
// CHECK IF SALVAGE CAN START
// ====================================================================

can_start_crafting = function()
{
    if (is_crafting)
    {
        return false;
    }


    // Waiting for previous outputs
    if (array_length(pending_outputs) > 0)
    {
        return false;
    }


    if (
        !variable_global_exists(
            "game_time"
        )
    )
    {
        return false;
    }


    var _recipe =
        salvage_recipe_get(
            selected_recipe_id
        );


    if (is_undefined(_recipe))
    {
        return false;
    }


    return salvage_has_materials(
        material_inventory,
        _recipe
    );
};


// ====================================================================
// START SALVAGING
// ====================================================================

start_crafting = function()
{
    if (!can_start_crafting())
    {
        if (is_crafting)
        {
            craft_message =
                "Salvage is already in progress.";
        }
        else if (
            array_length(pending_outputs) > 0
        )
        {
            craft_message =
                "Collect the finished items first.";
        }
        else
        {
            craft_message =
                "Missing required materials.";
        }


        craft_message_timer = 120;

        return false;
    }


    var _recipe =
        salvage_recipe_get(
            selected_recipe_id
        );


    if (is_undefined(_recipe))
    {
        craft_message =
            "Invalid salvage recipe.";

        craft_message_timer = 120;

        return false;
    }


    // ------------------------------------------------------------
    // CONSUME REQUIRED ITEM
    // ------------------------------------------------------------

    if (
        !salvage_consume_materials(
            material_inventory,
            _recipe
        )
    )
    {
        craft_message =
            "Could not consume materials.";

        craft_message_timer = 120;

        return false;
    }


    // ------------------------------------------------------------
    // STORE ACTIVE RECIPE
    // ------------------------------------------------------------

    active_recipe_id =
        selected_recipe_id;


    // ------------------------------------------------------------
    // GAME TIME
    // ------------------------------------------------------------

    craft_start_timestamp =
        global.game_time.get_timestamp();


    craft_finish_timestamp =
        global.game_time.create_timestamp(
            _recipe.duration_minutes
        );


    // ------------------------------------------------------------
    // SPEED UP TIME DURING SALVAGE
    // ------------------------------------------------------------

    craft_original_time_speed =
        global.game_time.minutes_per_real_second;


    var _recipe_hours =
        _recipe.duration_minutes / 60;


    var _target_real_seconds =
        craft_minimum_real_seconds +
        _recipe_hours *
        craft_real_seconds_per_hour;


    _target_real_seconds =
        clamp(
            _target_real_seconds,
            craft_minimum_real_seconds,
            craft_maximum_real_seconds
        );


    var _required_time_speed =
        _recipe.duration_minutes /
        _target_real_seconds;


    global.game_time.minutes_per_real_second =
        max(
            craft_original_time_speed,
            _required_time_speed
        );


    craft_time_speed_active = true;


    // ------------------------------------------------------------
    // GAMEPLAY LOCK
    // ------------------------------------------------------------

    global.gameplay_lock_owner =
        id;


    // ------------------------------------------------------------
    // START
    // ------------------------------------------------------------

    is_crafting = true;

    craft_message =
        "Salvaging started.";

    craft_message_timer = 120;

    craft_button_press_timer = 7;


    return true;
};


// ====================================================================
// COMPLETE SALVAGING
// ====================================================================

complete_crafting = function()
{
    if (!is_crafting)
    {
        return false;
    }


    var _recipe =
        salvage_recipe_get(
            active_recipe_id
        );


    if (is_undefined(_recipe))
    {
        is_crafting = false;
        active_recipe_id = -1;

        release_crafting_lock();

        craft_message =
            "Invalid active salvage recipe.";

        craft_message_timer = 120;

        return false;
    }


    // ------------------------------------------------------------
    // CLEAR OLD OUTPUTS
    // ------------------------------------------------------------

    pending_outputs = [];


    // ------------------------------------------------------------
    // STORE EVERY OUTPUT
    // ------------------------------------------------------------

    var _output_count =
        array_length(
            _recipe.output
        );


    for (
        var _output_index = 0;
        _output_index < _output_count;
        _output_index++
    )
    {
        var _output =
            _recipe.output[
                _output_index
            ];


        array_push(
            pending_outputs,
            new Output(
                _output.name,
                _output.item_id,
                _output.amount
            )
        );
    }


    // ------------------------------------------------------------
    // SURVIVAL COST
    // ------------------------------------------------------------

    if (
        variable_global_exists(
            "survival"
        ) &&
        is_struct(
            global.survival
        )
    )
    {
        global.survival.add_hunger(
            -_recipe.hunger_cost
        );


        global.survival.add_hydration(
            -_recipe.hydration_cost
        );
    }


    // ------------------------------------------------------------
    // FINISH
    // ------------------------------------------------------------

    is_crafting = false;

    active_recipe_id = -1;

    release_crafting_lock();


    craft_complete_flash_timer = 30;


    craft_message =
        "Salvage completed.";

    craft_message_timer = 180;


    return true;
};


// ====================================================================
// DELIVER SALVAGE OUTPUTS
// ====================================================================

deliver_output = function()
{
    if (
        array_length(
            pending_outputs
        ) <= 0
    )
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


    var _all_delivered = true;


    for (
        var _index = 0;
        _index <
        array_length(
            pending_outputs
        );
        _index++
    )
    {
        var _output =
            pending_outputs[
                _index
            ];


        if (_output.amount <= 0)
        {
            continue;
        }


        var _remaining =
            global.player_inventory.add_item(
                _output.item_id,
                _output.amount
            );


        _output.amount =
            _remaining;


        pending_outputs[
            _index
        ] = _output;


        if (_remaining > 0)
        {
            _all_delivered = false;
        }
    }


    if (_all_delivered)
    {
        pending_outputs = [];


        craft_message =
            "Salvaged items added to inventory.";

        craft_message_timer = 120;


        return true;
    }


    craft_message =
        "Inventory full. Some items are waiting.";

    craft_message_timer = 120;


    return false;
};