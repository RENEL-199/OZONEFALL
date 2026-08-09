function inventory_add(_item_id, _amount = 1)
{
    if (!variable_global_exists("player_inventory"))
    {
        show_debug_message(
            "inventory_add failed: player_inventory missing"
        );

        return false;
    }

    var _item_data = item_get_data(_item_id);

    if (is_undefined(_item_data))
    {
        show_debug_message(
            "inventory_add failed: invalid item ID " +
            string(_item_id)
        );

        return false;
    }

    var _remaining = global.player_inventory.add_item(
        _item_id,
        _amount
    );

    show_debug_message(
        "Amount remaining: " +
        string(_remaining)
    );

    return _remaining <= 0;
}