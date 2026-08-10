target_soil = noone;

if (
    !variable_global_exists(
        "game_time"
    )
)
{
    exit;
}

var _timestamp =
    global.game_time.get_timestamp();

if (_timestamp != last_time_timestamp)
{
    with (obj_crop_parent)
    {
        crop_growth_update(id);
    }

    with (obj_plantable_soil)
    {
        update_moisture();
    }

    last_time_timestamp =
        _timestamp;
}

if (gameplay_input_is_locked())
{
    exit;
}

var _player =
    instance_find(
        obj_player,
        0
    );

if (!instance_exists(_player))
{
    exit;
}

var _slot =
    farming_get_selected_slot();

if (is_undefined(_slot))
{
    exit;
}

var _selected_item =
    _slot.item_id;

if (
    _selected_item != ItemID.Hoe &&
    _selected_item != ItemID.Watering_Can
)
{
    exit;
}

var _soil =
    instance_nearest(
        _player.x,
        _player.bbox_bottom,
        obj_plantable_soil
    );

if (!instance_exists(_soil))
{
    exit;
}

var _distance =
    point_distance(
        _player.x,
        _player.bbox_bottom,
        _soil.x,
        _soil.y
    );

if (_distance > interaction_range)
{
    exit;
}

target_soil = _soil;

if (!farming_interact_pressed())
{
    exit;
}


if (_selected_item == ItemID.Hoe)
{
    if (_soil.hoe_soil())
    {
        

        effect_create_above(
            ef_smoke,
            _soil.x,
            _soil.y,
            0.15,
            make_color_rgb(
                111,
                78,
                52
            )
        );
    }


    exit;
}


if (
    _selected_item ==
    ItemID.Watering_Can
)
{
    _slot.state =
        inventory_restore_item_state(
            ItemID.Watering_Can,
            _slot.state
        );

    var _transferred =
        _soil.water_from_can(
            _slot.state
        );

    if (_transferred > 0)
    {
       

        repeat (3)
        {
            effect_create_above(
                ef_spark,
                _soil.x +
                irandom_range(-5, 5),
                _soil.y +
                irandom_range(-3, 3),
                0.12,
                make_color_rgb(
                    84,
                    160,
                    220
                )
            );
        }
    }
    else if (!_soil.is_hoed)
    {
        player_say(
            "I need to hoe this soil first."
        );
    }
    else if (
        _slot.state.current_water <= 0
    )
    {
        player_say(
            "My Watering Can is empty."
        );
    }

}