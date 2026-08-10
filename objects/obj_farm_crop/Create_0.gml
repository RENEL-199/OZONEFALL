sprite_index = -1;
image_index = 0;
image_speed = 0;

crop_id = -1;
crop_data = undefined;

plot_instance = noone;

growth_stage = 0;
maximum_growth_stage = 0;

stage_progress_minutes = 0;
last_growth_timestamp = 0;

is_mature = false;
initialized = false;


initialize = function(
    _new_crop_id,
    _plot
)
{
    if (initialized)
    {
        show_debug_message(
            "Crop initialization failed: crop was already initialized."
        );

        return false;
    }

    if (!instance_exists(_plot))
    {
        show_debug_message(
            "Crop initialization failed: farm plot does not exist."
        );

        return false;
    }

    var _data =
        farm_crop_get(
            _new_crop_id
        );

    if (is_undefined(_data))
    {
        show_debug_message(
            "Crop initialization failed: CropID " +
            string(_new_crop_id) +
            " was not found in the farming database."
        );

        return false;
    }

    if (
        !variable_struct_exists(
            _data,
            "growth_sprite"
        ) ||
        !sprite_exists(
            _data.growth_sprite
        )
    )
    {
        show_debug_message(
            "Crop initialization failed: invalid growth sprite for CropID " +
            string(_new_crop_id)
        );

        return false;
    }

    if (
        !variable_instance_exists(
            _plot,
            "attach_crop"
        )
    )
    {
        show_debug_message(
            "Crop initialization failed: obj_farm_plot has no attach_crop method."
        );

        return false;
    }

    if (!_plot.attach_crop(id))
    {
        show_debug_message(
            "Crop initialization failed: farm plot rejected the crop."
        );

        return false;
    }

    crop_id =
        _new_crop_id;

    crop_data =
        _data;

    plot_instance =
        _plot;

    x =
        _plot.x;

    y =
        _plot.y;

    sprite_index =
        _data.growth_sprite;

    image_index = 0;
    image_speed = 0;

    growth_stage = 0;

    maximum_growth_stage =
        max(
            0,
            sprite_get_number(
                sprite_index
            ) - 1
        );

    stage_progress_minutes = 0;

    if (
        variable_global_exists(
            "game_time"
        )
    )
    {
        last_growth_timestamp =
            global.game_time
                .get_timestamp();
    }
    else
    {
        last_growth_timestamp = 0;
    }

    is_mature =
        maximum_growth_stage <= 0;

    initialized = true;

    depth =
        -bbox_bottom;

    show_debug_message(
        "Crop initialized: " +
        _data.name +
        " | frames: " +
        string(
            maximum_growth_stage + 1
        )
    );

    return true;
};


update_growth = function()
{
    if (
        !initialized ||
        is_mature ||
        !variable_global_exists(
            "game_time"
        )
    )
    {
        return false;
    }

    var _now =
        global.game_time
            .get_timestamp();

    if (
        _now <=
        last_growth_timestamp
    )
    {
        return false;
    }

    var _growth_minutes =
        _now -
        last_growth_timestamp;

    var _requires_water = true;

    if (
        variable_struct_exists(
            crop_data,
            "requires_water"
        )
    )
    {
        _requires_water =
            crop_data.requires_water;
    }

    if (_requires_water)
    {
        if (
            !instance_exists(
                plot_instance
            ) ||
            !variable_instance_exists(
                plot_instance,
                "get_watered_overlap"
            )
        )
        {
            last_growth_timestamp =
                _now;

            return false;
        }

        _growth_minutes =
            plot_instance
                .get_watered_overlap(
                    last_growth_timestamp,
                    _now
                );
    }

    last_growth_timestamp =
        _now;

    if (_growth_minutes <= 0)
    {
        return false;
    }

    stage_progress_minutes +=
        _growth_minutes;

    var _advanced = false;

    while (
        growth_stage <
        maximum_growth_stage
    )
    {
        if (
            growth_stage >=
            array_length(
                crop_data.transition_minutes
            )
        )
        {
            break;
        }

        var _required_minutes =
            max(
                1,
                crop_data.transition_minutes[
                    growth_stage
                ]
            );

        if (
            stage_progress_minutes <
            _required_minutes
        )
        {
            break;
        }

        stage_progress_minutes -=
            _required_minutes;

        growth_stage++;

        _advanced = true;
    }

    growth_stage =
        clamp(
            growth_stage,
            0,
            maximum_growth_stage
        );

    image_index =
        growth_stage;

    if (
        growth_stage >=
        maximum_growth_stage
    )
    {
        is_mature = true;
        stage_progress_minutes = 0;
    }

    if (_advanced)
    {
        repeat (2)
        {
            effect_create_above(
                ef_spark,
                x +
                irandom_range(-4, 4),
                bbox_bottom -
                irandom_range(2, 7),
                0.08,
                make_color_rgb(
                    102,
                    164,
                    75
                )
            );
        }
    }

    return _advanced;
};


release_plot = function()
{
    if (
        instance_exists(
            plot_instance
        ) &&
        variable_instance_exists(
            plot_instance,
            "detach_crop"
        )
    )
    {
        plot_instance.detach_crop(
            id
        );
    }

    plot_instance = noone;

    return true;
};