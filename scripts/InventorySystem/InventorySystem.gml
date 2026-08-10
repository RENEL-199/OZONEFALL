function inventory_create_item_state(_item_id)
{
    switch (_item_id)
    {
        case ItemID.Watering_Can:
            return {
                current_water : 0,
                maximum_water : 500
            };
    }

    return undefined;
}


function inventory_restore_item_state(
    _item_id,
    _saved_state
)
{
    var _state =
        inventory_create_item_state(
            _item_id
        );

    if (is_undefined(_state))
    {
        return undefined;
    }

    if (
        _item_id ==
        ItemID.Watering_Can
    )
    {
        var _water = 0;

        if (
            is_struct(_saved_state) &&
            variable_struct_exists(
                _saved_state,
                "current_water"
            ) &&
            is_real(
                _saved_state.current_water
            )
        )
        {
            _water =
                _saved_state.current_water;
        }

        _state.current_water =
            clamp(
                floor(_water),
                0,
                _state.maximum_water
            );
    }

    return _state;
}


function InventorySlot(
    _item_id = ItemID.None,
    _amount = 0,
    _state = undefined
)
constructor
{
    item_id = _item_id;
    amount = _amount;
    state = _state;

    static is_empty = function()
    {
        return
            item_id == ItemID.None ||
            amount <= 0;
    };

    static clear = function()
    {
        item_id = ItemID.None;
        amount = 0;
        state = undefined;
    };
}


