event_inherited();

can_pickup = false;

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

var _nearest_pickup =
    instance_nearest(
        _player.x,
        _player.y,
        obj_pickable_parent
    );

can_pickup =
    _distance <= pickup_range &&
    _nearest_pickup == id;

if (
    can_pickup &&
    keyboard_check_pressed(pickup_key)
)
{
    if (
        item_id == ItemID.None ||
        amount <= 0
    )
    {
        exit;
    }

    if (
        is_undefined(
            item_get_data(item_id)
        ) ||
        !variable_global_exists(
            "player_inventory"
        )
    )
    {
        exit;
    }

    var _remaining =
        global.player_inventory.add_item(
            item_id,
            amount
        );

    amount =
        max(
            0,
            floor(_remaining)
        );

    if (amount <= 0)
    {
        instance_destroy();
        exit;
    }
}

if (sprite_exists(sprite_index))
{
    depth =
        -bbox_bottom;
}