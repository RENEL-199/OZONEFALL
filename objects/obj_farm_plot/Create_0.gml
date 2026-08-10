event_inherited();

sprite_index = spr_soils;
image_speed = 0;
image_index = 0;

is_farm_plot = true;
is_fertile = true;
is_hoed = false;

water_amount = 0;
water_capacity = 50;

wet_duration_minutes = 24 * 60;

wet_start_timestamp = 0;
wet_finish_timestamp = 0;

crop_instance = noone;

placement_depth = 100;

var _ground_layer =
    layer_get_id(
        "Ground_Details"
    );

if (_ground_layer != -1)
{
    placement_depth =
        layer_get_depth(
            _ground_layer
        );
}

depth = placement_depth;


get_time = function()
{
    if (!variable_global_exists("game_time"))
    {
        return 0;
    }

    return global.game_time.get_timestamp();
};


has_valid_crop = function()
{
    if (instance_exists(crop_instance))
    {
        return true;
    }

    crop_instance = noone;

    return false;
};


is_wet = function()
{
    if (
        water_amount <
        water_capacity
    )
    {
        return false;
    }

    if (wet_finish_timestamp <= 0)
    {
        return false;
    }

    return
        get_time() <
        wet_finish_timestamp;
};


update_visual = function()
{
    if (!is_hoed)
    {
        image_index = 0;
    }
    else if (is_wet())
    {
        image_index = 2;
    }
    else
    {
        image_index = 1;
    }
};


refresh_state = function()
{
    var _now =
        get_time();

    if (
        water_amount > 0 &&
        wet_finish_timestamp > 0 &&
        _now >= wet_finish_timestamp
    )
    {
        water_amount = 0;

        update_visual();

        return true;
    }

    update_visual();

    return false;
};


hoe = function()
{
    refresh_state();

    if (
        is_hoed ||
        has_valid_crop()
    )
    {
        return false;
    }

    is_hoed = true;

    update_visual();

    return true;
};


get_watered_overlap = function(
    _start_timestamp,
    _finish_timestamp
)
{
    if (
        wet_finish_timestamp <=
        wet_start_timestamp
    )
    {
        return 0;
    }

    var _overlap_start =
        max(
            _start_timestamp,
            wet_start_timestamp
        );

    var _overlap_finish =
        min(
            _finish_timestamp,
            wet_finish_timestamp
        );

    return max(
        0,
        _overlap_finish -
        _overlap_start
    );
};


add_water = function(
    _available_water
)
{
    if (has_valid_crop())
    {
        if (
            variable_instance_exists(
                crop_instance,
                "update_growth"
            )
        )
        {
            crop_instance.update_growth();
        }
    }

    refresh_state();

    if (
        !is_hoed ||
        _available_water <= 0 ||
        is_wet()
    )
    {
        return 0;
    }

    var _needed =
        water_capacity -
        water_amount;

    var _transferred =
        min(
            floor(_available_water),
            _needed
        );

    if (_transferred <= 0)
    {
        return 0;
    }

    water_amount +=
        _transferred;

    if (
        water_amount >=
        water_capacity
    )
    {
        water_amount =
            water_capacity;

        wet_start_timestamp =
            get_time();

        wet_finish_timestamp =
            wet_start_timestamp +
            wet_duration_minutes;
    }

    update_visual();

    return _transferred;
};


can_accept_crop = function()
{
    refresh_state();
    has_valid_crop();

    return
        is_fertile &&
        is_hoed &&
        crop_instance == noone;
};


attach_crop = function(_crop)
{
    if (
        !instance_exists(_crop) ||
        !can_accept_crop()
    )
    {
        return false;
    }

    crop_instance = _crop;

    return true;
};


detach_crop = function(_crop)
{
    if (
        crop_instance != _crop &&
        instance_exists(crop_instance)
    )
    {
        return false;
    }

    crop_instance = noone;

    return true;
};


reset_after_harvest = function()
{
    crop_instance = noone;

    refresh_state();

    return true;
};


update_visual();