function farm_time_get()
{
    if (
        !variable_global_exists(
            "game_time"
        )
    )
    {
        return 0;
    }

    return global.game_time.get_timestamp();
}


function farm_hotbar_get_selected_slot_index()
{
    if (
        !variable_global_exists(
            "player_inventory"
        ) ||
        !variable_global_exists(
            "hotbar_selected"
        )
    )
    {
        return -1;
    }

    var _slot_index =
        global.hotbar_selected;

    if (
        !global.player_inventory
            .is_valid_slot(_slot_index)
    )
    {
        return -1;
    }

    return _slot_index;
}


function farm_hotbar_get_selected_slot()
{
    var _slot_index =
        farm_hotbar_get_selected_slot_index();

    if (_slot_index == -1)
    {
        return undefined;
    }

    var _slot =
        global.player_inventory.slots[
            _slot_index
        ];

    if (
        is_undefined(_slot) ||
        _slot.is_empty()
    )
    {
        return undefined;
    }

    return _slot;
}


function farm_watering_can_get_state(
    _slot
)
{
    if (
        !is_struct(_slot) ||
        _slot.item_id !=
        ItemID.Watering_Can
    )
    {
        return undefined;
    }

    if (
        !variable_struct_exists(
            _slot,
            "state"
        ) ||
        !is_struct(_slot.state)
    )
    {
        _slot.state =
        {
            current_water : 0,
            maximum_water : 500
        };
    }

    if (
        !variable_struct_exists(
            _slot.state,
            "maximum_water"
        )
    )
    {
        _slot.state.maximum_water = 500;
    }

    if (
        !variable_struct_exists(
            _slot.state,
            "current_water"
        )
    )
    {
        _slot.state.current_water = 0;
    }

    _slot.state.maximum_water =
        max(
            1,
            floor(
                _slot.state.maximum_water
            )
        );

    _slot.state.current_water =
        clamp(
            floor(
                _slot.state.current_water
            ),
            0,
            _slot.state.maximum_water
        );

    return _slot.state;
}


function farm_crop_spawn(
    _plot,
    _crop_id
)
{
    if (!instance_exists(_plot))
    {
        show_debug_message(
            "Crop spawn failed: farm plot does not exist."
        );

        return noone;
    }

    if (
        !variable_instance_exists(
            _plot,
            "can_accept_crop"
        ) ||
        !_plot.can_accept_crop()
    )
    {
        show_debug_message(
            "Crop spawn failed: farm plot cannot accept a crop."
        );

        return noone;
    }

    var _crop_data =
        farm_crop_get(
            _crop_id
        );

    if (is_undefined(_crop_data))
    {
        show_debug_message(
            "Crop spawn failed: invalid CropID " +
            string(_crop_id)
        );

        return noone;
    }

    var _crop =
        instance_create_depth(
            _plot.x,
            _plot.y,
            -_plot.y,
            obj_farm_crop
        );

    if (!instance_exists(_crop))
    {
        show_debug_message(
            "Crop spawn failed: obj_farm_crop could not be created."
        );

        return noone;
    }

    if (
        !_crop.initialize(
            _crop_id,
            _plot
        )
    )
    {
        with (_crop)
        {
            instance_destroy();
        }

        return noone;
    }

    return _crop;
}


function farm_crop_harvest(_crop)
{
    if (
        !instance_exists(_crop) ||
        !_crop.initialized
    )
    {
        return false;
    }

    _crop.update_growth();

    if (!_crop.is_mature)
    {
        return false;
    }

    var _crop_data =
        farm_crop_get(
            _crop.crop_id
        );

    if (!is_struct(_crop_data))
    {
        return false;
    }

    var _produce_amount =
        irandom_range(
            _crop_data.produce_minimum,
            _crop_data.produce_maximum
        );

    var _seed_amount =
        irandom_range(
            _crop_data.seed_minimum,
            _crop_data.seed_maximum
        );

    if (
        _crop_data.produce_item_id !=
        ItemID.None &&
        _produce_amount > 0
    )
    {
        resource_drop_item(
            _crop_data.produce_item_id,
            _produce_amount,
            _crop.x,
            _crop.bbox_bottom,
            10
        );
    }

    if (
        _crop_data.seed_item_id !=
        ItemID.None &&
        _seed_amount > 0
    )
    {
        resource_drop_item(
            _crop_data.seed_item_id,
            _seed_amount,
            _crop.x,
            _crop.bbox_bottom,
            10
        );
    }

    repeat (5)
    {
        effect_create_above(
            ef_spark,
            _crop.x +
            irandom_range(-6, 6),
            _crop.bbox_bottom -
            irandom_range(2, 10),
            0.12,
            choose(
                make_color_rgb(
                    235,
                    139,
                    54
                ),
                make_color_rgb(
                    103,
                    164,
                    75
                )
            )
        );
    }

    if (
        _crop_data.regrow_stage >= 0 &&
        _crop_data.regrow_stage <
        _crop.maximum_stage
    )
    {
        _crop.stage_index =
            _crop_data.regrow_stage;

        _crop.stage_progress_minutes = 0;

        _crop.image_index =
            _crop.stage_index;

        _crop.last_update_timestamp =
            farm_time_get();

        _crop.is_mature = false;

        return true;
    }

    var _plot =
        _crop.plot_instance;

    if (
        instance_exists(_plot) &&
        variable_instance_exists(
            _plot,
            "reset_after_harvest"
        )
    )
    {
        _plot.reset_after_harvest();
    }

    _crop.plot_instance =
        noone;

    with (_crop)
    {
        instance_destroy();
    }

    return true;
}