function Inventory(
    _size,
    _name = "Inventory"
)
constructor
{
    name = _name;
    size = max(1, _size);

    slots =
        array_create(size);

    for (var i = 0; i < size; i++)
    {
        slots[i] =
            new InventorySlot();
    }


    static is_valid_slot = function(_slot)
    {
        return
            _slot >= 0 &&
            _slot < size;
    };


    static get_slot = function(_slot)
    {
        if (!is_valid_slot(_slot))
        {
            return undefined;
        }

        return slots[_slot];
    };


    static clear_slot = function(_slot)
    {
        if (!is_valid_slot(_slot))
        {
            return false;
        }

        slots[_slot].clear();

        return true;
    };


    static find_item = function(_item_id)
    {
        for (var i = 0; i < size; i++)
        {
            if (
                slots[i].item_id == _item_id &&
                slots[i].amount > 0
            )
            {
                return i;
            }
        }

        return -1;
    };


    static find_empty_slot = function()
    {
        for (var i = 0; i < size; i++)
        {
            if (slots[i].is_empty())
            {
                return i;
            }
        }

        return -1;
    };


    static count_item = function(_item_id)
    {
        var _total = 0;

        for (var i = 0; i < size; i++)
        {
            if (
                slots[i].item_id ==
                _item_id
            )
            {
                _total +=
                    slots[i].amount;
            }
        }

        return _total;
    };


    static add_item = function(
        _item_id,
        _amount = 1
    )
    {
        if (
            _item_id == ItemID.None ||
            _amount <= 0
        )
        {
            return _amount;
        }

        var _item_data =
            item_get_data(
                _item_id
            );

        if (is_undefined(_item_data))
        {
            show_debug_message(
                "Inventory error: item ID " +
                string(_item_id) +
                " does not exist."
            );

            return _amount;
        }

        var _remaining = _amount;

        var _maximum_stack =
            _item_data.max_stack;


        if (_maximum_stack > 1)
        {
            for (var i = 0; i < size; i++)
            {
                var _slot =
                    slots[i];

                if (
                    _slot.item_id == _item_id &&
                    _slot.amount <
                    _maximum_stack &&
                    is_undefined(_slot.state)
                )
                {
                    var _space =
                        _maximum_stack -
                        _slot.amount;

                    var _added =
                        min(
                            _space,
                            _remaining
                        );

                    _slot.amount += _added;
                    _remaining -= _added;

                    if (_remaining <= 0)
                    {
                        return 0;
                    }
                }
            }
        }


        for (var i = 0; i < size; i++)
        {
            var _slot =
                slots[i];

            if (_slot.is_empty())
            {
                var _added =
                    min(
                        _maximum_stack,
                        _remaining
                    );

                _slot.item_id =
                    _item_id;

                _slot.amount =
                    _added;

                _slot.state =
                    inventory_create_item_state(
                        _item_id
                    );

                _remaining -= _added;

                if (_remaining <= 0)
                {
                    return 0;
                }
            }
        }

        return _remaining;
    };


    static remove_item = function(
        _item_id,
        _amount = 1
    )
    {
        if (_amount <= 0)
        {
            return 0;
        }

        var _remaining =
            _amount;

        for (
            var i = size - 1;
            i >= 0;
            i--
        )
        {
            var _slot =
                slots[i];

            if (
                _slot.item_id == _item_id &&
                _slot.amount > 0
            )
            {
                var _removed =
                    min(
                        _slot.amount,
                        _remaining
                    );

                _slot.amount -= _removed;
                _remaining -= _removed;

                if (_slot.amount <= 0)
                {
                    _slot.clear();
                }

                if (_remaining <= 0)
                {
                    return 0;
                }
            }
        }

        return _remaining;
    };


    static swap_slots = function(
        _slot_a,
        _slot_b
    )
    {
        if (
            !is_valid_slot(_slot_a) ||
            !is_valid_slot(_slot_b)
        )
        {
            return false;
        }

        if (_slot_a == _slot_b)
        {
            return true;
        }

        var _temporary_item =
            slots[_slot_a].item_id;

        var _temporary_amount =
            slots[_slot_a].amount;

        var _temporary_state =
            slots[_slot_a].state;


        slots[_slot_a].item_id =
            slots[_slot_b].item_id;

        slots[_slot_a].amount =
            slots[_slot_b].amount;

        slots[_slot_a].state =
            slots[_slot_b].state;


        slots[_slot_b].item_id =
            _temporary_item;

        slots[_slot_b].amount =
            _temporary_amount;

        slots[_slot_b].state =
            _temporary_state;

        return true;
    };


    static move_slot_to = function(
        _source_slot,
        _target_inventory,
        _target_slot
    )
    {
        if (!is_valid_slot(_source_slot))
        {
            return false;
        }

        if (!is_struct(_target_inventory))
        {
            return false;
        }

        if (
            !_target_inventory.is_valid_slot(
                _target_slot
            )
        )
        {
            return false;
        }

        var _source =
            slots[_source_slot];

        var _target =
            _target_inventory.slots[
                _target_slot
            ];

        if (_source.is_empty())
        {
            return false;
        }


        if (_target.is_empty())
        {
            _target.item_id =
                _source.item_id;

            _target.amount =
                _source.amount;

            _target.state =
                _source.state;

            _source.clear();

            return true;
        }


        if (
            _target.item_id ==
            _source.item_id &&
            is_undefined(_target.state) &&
            is_undefined(_source.state)
        )
        {
            var _item_data =
                item_get_data(
                    _source.item_id
                );

            var _free_space =
                _item_data.max_stack -
                _target.amount;

            if (_free_space > 0)
            {
                var _moved =
                    min(
                        _source.amount,
                        _free_space
                    );

                _target.amount += _moved;
                _source.amount -= _moved;

                if (_source.amount <= 0)
                {
                    _source.clear();
                }

                return true;
            }
        }


        var _temporary_item =
            _target.item_id;

        var _temporary_amount =
            _target.amount;

        var _temporary_state =
            _target.state;


        _target.item_id =
            _source.item_id;

        _target.amount =
            _source.amount;

        _target.state =
            _source.state;


        _source.item_id =
            _temporary_item;

        _source.amount =
            _temporary_amount;

        _source.state =
            _temporary_state;

        return true;
    };


    static remove_from_slot = function(
        _slot,
        _amount = 1
    )
    {
        if (
            !is_valid_slot(_slot) ||
            _amount <= 0
        )
        {
            return false;
        }

        var _inventory_slot =
            slots[_slot];

        if (
            _inventory_slot.is_empty() ||
            _inventory_slot.amount <
            _amount
        )
        {
            return false;
        }

        _inventory_slot.amount -=
            _amount;

        if (_inventory_slot.amount <= 0)
        {
            _inventory_slot.clear();
        }

        return true;
    };


    static split_stack = function(
        _source_slot
    )
    {
        if (!is_valid_slot(_source_slot))
        {
            return false;
        }

        var _source =
            slots[_source_slot];

        if (
            _source.is_empty() ||
            _source.amount <= 1 ||
            !is_undefined(_source.state)
        )
        {
            return false;
        }

        var _empty_slot =
            find_empty_slot();

        if (_empty_slot == -1)
        {
            return false;
        }

        var _split_amount =
            floor(
                _source.amount *
                0.5
            );

        if (_split_amount <= 0)
        {
            return false;
        }

        slots[_empty_slot].item_id =
            _source.item_id;

        slots[_empty_slot].amount =
            _split_amount;

        slots[_empty_slot].state =
            undefined;

        _source.amount -=
            _split_amount;

        return true;
    };
}