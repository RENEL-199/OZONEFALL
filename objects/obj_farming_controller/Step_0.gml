update_timer--;

if (update_timer <= 0)
{
    update_timer =
        update_interval_steps;

    with (obj_farm_crop)
    {
        if (initialized)
        {
            update_growth();
        }
    }

    with (obj_farm_plot)
    {
        refresh_state();
    }
}


global.farm_target = noone;

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


// ================================================================
// DIRECTIONAL TARGETING
// ================================================================

var _forward_x = 0;
var _forward_y = 1;

switch (_player.facing)
{
    case "up":
        _forward_y = -1;
        break;

    case "left":
        _forward_x = -1;
        _forward_y = 0;
        break;

    case "right":
        _forward_x = 1;
        _forward_y = 0;
        break;
}


var _search_x =
    _player.x +
    _forward_x *
    interaction_forward_distance;

var _search_y =
    _player.y +
    _forward_y *
    interaction_forward_distance;

var _plot =
    instance_nearest(
        _search_x,
        _search_y,
        obj_farm_plot
    );

if (!instance_exists(_plot))
{
    exit;
}


var _difference_x =
    _plot.x -
    _player.x;

var _difference_y =
    _plot.y -
    _player.y;

var _forward_distance =
    _difference_x *
    _forward_x +
    _difference_y *
    _forward_y;

var _side_distance =
    abs(
        _difference_x *
        _forward_y -
        _difference_y *
        _forward_x
    );

if (
    _forward_distance < 1 ||
    _forward_distance >
    interaction_maximum_distance ||
    _side_distance >
    interaction_side_width
)
{
    exit;
}


// ================================================================
// REFRESH TARGET
// ================================================================

_plot.refresh_state();

var _crop = noone;

if (_plot.has_valid_crop())
{
    _crop =
        _plot.crop_instance;

    if (
        instance_exists(_crop) &&
        _crop.initialized
    )
    {
        _crop.update_growth();
    }
}

if (
    instance_exists(_crop) &&
    _crop.is_mature
)
{
    global.farm_target = _crop;
}
else
{
    global.farm_target = _plot;
}


if (!player_input_interact_pressed())
{
    exit;
}


// ================================================================
// HARVEST
// ================================================================

if (
    instance_exists(_crop) &&
    _crop.is_mature
)
{
    farm_crop_harvest(_crop);
    exit;
}


// ================================================================
// SELECTED ITEM
// ================================================================

if (
    !variable_global_exists(
        "player_inventory"
    ) ||
    !variable_global_exists(
        "hotbar_selected"
    )
)
{
    exit;
}

var _inventory =
    global.player_inventory;

var _slot_index =
    global.hotbar_selected;

if (!_inventory.is_valid_slot(_slot_index))
{
    exit;
}

var _slot =
    _inventory.slots[
        _slot_index
    ];

if (_slot.is_empty())
{
    exit;
}


// ================================================================
// HOE
// ================================================================

if (_slot.item_id == ItemID.Hoe)
{
    if (_plot.has_valid_crop())
    {
        player_say(
            "Something is already growing here."
        );

        exit;
    }

    if (_plot.is_hoed)
    {
        player_say(
            "I've already tilled this soil."
        );

        exit;
    }

    if (_plot.hoe())
    {
        if (
            variable_instance_exists(
                _player,
                "start_action_animation"
            )
        )
        {
            _player.start_action_animation(
                "hoe",
                15
            );
        }

        repeat (3)
        {
            effect_create_above(
                ef_smoke,
                _plot.x +
                irandom_range(-5, 5),
                _plot.y +
                irandom_range(-3, 3),
                0.10,
                make_color_rgb(
                    103,
                    73,
                    47
                )
            );
        }
    }
    else
    {
        player_say(
            "I can't till this soil."
        );
    }

    exit;
}


// ================================================================
// WATERING CAN
// ================================================================

if (
    _slot.item_id ==
    ItemID.Watering_Can
)
{
    var _watering_state =
        farm_watering_can_get_state(
            _slot
        );

    if (!is_struct(_watering_state))
    {
        player_say(
            "Something is wrong with my watering can."
        );

        exit;
    }

    if (
        _watering_state.current_water <= 0
    )
    {
        player_say(
            "My watering can is empty."
        );

        exit;
    }

    if (!_plot.is_hoed)
    {
        player_say(
            "I should till this soil first."
        );

        exit;
    }

    _plot.refresh_state();

    if (_plot.is_wet())
    {
        player_say(
            "This soil is already watered."
        );

        exit;
    }

    var _transferred =
        _plot.add_water(
            _watering_state.current_water
        );

    if (_transferred <= 0)
    {
        player_say(
            "I can't water this soil."
        );

        exit;
    }

    _watering_state.current_water -=
        _transferred;

    _watering_state.current_water =
        clamp(
            _watering_state.current_water,
            0,
            _watering_state.maximum_water
        );

    exit;
}


// ================================================================
// PLANT SEED
// ================================================================

var _crop_data =
    farm_crop_get_from_seed(
        _slot.item_id
    );

if (is_undefined(_crop_data))
{
    exit;
}

if (!_plot.is_hoed)
{
    player_say(
        "I should till this soil first."
    );

    exit;
}

if (_plot.has_valid_crop())
{
    player_say(
        "Something is already planted here."
    );

    exit;
}

if (!_plot.can_accept_crop())
{
    player_say(
        "I can't plant anything here."
    );

    exit;
}

var _new_crop =
    farm_crop_spawn(
        _plot,
        _crop_data.crop_id
    );

if (!instance_exists(_new_crop))
{
    player_say(
        "This seed won't grow here."
    );

    exit;
}

if (
    !_inventory.remove_from_slot(
        _slot_index,
        1
    )
)
{
    with (_new_crop)
    {
        instance_destroy();
    }

    player_say(
        "I couldn't plant the seed."
    );

    exit;
}

repeat (3)
{
    effect_create_above(
        ef_spark,
        _plot.x +
        irandom_range(-4, 4),
        _plot.y +
        irandom_range(-3, 3),
        0.08,
        make_color_rgb(
            109,
            153,
            72
        )
    );
}