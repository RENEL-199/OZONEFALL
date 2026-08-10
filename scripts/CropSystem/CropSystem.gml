enum CropID
{
    Pumpkin = 0
}


function CropData(
    _name,
    _seed_item_id,
    _crop_object,
    _growth_sprite,
    _stage_duration_minutes
)
constructor
{
    name = _name;
    seed_item_id = _seed_item_id;
    crop_object = _crop_object;
    growth_sprite = _growth_sprite;

    stage_duration_minutes =
        max(
            1,
            floor(
                _stage_duration_minutes
            )
        );
}


function crop_database_create()
{
    global.crop_database = [];

    global.crop_database[
        CropID.Pumpkin
    ] = new CropData(
        "Pumpkin",
        ItemID.Pumpkin_seed,
        obj_pumpkin,
        spr_pumpkin_sheet,
        24 * 60
    );
}


function crop_get(_crop_id)
{
    if (
        !variable_global_exists(
            "crop_database"
        ) ||
        _crop_id < 0 ||
        _crop_id >=
        array_length(
            global.crop_database
        )
    )
    {
        return undefined;
    }

    return
        global.crop_database[
            _crop_id
        ];
}


function crop_get_from_seed(
    _seed_item_id
)
{
    if (
        !variable_global_exists(
            "crop_database"
        )
    )
    {
        return undefined;
    }

    var _count =
        array_length(
            global.crop_database
        );

    for (
        var _i = 0;
        _i < _count;
        _i++
    )
    {
        var _crop_data =
            global.crop_database[_i];

        if (
            !is_undefined(_crop_data) &&
            _crop_data.seed_item_id ==
            _seed_item_id
        )
        {
            return _crop_data;
        }
    }

    return undefined;
}


function crop_is_seed(_item_id)
{
    return !is_undefined(
        crop_get_from_seed(
            _item_id
        )
    );
}


function crop_initialize(
    _crop,
    _crop_id
)
{
    if (!instance_exists(_crop))
    {
        return false;
    }

    var _crop_data =
        crop_get(_crop_id);

    if (is_undefined(_crop_data))
    {
        return false;
    }

    _crop.crop_id = _crop_id;

    _crop.sprite_index =
        _crop_data.growth_sprite;

    _crop.image_index = 0;
    _crop.image_speed = 0;

    _crop.growth_stage = 0;

    _crop.maximum_growth_stage =
        max(
            0,
            sprite_get_number(
                _crop_data.growth_sprite
            ) - 1
        );

    _crop.stage_duration_minutes =
        _crop_data.stage_duration_minutes;

    _crop.watered_growth_minutes = 0;

    _crop.last_growth_timestamp =
        variable_global_exists(
            "game_time"
        )
            ? global.game_time.get_timestamp()
            : 0;

    _crop.is_mature =
        _crop.maximum_growth_stage <= 0;

    return true;
}


function crop_growth_update(_crop)
{
    if (
        !instance_exists(_crop) ||
        _crop.is_mature ||
        !variable_global_exists(
            "game_time"
        )
    )
    {
        return false;
    }

    var _now =
        global.game_time.get_timestamp();

    var _previous =
        _crop.last_growth_timestamp;

    if (_now <= _previous)
    {
        return false;
    }

    var _soil =
        _crop.planted_soil_id;

    var _watered_minutes = 0;

    if (
        instance_exists(_soil) &&
        _soil.is_hoed &&
        _soil.wet_finish_timestamp >
        _soil.wet_start_timestamp
    )
    {
        var _overlap_start =
            max(
                _previous,
                _soil.wet_start_timestamp
            );

        var _overlap_finish =
            min(
                _now,
                _soil.wet_finish_timestamp
            );

        _watered_minutes =
            max(
                0,
                _overlap_finish -
                _overlap_start
            );
    }

    _crop.last_growth_timestamp =
        _now;

    if (_watered_minutes <= 0)
    {
        return false;
    }

    _crop.watered_growth_minutes +=
        _watered_minutes;

    var _advanced = false;

    while (
        _crop.watered_growth_minutes >=
        _crop.stage_duration_minutes &&
        _crop.growth_stage <
        _crop.maximum_growth_stage
    )
    {
        _crop.watered_growth_minutes -=
            _crop.stage_duration_minutes;

        _crop.growth_stage++;

        _advanced = true;
    }

    _crop.image_index =
        _crop.growth_stage;

    if (
        _crop.growth_stage >=
        _crop.maximum_growth_stage
    )
    {
        _crop.growth_stage =
            _crop.maximum_growth_stage;

        _crop.image_index =
            _crop.maximum_growth_stage;

        _crop.watered_growth_minutes = 0;
        _crop.is_mature = true;
    }

    if (_advanced)
    {
        repeat (2)
        {
            effect_create_above(
                ef_spark,
                _crop.x +
                irandom_range(-4, 4),
                _crop.bbox_bottom -
                irandom_range(2, 8),
                0.10,
                make_color_rgb(
                    102,
                    164,
                    75
                )
            );
        }
    }

    return _advanced;
}