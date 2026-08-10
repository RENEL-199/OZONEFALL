event_inherited()

sprite_index = spr_soils;
image_speed = 0;
image_index = 0;

is_plantable_soil = true;
is_fertile = true;

is_hoed = false;

soil_water = 0;
soil_water_capacity = 50;

wet_duration_minutes =
    24 * 60;

wet_start_timestamp = 0;
wet_finish_timestamp = 0;

has_crop = false;
crop_instance = noone;

grid_size = 16;

var _ground_layer =
    layer_get_id(
        "Ground_Details"
    );

placement_depth = 100;

if (_ground_layer != -1)
{
    placement_depth =
        layer_get_depth(
            _ground_layer
        );
}

depth = placement_depth;


update_visual = function()
{
    if (!is_hoed)
    {
        image_index = 0;
    }
    else if (
        soil_water >=
        soil_water_capacity
    )
    {
        image_index = 2;
    }
    else
    {
        image_index = 1;
    }
};


update_moisture = function()
{
    if (
        soil_water <
        soil_water_capacity
    )
    {
        update_visual();
        return false;
    }

    if (
        variable_global_exists(
            "game_time"
        ) &&
        global.game_time.timestamp_reached(
            wet_finish_timestamp
        )
    )
    {
        soil_water = 0;

        wet_start_timestamp = 0;
        wet_finish_timestamp = 0;

        update_visual();

        return true;
    }

    update_visual();

    return false;
};


hoe_soil = function()
{
    if (is_hoed)
    {
        return false;
    }

    if (has_crop)
    {
        return false;
    }

    is_hoed = true;

    update_visual();

    return true;
};


water_from_can = function(
    _watering_can_state
)
{
    update_moisture();

    if (
        !is_hoed ||
        !is_struct(_watering_can_state)
    )
    {
        return 0;
    }

    if (
        !variable_struct_exists(
            _watering_can_state,
            "current_water"
        )
    )
    {
        return 0;
    }

    if (
        soil_water >=
        soil_water_capacity
    )
    {
        return 0;
    }

    var _available =
        max(
            0,
            floor(
                _watering_can_state
                    .current_water
            )
        );

    var _needed =
        soil_water_capacity -
        soil_water;

    var _transferred =
        min(
            _available,
            _needed
        );

    if (_transferred <= 0)
    {
        return 0;
    }

    _watering_can_state.current_water -=
        _transferred;

    soil_water +=
        _transferred;

    if (
        soil_water >=
        soil_water_capacity
    )
    {
        soil_water =
            soil_water_capacity;

        if (
            variable_global_exists(
                "game_time"
            )
        )
        {
            wet_start_timestamp =
                global.game_time
                    .get_timestamp();

            wet_finish_timestamp =
                global.game_time
                    .create_timestamp(
                        wet_duration_minutes
                    );
        }
    }

    update_visual();

    return _transferred;
};


can_accept_seed = function()
{
    update_moisture();

    if (
        has_crop &&
        !instance_exists(crop_instance)
    )
    {
        has_crop = false;
        crop_instance = noone;
    }

    return
        is_fertile &&
        is_hoed &&
        !has_crop;
};


assign_crop = function(_crop)
{
    if (
        !instance_exists(_crop) ||
        !can_accept_seed()
    )
    {
        return false;
    }

    has_crop = true;
    crop_instance = _crop;

    return true;
};


clear_crop = function()
{
    has_crop = false;
    crop_instance = noone;

    return true;
};


update_visual();