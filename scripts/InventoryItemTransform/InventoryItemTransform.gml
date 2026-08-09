function inventory_can_add_amount(
    _inventory,
    _item_id,
    _amount
)
{
    if (!is_struct(_inventory))
    {
        return false;
    }

    if (
        _item_id == ItemID.None ||
        _amount <= 0
    )
    {
        return false;
    }

    var _item_data =
        item_get_data(_item_id);

    if (is_undefined(_item_data))
    {
        return false;
    }

    var _remaining =
        _amount;

    var _maximum_stack =
        _item_data.max_stack;

    for (
        var _i = 0;
        _i < _inventory.size;
        _i++
    )
    {
        var _slot =
            _inventory.slots[_i];

        if (
            _slot.item_id == _item_id &&
            _slot.amount > 0 &&
            _slot.amount < _maximum_stack
        )
        {
            _remaining -=
                min(
                    _maximum_stack -
                    _slot.amount,

                    _remaining
                );

            if (_remaining <= 0)
            {
                return true;
            }
        }
    }

    for (
        var _i = 0;
        _i < _inventory.size;
        _i++
    )
    {
        var _slot =
            _inventory.slots[_i];

        if (_slot.is_empty())
        {
            _remaining -=
                min(
                    _maximum_stack,
                    _remaining
                );

            if (_remaining <= 0)
            {
                return true;
            }
        }
    }

    return false;
}


function inventory_can_replace_one_in_slot(
    _inventory,
    _slot_index,
    _expected_item_id,
    _replacement_item_id
)
{
    if (!is_struct(_inventory))
    {
        return false;
    }

    if (
        !_inventory.is_valid_slot(
            _slot_index
        )
    )
    {
        return false;
    }

    var _slot =
        _inventory.slots[
            _slot_index
        ];

    if (
        _slot.is_empty() ||
        _slot.item_id !=
        _expected_item_id
    )
    {
        return false;
    }

    if (
        _expected_item_id ==
        _replacement_item_id
    )
    {
        return true;
    }

    // A single item can transform inside its current slot.
    if (_slot.amount == 1)
    {
        return true;
    }

    // A stacked source remains in its slot, so the replacement
    // must fit in another slot or matching stack.
    return inventory_can_add_amount(
        _inventory,
        _replacement_item_id,
        1
    );
}


function inventory_replace_one_in_slot(
    _inventory,
    _slot_index,
    _expected_item_id,
    _replacement_item_id
)
{
    if (
        !inventory_can_replace_one_in_slot(
            _inventory,
            _slot_index,
            _expected_item_id,
            _replacement_item_id
        )
    )
    {
        return false;
    }

    var _slot =
        _inventory.slots[
            _slot_index
        ];

    if (
        _expected_item_id ==
        _replacement_item_id
    )
    {
        return true;
    }

    if (_slot.amount == 1)
    {
        _slot.item_id =
            _replacement_item_id;

        _slot.amount = 1;

        return true;
    }

    _slot.amount--;

    var _remaining =
        _inventory.add_item(
            _replacement_item_id,
            1
        );

    if (_remaining > 0)
    {
        // Safety rollback.
        _slot.amount++;

        return false;
    }

    return true;
}


function inventory_use_slot(
    _inventory,
    _slot_index
)
{
    if (!is_struct(_inventory))
    {
        return false;
    }

    if (
        !_inventory.is_valid_slot(
            _slot_index
        )
    )
    {
        return false;
    }

    var _slot =
        _inventory.slots[
            _slot_index
        ];

    if (_slot.is_empty())
    {
        return false;
    }

    var _item_id =
        _slot.item_id;

    var _item_data =
        item_get_data(
            _item_id
        );

    if (is_undefined(_item_data))
    {
        return false;
    }

    var _replacement_item_id =
        _item_data
        .use_replacement_item_id;

    if (
        _replacement_item_id !=
        ItemID.None
    )
    {
        if (
            !inventory_can_replace_one_in_slot(
                _inventory,
                _slot_index,
                _item_id,
                _replacement_item_id
            )
        )
        {
            return false;
        }
    }

    if (!item_use(_item_id))
    {
        return false;
    }

    if (
        _replacement_item_id !=
        ItemID.None
    )
    {
        return inventory_replace_one_in_slot(
            _inventory,
            _slot_index,
            _item_id,
            _replacement_item_id
        );
    }

    return _inventory.remove_from_slot(
        _slot_index,
        1
    );
}