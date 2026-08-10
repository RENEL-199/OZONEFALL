function farming_interact_pressed()
{
    if (
        variable_global_exists(
            "player_input"
        ) &&
        is_struct(global.player_input) &&
        variable_struct_exists(
            global.player_input,
            "interact_pressed"
        )
    )
    {
        return
            global.player_input
                .interact_pressed;
    }

    return keyboard_check_pressed(
        ord("E")
    );
}


function farming_get_selected_slot()
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
        return undefined;
    }

    var _inventory =
        global.player_inventory;

    var _slot_index =
        global.hotbar_selected;

    if (
        !is_struct(_inventory) ||
        !_inventory.is_valid_slot(
            _slot_index
        )
    )
    {
        return undefined;
    }

    var _slot =
        _inventory.slots[
            _slot_index
        ];

    if (_slot.is_empty())
    {
        return undefined;
    }

    return _slot;
}

function watering_can_refill_slot(
    _slot,
    _available_water
)
{
    if (
        !is_struct(_slot) ||
        _slot.is_empty() ||
        _slot.item_id !=
        ItemID.Watering_Can
    )
    {
        return 0;
    }

    _slot.state =
        inventory_restore_item_state(
            ItemID.Watering_Can,
            _slot.state
        );

    var _available =
        max(
            0,
            floor(_available_water)
        );

    var _needed =
        _slot.state.maximum_water -
        _slot.state.current_water;

    var _transferred =
        min(
            _available,
            _needed
        );

    if (_transferred <= 0)
    {
        return 0;
    }

    _slot.state.current_water +=
        _transferred;

    return _transferred;
}