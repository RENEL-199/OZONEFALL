/// HotbarPlacementSystem.gml

function hotbar_sync_placement(
    _inventory,
    _hotbar_slot,
    _inventory_open
)
{
    var _controller =
        instance_find(
            obj_placement_controller,
            0
        );

    if (!instance_exists(_controller))
    {
        return;
    }

    var _selected_item_id =
        ItemID.None;

    if (
        is_struct(_inventory) &&
        _inventory.is_valid_slot(
            _hotbar_slot
        )
    )
    {
        var _slot =
            _inventory.slots[
                _hotbar_slot
            ];

        if (!_slot.is_empty())
        {
            _selected_item_id =
                _slot.item_id;
        }
    }


    // Changing hotbar slots allows automatic placement again,
    // even if both slots contain the same item.
    if (
        _controller.last_hotbar_slot !=
        _hotbar_slot
    )
    {
        _controller.last_hotbar_slot =
            _hotbar_slot;

        _controller
        .automatic_blocked_item_id =
            ItemID.None;
    }


    // Do not show placement previews behind an open inventory.
    if (_inventory_open)
    {
        if (_controller.placement_active)
        {
            _controller.cancel_placement(
                false
            );
        }

        return;
    }


    // ------------------------------------------------------------
    // SELECTED ITEM IS PLACEABLE
    // ------------------------------------------------------------

    if (
        item_is_placeable(
            _selected_item_id
        )
    )
    {
        // Cancel a different active placeable.
        if (
            _controller.placement_active &&
            _controller.placement_item_id !=
            _selected_item_id
        )
        {
            _controller.cancel_placement(
                false
            );
        }


        // Automatically start placement.
        if (
            !_controller.placement_active &&
            _controller
            .automatic_blocked_item_id !=
            _selected_item_id
        )
        {
            item_begin_placement(
                _selected_item_id
            );
        }

        return;
    }


    // ------------------------------------------------------------
    // SELECTED ITEM IS NOT PLACEABLE
    // ------------------------------------------------------------

    if (_controller.placement_active)
    {
        _controller.cancel_placement(
            false
        );
    }
}