/// obj_crafting_table — Step Event

can_open = false;


// ====================================================================
// UI TIMERS
// ====================================================================

if (craft_message_timer > 0)
{
    craft_message_timer--;
}

if (craft_button_press_timer > 0)
{
    craft_button_press_timer--;
}

if (craft_complete_flash_timer > 0)
{
    craft_complete_flash_timer--;
}


// ====================================================================
// CRAFTING COMPLETION
// ====================================================================

if (
    is_crafting &&
    variable_global_exists(
        "game_time"
    )
)
{
    if (
        global.game_time.timestamp_reached(
            craft_finish_timestamp
        )
    )
    {
        complete_crafting();
    }
}


// ====================================================================
// DELIVER FINISHED OUTPUT
// ====================================================================

if (pending_output_amount > 0)
{
    deliver_output();
}


// ====================================================================
// PLAYER
// ====================================================================

var _player =
    instance_find(
        obj_player,
        0
    );

if (!instance_exists(_player))
{
    exit;
}

var _distance =
    point_distance(
        x,
        y,
        _player.x,
        _player.y
    );

can_open =
    _distance <= interaction_range;


// ====================================================================
// OPEN OR CLOSE
// ====================================================================

if (
    !is_crafting &&
    can_open &&
   player_input_interact_pressed()
)
{
    var _inventory_ui =
        instance_find(
            obj_inventoryUI,
            0
        );

    if (!instance_exists(_inventory_ui))
    {
        exit;
    }

    if (
        _inventory_ui.open &&
        _inventory_ui.container_instance == id
    )
    {
        _inventory_ui.open = false;

        _inventory_ui.container_inventory =
            undefined;

        _inventory_ui.container_instance =
            noone;

        _inventory_ui.selected_inventory =
            undefined;

        _inventory_ui.selected_slot = -1;

        is_open = false;
    }
    else
    {
        if (
            instance_exists(
                _inventory_ui.container_instance
            )
        )
        {
            _inventory_ui
                .container_instance
                .is_open = false;
        }

        _inventory_ui.open = true;

        _inventory_ui.container_inventory =
            material_inventory;

        _inventory_ui.container_instance =
            id;

        _inventory_ui.active_page = 0;

        _inventory_ui.selected_inventory =
            undefined;

        _inventory_ui.selected_slot = -1;

        is_open = true;
    }
}


if (!is_open)
{
    exit;
}


// ====================================================================
// VALIDATE OPEN UI
// ====================================================================

var _ui =
    instance_find(
        obj_inventoryUI,
        0
    );

if (
    !instance_exists(_ui) ||
    !_ui.open ||
    _ui.container_instance != id
)
{
    is_open = false;
    exit;
}

if (
    !variable_global_exists(
        "crafting_recipes"
    )
)
{
    exit;
}


// ====================================================================
// UI LAYOUT
// ====================================================================

var _layout =
    crafting_ui_get_layout(
        _ui,
        self
    );

var _mouse_x =
    device_mouse_x_to_gui(0);

var _mouse_y =
    device_mouse_y_to_gui(0);

var _recipe_count =
    array_length(
        global.crafting_recipes
    );

var _visible_count =
    max(
        1,
        floor(
            (
                _layout.list_h +
                recipe_row_gap
            ) /
            (
                recipe_row_height +
                recipe_row_gap
            )
        )
    );

var _maximum_scroll =
    max(
        0,
        _recipe_count -
        _visible_count
    );

var _inside_list =
    point_in_rectangle(
        _mouse_x,
        _mouse_y,
        _layout.list_x,
        _layout.list_y,
        _layout.list_x +
        _layout.list_w,
        _layout.list_y +
        _layout.list_h
    );


// ====================================================================
// RECIPE INPUT
// Disabled while crafting.
// ====================================================================

if (!is_crafting)
{
    if (_inside_list)
    {
        if (mouse_wheel_down())
        {
            recipe_scroll_index++;
        }

        if (mouse_wheel_up())
        {
            recipe_scroll_index--;
        }
    }

    recipe_scroll_index =
        clamp(
            recipe_scroll_index,
            0,
            _maximum_scroll
        );

    if (
        _inside_list &&
        mouse_check_button_pressed(
            mb_left
        )
    )
    {
        for (
            var _visible_index = 0;
            _visible_index <
            _visible_count;
            _visible_index++
        )
        {
            var _recipe_index =
                recipe_scroll_index +
                _visible_index;

            if (
                _recipe_index >=
                _recipe_count
            )
            {
                break;
            }

            var _row_y =
                _layout.list_y +
                _visible_index *
                (
                    recipe_row_height +
                    recipe_row_gap
                );

            if (
                point_in_rectangle(
                    _mouse_x,
                    _mouse_y,
                    _layout.list_x,
                    _row_y,
                    _layout.list_x +
                    _layout.list_w,
                    _row_y +
                    recipe_row_height
                )
            )
            {
                selected_recipe_id =
                    _recipe_index;

                break;
            }
        }
    }

    var _craft_hovered =
        point_in_rectangle(
            _mouse_x,
            _mouse_y,
            _layout.craft_x,
            _layout.craft_y,
            _layout.craft_x +
            _layout.craft_w,
            _layout.craft_y +
            _layout.craft_h
        );

    if (
        _craft_hovered &&
        mouse_check_button_pressed(
            mb_left
        )
    )
    {
        start_crafting();
    }
}