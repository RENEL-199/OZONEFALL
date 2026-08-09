function inventory_remove(_item_id, _amount = 1)
{
    if (!variable_global_exists("player_inventory"))
    {
        return false;
    }

    var before = global.player_inventory.count_item(_item_id);

    if (before < _amount)
    {
        return false;
    }

    global.player_inventory.remove_item(_item_id, _amount);
    return true;
}