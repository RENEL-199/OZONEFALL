if (message_timer > 0)
{
    message_timer--;
}

can_interact = false;

var _player =
    instance_find(
        obj_player,
        0
    );

if (!instance_exists(_player))
{
    exit;
}

var _nearest =
    instance_nearest(
        _player.x,
        _player.y,
        obj_water_container
    );

can_interact =
    _nearest == id &&
    point_distance(
        x,
        y,
        _player.x,
        _player.y
    ) <= interaction_range;

image_index =
    current_water > 0
        ? 1
        : 0;

if (
    !can_interact ||
    !farming_interact_pressed()
)
{
    exit;
}

var _slot =
    farming_get_selected_slot();

if (
    !is_undefined(_slot) &&
    _slot.item_id ==
    ItemID.Watering_Can
)
{
    _slot.state =
        inventory_restore_item_state(
            ItemID.Watering_Can,
            _slot.state
        );

    var _needed =
        _slot.state.maximum_water -
        _slot.state.current_water;

    var _transferred =
        min(
            _needed,
            current_water
        );

    if (_transferred > 0)
    {
        _slot.state.current_water +=
            _transferred;

        current_water -=
            _transferred;

        message =
            "Filled Watering Can: " +
            string(
                _slot.state.current_water
            ) +
            "/500";
    }
    else if (current_water <= 0)
    {
        message =
            "The container is empty.";
    }
    else
    {
        message =
            "The Watering Can is full.";
    }

    message_timer = 120;
    exit;
}


// Preserve the earlier bottle-filling behavior.
if (
    current_water >= 100 &&
    variable_global_exists(
        "player_inventory"
    ) &&
    global.player_inventory.count_item(
        ItemID.Empty_water_bottle
    ) > 0
)
{
    var _remaining =
        global.player_inventory.remove_item(
            ItemID.Empty_water_bottle,
            1
        );

    if (_remaining == 0)
    {
        var _not_added =
            global.player_inventory.add_item(
                ItemID.Dirty_water_bottle,
                1
            );

        if (_not_added == 0)
        {
            current_water -= 100;

            message =
                "Filled a dirty water bottle.";
        }
        else
        {
            global.player_inventory.add_item(
                ItemID.Empty_water_bottle,
                1
            );

            message =
                "Inventory full.";
        }
    }

    message_timer = 120;
}
else
{
    message =
        current_water <= 0
            ? "The container is empty."
            : "Select a Watering Can.";

    message_timer = 120;
}