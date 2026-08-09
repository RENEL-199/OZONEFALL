/// SaveSystem.gml

function core_save_get(
    _source,
    _key,
    _default_value = undefined
)
{
    if (!is_struct(_source))
    {
        return _default_value;
    }

    if (
        !variable_struct_exists(
            _source,
            _key
        )
    )
    {
        return _default_value;
    }

    return variable_struct_get(
        _source,
        _key
    );
}


function core_save_get_number(
    _source,
    _key,
    _default_value
)
{
    var _value =
        core_save_get(
            _source,
            _key,
            _default_value
        );

    if (!is_real(_value))
    {
        return _default_value;
    }

    return _value;
}


function core_save_inventory_to_data(
    _inventory
)
{
    if (!is_struct(_inventory))
    {
        return [];
    }

    var _saved_slots =
        array_create(
            _inventory.size
        );

    for (
        var _slot_index = 0;
        _slot_index < _inventory.size;
        _slot_index++
    )
    {
        var _slot =
            _inventory.slots[
                _slot_index
            ];

        _saved_slots[_slot_index] =
        {
            item_id: _slot.item_id,
            amount: _slot.amount
        };
    }

    return _saved_slots;
}


function core_save_build_data()
{
    if (
        !variable_global_exists(
            "player_inventory"
        ) ||
        !variable_global_exists(
            "survival"
        ) ||
        !variable_global_exists(
            "game_time"
        )
    )
    {
        return undefined;
    }

    if (
        !is_struct(
            global.player_inventory
        ) ||
        !is_struct(
            global.survival
        ) ||
        !is_struct(
            global.game_time
        )
    )
    {
        return undefined;
    }

    var _player =
        instance_find(
            obj_player,
            0
        );

    if (!instance_exists(_player))
    {
        return undefined;
    }

    var _hotbar_selected = 0;

    if (
        variable_global_exists(
            "hotbar_selected"
        )
    )
    {
        _hotbar_selected =
            global.hotbar_selected;
    }

  var _save_data =
{
    save_version: 1,

    saved_at:
        date_current_datetime(),

        room_name:
            room_get_name(room),

        player:
        {
            x: _player.x,
            y: _player.y
        },

        inventory:
        {
            size:
                global.player_inventory.size,

            slots:
                core_save_inventory_to_data(
                    global.player_inventory
                )
        },

        hotbar_selected:
            _hotbar_selected,

        survival:
        {
            vitality:
                global.survival.vitality,

            hunger:
                global.survival.hunger,

            hydration:
                global.survival.hydration,

            toxicity:
                global.survival.toxicity,

            stamina:
                global.survival.stamina,

            stamina_regen_timer:
                global.survival
                    .stamina_regen_timer,

            exhausted:
                global.survival.exhausted,

            is_dead:
                global.survival.is_dead
        },

        game_time:
        {
            total_minutes:
                global.game_time
                    .total_minutes,

            minute_fraction:
                global.game_time
                    .minute_fraction
        }
    };

    return _save_data;
}


function core_save_apply_inventory(
    _inventory,
    _inventory_data
)
{
    if (
        !is_struct(_inventory) ||
        !is_struct(_inventory_data)
    )
    {
        return false;
    }

    var _saved_slots =
        core_save_get(
            _inventory_data,
            "slots",
            undefined
        );

    if (!is_array(_saved_slots))
    {
        return false;
    }

    for (
        var _clear_index = 0;
        _clear_index < _inventory.size;
        _clear_index++
    )
    {
        _inventory.slots[
            _clear_index
        ].clear();
    }

    var _slots_to_restore =
        min(
            _inventory.size,
            array_length(
                _saved_slots
            )
        );

    for (
        var _slot_index = 0;
        _slot_index < _slots_to_restore;
        _slot_index++
    )
    {
        var _saved_slot =
            _saved_slots[
                _slot_index
            ];

        if (!is_struct(_saved_slot))
        {
            continue;
        }

        var _item_id =
            core_save_get_number(
                _saved_slot,
                "item_id",
                ItemID.None
            );

        var _amount =
            core_save_get_number(
                _saved_slot,
                "amount",
                0
            );

        _item_id =
            floor(_item_id);

        _amount =
            floor(_amount);

        if (
            _item_id == ItemID.None ||
            _amount <= 0
        )
        {
            continue;
        }

        var _item_data =
            item_get_data(
                _item_id
            );

        if (is_undefined(_item_data))
        {
            continue;
        }

        _amount =
            clamp(
                _amount,
                1,
                _item_data.max_stack
            );

        _inventory.slots[
            _slot_index
        ].item_id = _item_id;

        _inventory.slots[
            _slot_index
        ].amount = _amount;
    }

    return true;
}


