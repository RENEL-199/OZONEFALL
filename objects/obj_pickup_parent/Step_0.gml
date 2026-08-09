/// obj_pickable_parent — Step Event

event_inherited();

can_pickup = false;


// ====================================================================
// PLAYER CHECK
// ====================================================================

var _player =
    instance_find(obj_player, 0);

if (!instance_exists(_player))
{
    exit;
}


// ====================================================================
// DISTANCE AND NEAREST PICKUP
// ====================================================================

var _distance =
    point_distance(
        x,
        y,
        _player.x,
        _player.y
    );

var _nearest_pickup =
    instance_nearest(
        _player.x,
        _player.y,
        obj_pickup_parent
    );

// Only one nearby pickup responds to E.
can_pickup =
    _distance <= pickup_range &&
    _nearest_pickup == id;


// ====================================================================
// PICKUP INPUT
// ====================================================================

if (
    can_pickup &&
    keyboard_check_pressed(pickup_key)
)
{
    if (item_id == ItemID.None)
    {
        show_debug_message(
            "Pickup failed: item_id is ItemID.None"
        );

        exit;
    }

    var _item_data =
        item_get_data(item_id);

    if (is_undefined(_item_data))
    {
        show_debug_message(
            "Pickup failed: invalid ItemID " +
            string(item_id)
        );

        exit;
    }

    if (
        !variable_global_exists(
            "player_inventory"
        )
    )
    {
        show_debug_message(
            "Pickup failed: global.player_inventory does not exist"
        );

        exit;
    }


    // add_item returns the amount that could not fit.
    var _remaining =
        global.player_inventory.add_item(
            item_id,
            amount
        );


    // Everything fitted.
    if (_remaining <= 0)
    {
        instance_destroy();
        exit;
    }


    // Only part of the stack fitted.
    // Leave the remaining quantity in the world.
    if (_remaining < amount)
    {
        amount = _remaining;

        show_debug_message(
            "Inventory partially full. " +
            string(amount) +
            " item(s) remain."
        );
    }
    else
    {
        show_debug_message(
            "Pickup failed: inventory is full."
        );
    }
}


// ====================================================================
// DEPTH
// ====================================================================

if (sprite_exists(sprite_index))
{
    depth = -bbox_bottom ;
}