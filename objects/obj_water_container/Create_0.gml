event_inherited()

sprite_index =
    spr_watercontainer;

image_index = 0;
image_speed = 0;

depth =
    -bbox_bottom;


maximum_water = 500;
current_water = maximum_water;

water_per_bottle = 100;

image_speed = 0;


update_water_visual = function()
{
    if (current_water <= 0)
    {
        image_index = 0;
    }
    else
    {
        image_index = 1;
    }
};


update_water_visual();




interaction_range = 42;
interaction_key = ord("E");

can_interact = false;


message = "";
message_timer = 0;

prompt_scale = 0.5;


get_selected_empty_bottle_slot = function()
{
    if (
        !variable_global_exists(
            "player_inventory"
        ) ||
        !variable_global_exists(
            "hotbar_selected"
        )
    )
    {
        return -1;
    }

    var _inventory =
        global.player_inventory;

    var _slot_index =
        global.hotbar_selected;

    if (
        !_inventory.is_valid_slot(
            _slot_index
        )
    )
    {
        return -1;
    }

    var _slot =
        _inventory.slots[
            _slot_index
        ];

    if (
        _slot.is_empty() ||
        _slot.item_id !=
        ItemID.Empty_water_bottle
    )
    {
        return -1;
    }

    return _slot_index;
};


fill_selected_bottle = function()
{
    if (
        current_water <
        water_per_bottle
    )
    {
        message =
            "Not enough water.";

        message_timer = 120;

        return false;
    }

    var _slot_index =
        get_selected_empty_bottle_slot();

    if (_slot_index == -1)
    {
        message =
            "Select an Empty Water Bottle.";

        message_timer = 120;

        return false;
    }

    if (
        !inventory_replace_one_in_slot(
            global.player_inventory,
            _slot_index,
            ItemID.Empty_water_bottle,
            ItemID.Dirty_water_bottle
        )
    )
    {
        message =
            "No room for the filled bottle.";

        message_timer = 120;

        return false;
    }

    current_water -=
        water_per_bottle;

    current_water =
        clamp(
            current_water,
            0,
            maximum_water
        );
		
		update_water_visual();

    message =
        "Filled with Dirty Water.";

    message_timer = 120;

    return true;
};