function core_save_apply_data(
    _save_data
)
{
    if (!is_struct(_save_data))
    {
        return false;
    }

    var _save_version =
        floor(
            core_save_get_number(
                _save_data,
                "save_version",
                -1
            )
        );

    if (_save_version != 1)
    {
        return false;
    }

    if (
        !variable_global_exists(
            "player_inventory"
        ) ||
        !variable_global_exists(
            "survival"
        ) ||
        !variable_global_exists(
            "game_time"
        )
    )
    {
        return false;
    }

    var _player =
        instance_find(
            obj_player,
            0
        );

    if (!instance_exists(_player))
    {
        return false;
    }

    var _player_data =
        core_save_get(
            _save_data,
            "player",
            undefined
        );

    var _inventory_data =
        core_save_get(
            _save_data,
            "inventory",
            undefined
        );

    var _survival_data =
        core_save_get(
            _save_data,
            "survival",
            undefined
        );

    var _time_data =
        core_save_get(
            _save_data,
            "game_time",
            undefined
        );

    if (
        !is_struct(_player_data) ||
        !is_struct(_inventory_data) ||
        !is_struct(_survival_data) ||
        !is_struct(_time_data)
    )
    {
        return false;
    }

    var _player_x =
        core_save_get_number(
            _player_data,
            "x",
            _player.x
        );

    var _player_y =
        core_save_get_number(
            _player_data,
            "y",
            _player.y
        );

    var _total_minutes =
        core_save_get_number(
            _time_data,
            "total_minutes",
            global.game_time
                .total_minutes
        );

    var _minute_fraction =
        core_save_get_number(
            _time_data,
            "minute_fraction",
            0
        );

    if (
        !core_save_apply_inventory(
            global.player_inventory,
            _inventory_data
        )
    )
    {
        return false;
    }

    var _survival =
        global.survival;

    _survival.vitality =
        clamp(
            core_save_get_number(
                _survival_data,
                "vitality",
                _survival.vitality
            ),
            0,
            _survival.max_vitality
        );

    _survival.hunger =
        clamp(
            core_save_get_number(
                _survival_data,
                "hunger",
                _survival.hunger
            ),
            0,
            _survival.max_hunger
        );

    _survival.hydration =
        clamp(
            core_save_get_number(
                _survival_data,
                "hydration",
                _survival.hydration
            ),
            0,
            _survival.max_hydration
        );

    _survival.toxicity =
        clamp(
            core_save_get_number(
                _survival_data,
                "toxicity",
                _survival.toxicity
            ),
            0,
            _survival.max_toxicity
        );

    _survival.stamina =
        clamp(
            core_save_get_number(
                _survival_data,
                "stamina",
                _survival.stamina
            ),
            0,
            _survival.max_stamina
        );

    _survival.stamina_regen_timer =
        max(
            0,
            core_save_get_number(
                _survival_data,
                "stamina_regen_timer",
                0
            )
        );

    var _saved_exhausted =
        core_save_get(
            _survival_data,
            "exhausted",
            false
        );

    var _saved_dead =
        core_save_get(
            _survival_data,
            "is_dead",
            false
        );

    _survival.exhausted =
        _saved_exhausted == true;

    _survival.is_dead =
        _saved_dead == true;

    if (_survival.vitality <= 0)
    {
        _survival.is_dead = true;
    }

    global.game_time.total_minutes =
        max(
            0,
            floor(_total_minutes)
        );

    global.game_time.minute_fraction =
        clamp(
            _minute_fraction,
            0,
            0.999999
        );

    var _hotbar_max =
        min(
            global.player_inventory.size,
            8
        );

    if (
        variable_global_exists(
            "hotbar_size"
        )
    )
    {
        _hotbar_max =
            min(
                global.player_inventory.size,
                global.hotbar_size
            );
    }

    _hotbar_max =
        max(
            1,
            _hotbar_max
        );

    global.hotbar_selected =
        clamp(
            floor(
                core_save_get_number(
                    _save_data,
                    "hotbar_selected",
                    0
                )
            ),
            0,
            _hotbar_max - 1
        );

    _player.x = _player_x;
    _player.y = _player_y;

    _player.xprevious =
        _player_x;

    _player.yprevious =
        _player_y;

    return true;
}


function core_save_format_summary(
    _save_data
)
{
    if (!is_struct(_save_data))
    {
        return "No saved game";
    }

    var _room_name =
        string(
            core_save_get(
                _save_data,
                "room_name",
                "Unknown Room"
            )
        );

    var _time_data =
        core_save_get(
            _save_data,
            "game_time",
            undefined
        );

    if (!is_struct(_time_data))
    {
        return _room_name;
    }

    var _total_minutes =
        max(
            0,
            floor(
                core_save_get_number(
                    _time_data,
                    "total_minutes",
                    0
                )
            )
        );

    var _day =
        floor(
            _total_minutes / 1440
        ) + 1;

    var _minute_of_day =
        _total_minutes mod 1440;

    var _hour =
        _minute_of_day div 60;

    var _minute =
        _minute_of_day mod 60;

    var _suffix = "AM";

    if (_hour >= 12)
    {
        _suffix = "PM";
    }

    var _display_hour =
        _hour mod 12;

    if (_display_hour == 0)
    {
        _display_hour = 12;
    }

    var _minute_text =
        string(_minute);

    if (_minute < 10)
    {
        _minute_text =
            "0" + _minute_text;
    }

    return
        "Day " +
        string(_day) +
        "  " +
        string(_display_hour) +
        ":" +
        _minute_text +
        " " +
        _suffix +
        "  |  " +
        _room_name;
}