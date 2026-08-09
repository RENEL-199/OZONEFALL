/// obj_pickable_parent — Create Event

event_inherited();


// ====================================================================
// ITEM DATA
// ====================================================================

item_id = ItemID.None;
amount = 1;


// ====================================================================
// INTERACTION
// ====================================================================

pickup_range = 16;
pickup_key = ord("E");

can_pickup = false;

image_speed = 0;


// ====================================================================
// CONFIGURE DYNAMIC PICKUP
//
// Tree, rock, plant, and enemy drops call this after creating a pickup.
// ====================================================================

setup_item = function(
    _item_id,
    _amount = 1
)
{
    var _item_data =
        item_get_data(_item_id);

    if (is_undefined(_item_data))
    {
        show_debug_message(
            "Pickup setup failed: invalid ItemID " +
            string(_item_id)
        );

        return false;
    }

    if (!sprite_exists(_item_data.sprite))
    {
        show_debug_message(
            "Pickup setup failed: " +
            _item_data.name +
            " has an invalid sprite."
        );

        return false;
    }

    item_id = _item_id;
    amount = max(
        1,
        floor(_amount)
    );

    sprite_index =
        _item_data.sprite;

    image_index = 0;
    image_speed = 0;

    depth = -bbox_bottom;

    return true;
};


// ====================================================================
// REFRESH AN EXISTING CHILD PICKUP
//
// Optional: child pickup objects can call this after setting item_id.
// ====================================================================

refresh_item = function()
{
    return setup_item(
        item_id,
        amount
    );
};


depth = -bbox_bottom;