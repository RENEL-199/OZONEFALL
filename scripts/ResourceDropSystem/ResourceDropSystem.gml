function resource_drop_item(
    _item_id,
    _amount,
    _origin_x,
    _origin_y,
    _scatter_radius = 0
)
{
    var _item_data =
        item_get_data(_item_id);

    if (
        is_undefined(_item_data) ||
        _item_id == ItemID.None
    )
    {
        return noone;
    }

    var _safe_amount =
        max(
            1,
            floor(_amount)
        );

    var _safe_radius =
        max(
            0,
            floor(_scatter_radius)
        );

    var _drop_x =
        _origin_x +
        irandom_range(
            -_safe_radius,
            _safe_radius
        );

    var _drop_y =
        _origin_y +
        irandom_range(
            -floor(_safe_radius * 0.5),
            floor(_safe_radius * 0.5)
        );

    var _pickup =
        instance_create_depth(
            _drop_x,
            _drop_y,
            -_drop_y,
            obj_pickable_parent
        );

    if (!instance_exists(_pickup))
    {
        return noone;
    }

    if (
        !variable_instance_exists(
            _pickup,
            "setup_item"
        ) ||
        !_pickup.setup_item(
            _item_id,
            _safe_amount
        )
    )
    {
        with (_pickup)
        {
            instance_destroy();
        }

        return noone;
    }

    _pickup.depth =
        -_pickup.bbox_bottom;

    return _pickup;
}