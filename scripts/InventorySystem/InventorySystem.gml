/// InventorySystem.gml

function InventorySlot(_item_id = -1, _amount = 0)
constructor
{
    item_id = _item_id;
    amount = _amount;

    static is_empty = function()
    {
        return item_id == -1 || amount <= 0;
    };

    static clear = function()
    {
        item_id = -1;
        amount = 0;
    };
}


function Inventory(_size, _name = "Inventory")
constructor
{
    name = _name;
    size = max(1, _size);

    slots = array_create(size);

    for (var i = 0; i < size; i++)
    {
        slots[i] = new InventorySlot();
    }

    static is_valid_slot = function(_slot)
    {
        return _slot >= 0 && _slot < size;
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
            if (slots[i].item_id == _item_id && slots[i].amount > 0)
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
        var total = 0;

        for (var i = 0; i < size; i++)
        {
            if (slots[i].item_id == _item_id)
            {
                total += slots[i].amount;
            }
        }

        return total;
    };


    static add_item = function(_item_id, _amount = 1)
    {
        if (_item_id == -1 || _amount <= 0)
        {
            return _amount;
        }

        var item_data = item_get_data(_item_id);

        if (is_undefined(item_data))
        {
            show_debug_message(
                "Inventory error: item ID " +
                string(_item_id) +
                " does not exist."
            );

            return _amount;
        }

        var remaining = _amount;
        var max_stack = item_data.max_stack;

        // First fill existing stacks.
        if (max_stack > 1)
        {
            for (var i = 0; i < size; i++)
            {
                var slot = slots[i];

                if (slot.item_id == _item_id && slot.amount < max_stack)
                {
                    var available_space = max_stack - slot.amount;
                    var amount_to_add = min(available_space, remaining);

                    slot.amount += amount_to_add;
                    remaining -= amount_to_add;

                    if (remaining <= 0)
                    {
                        return 0;
                    }
                }
            }
        }

        // Then use empty slots.
        for (var i = 0; i < size; i++)
        {
            var slot = slots[i];

            if (slot.is_empty())
            {
                var amount_to_add = min(max_stack, remaining);

                slot.item_id = _item_id;
                slot.amount = amount_to_add;

                remaining -= amount_to_add;

                if (remaining <= 0)
                {
                    return 0;
                }
            }
        }

        // Return the amount that did not fit.
        return remaining;
    };


    static remove_item = function(_item_id, _amount = 1)
    {
        if (_amount <= 0)
        {
            return 0;
        }

        var remaining = _amount;

        for (var i = size - 1; i >= 0; i--)
        {
            var slot = slots[i];

            if (slot.item_id == _item_id && slot.amount > 0)
            {
                var amount_to_remove = min(slot.amount, remaining);

                slot.amount -= amount_to_remove;
                remaining -= amount_to_remove;

                if (slot.amount <= 0)
                {
                    slot.clear();
                }

                if (remaining <= 0)
                {
                    return 0;
                }
            }
        }

        return remaining;
    };


    static swap_slots = function(_slot_a, _slot_b)
    {
        if (!is_valid_slot(_slot_a) || !is_valid_slot(_slot_b))
        {
            return false;
        }

        if (_slot_a == _slot_b)
        {
            return true;
        }

        var temp_item = slots[_slot_a].item_id;
        var temp_amount = slots[_slot_a].amount;

        slots[_slot_a].item_id = slots[_slot_b].item_id;
        slots[_slot_a].amount = slots[_slot_b].amount;

        slots[_slot_b].item_id = temp_item;
        slots[_slot_b].amount = temp_amount;

        return true;
    };


    static move_slot_to = function(_source_slot, _target_inventory, _target_slot)
    {
        if (!is_valid_slot(_source_slot))
        {
            return false;
        }

        if (!is_struct(_target_inventory))
        {
            return false;
        }

        if (!_target_inventory.is_valid_slot(_target_slot))
        {
            return false;
        }

        var source = slots[_source_slot];
        var target = _target_inventory.slots[_target_slot];

        if (source.is_empty())
        {
            return false;
        }

        // Move into an empty target.
        if (target.is_empty())
        {
            target.item_id = source.item_id;
            target.amount = source.amount;

            source.clear();
            return true;
        }

        // Combine matching stacks.
        if (target.item_id == source.item_id)
        {
            var data = item_get_data(source.item_id);
            var free_space = data.max_stack - target.amount;

            if (free_space > 0)
            {
                var amount_to_move = min(source.amount, free_space);

                target.amount += amount_to_move;
                source.amount -= amount_to_move;

                if (source.amount <= 0)
                {
                    source.clear();
                }

                return true;
            }
        }

        // Swap different items.
        var temp_item = target.item_id;
        var temp_amount = target.amount;

        target.item_id = source.item_id;
        target.amount = source.amount;

        source.item_id = temp_item;
        source.amount = temp_amount;

        return true;
    };
	
	// ====================================================================
// REMOVE FROM A SPECIFIC SLOT
//
// This is used by consumable items. It guarantees that the selected
// stack is the stack that loses an item.
// ====================================================================
static remove_from_slot = function(_slot, _amount = 1)
{
    if (!is_valid_slot(_slot)) {
        return false;
    }

    if (_amount <= 0) {
        return false;
    }

    var _inventory_slot = slots[_slot];

    if (_inventory_slot.is_empty()) {
        return false;
    }

    if (_inventory_slot.amount < _amount) {
        return false;
    }

    _inventory_slot.amount -= _amount;

    if (_inventory_slot.amount <= 0) {
        _inventory_slot.clear();
    }

    return true;
};


// ====================================================================
// SPLIT A STACK
//
// Half the selected stack is moved into the first empty slot.
// Returns false when the stack cannot be split.
// ====================================================================
static split_stack = function(_source_slot)
{
    if (!is_valid_slot(_source_slot)) {
        return false;
    }

    var _source = slots[_source_slot];

    if (_source.is_empty() || _source.amount <= 1) {
        return false;
    }

    var _empty_slot = find_empty_slot();

    if (_empty_slot == -1) {
        return false;
    }

    var _split_amount = floor(_source.amount * 0.5);

    if (_split_amount <= 0) {
        return false;
    }

    slots[_empty_slot].item_id = _source.item_id;
    slots[_empty_slot].amount = _split_amount;

    _source.amount -= _split_amount;

    return true;
};
}