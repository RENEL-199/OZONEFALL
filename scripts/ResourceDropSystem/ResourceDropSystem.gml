function resource_drop_item(
    _item_id,
    _amount,
    _x,
    _y,
    _spread = 14
)
{
    if (
        _item_id == ItemID.None ||
        _amount <= 0
    )
    {
        return noone;
    }

    var _item_data =
        item_get_data(_item_id);

    if (
        is_undefined(_item_data) ||
        !sprite_exists(_item_data.sprite)
    )
    {
        show_debug_message(
            "Drop failed: invalid item or sprite."
        );

        return noone;
    }

    var _drop_x =
        _x +
        random_range(
            -_spread,
            _spread
        );

    var _drop_y =
        _y +
        random_range(
            -_spread,
            _spread
        );

    var _pickup =
        instance_create_depth(
            _drop_x,
            _drop_y,
            -_drop_y,
            obj_pickup_parent
        );

    if (!instance_exists(_pickup))
    {
        return noone;
    }

    if (
        !_pickup.setup_item(
            _item_id,
            _amount
        )
    )
    {
        with (_pickup)
        {
            instance_destroy();
        }

        return noone;
    }

    return _pickup;
}