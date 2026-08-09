function inventory_find(_item_id)
{
    if (!variable_global_exists("player_inventory"))
    {
        return -1;
    }

    return global.player_inventory.find_item(_item_id);
}