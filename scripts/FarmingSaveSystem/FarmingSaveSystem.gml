function farming_save_build_data()
{
    var _saved_soils = [];

    var _soil_count =
        instance_number(
            obj_plantable_soil
        );

    for (
        var _i = 0;
        _i < _soil_count;
        _i++
    )
    {
        var _soil =
            instance_find(
                obj_plantable_soil,
                _i
            );

        var _saved_crop = {};
        var _has_saved_crop = false;

        if (
            instance_exists(_soil) &&
            _soil.has_crop &&
            instance_exists(
                _soil.crop_instance
            )
        )
        {
            var _crop =
                _soil.crop_instance;

            _has_saved_crop = true;

            _saved_crop =
            {
                crop_id:
                    _crop.crop_id,

                offset_x:
                    _crop.x - _soil.x,

                offset_y:
                    _crop.y - _soil.y,

                depth:
                    _crop.depth,

                growth_stage:
                    _crop.growth_stage,

                watered_growth_minutes:
                    _crop.watered_growth_minutes,

                last_growth_timestamp:
                    _crop.last_growth_timestamp
            };
        }

        _saved_soils[
            array_length(_saved_soils)
        ] =
        {
            x: _soil.x,
            y: _soil.y,
            depth: _soil.depth,

            is_fertile:
                _soil.is_fertile,

            is_hoed:
                _soil.is_hoed,

            soil_water:
                _soil.soil_water,

            soil_water_capacity:
                _soil.soil_water_capacity,

            wet_start_timestamp:
                _soil.wet_start_timestamp,

            wet_finish_timestamp:
                _soil.wet_finish_timestamp,

            has_crop:
                _has_saved_crop,

            crop:
                _saved_crop
        };
    }

    var _saved_water_sources = [];

    var _water_source_count =
        instance_number(
            obj_water_container
        );

    for (
        var _i = 0;
        _i < _water_source_count;
        _i++
    )
    {
        var _source =
            instance_find(
                obj_water_container,
                _i
            );

        _saved_water_sources[
            array_length(
                _saved_water_sources
            )
        ] =
        {
            x: _source.x,
            y: _source.y,
            depth: _source.depth,

            maximum_water:
                _source.maximum_water,

            current_water:
                _source.current_water
        };
    }

    return
    {
        soils: _saved_soils,

        water_sources:
            _saved_water_sources
    };
}


function farming_save_apply_data(
    _farming_data
)
{
    if (!is_struct(_farming_data))
    {
        return false;
    }

    var _saved_soils =
        core_save_get(
            _farming_data,
            "soils",
            []
        );

    var _saved_water_sources =
        core_save_get(
            _farming_data,
            "water_sources",
            []
        );

    if (
        !is_array(_saved_soils) ||
        !is_array(_saved_water_sources)
    )
    {
        return false;
    }

  if (
    variable_global_exists(
        "crop_database"
    )
)
{
    var _crop_type_count =
        array_length(
            global.crop_database
        );

    for (
        var _type_index = 0;
        _type_index < _crop_type_count;
        _type_index++
    )
    {
        var _crop_data =
            global.crop_database[
                _type_index
            ];

        if (is_undefined(_crop_data))
        {
            continue;
        }

        var _crop_object =
            _crop_data.crop_object;

        for (
            var _crop_index =
                instance_number(
                    _crop_object
                ) - 1;

            _crop_index >= 0;
            _crop_index--
        )
        {
            var _crop =
                instance_find(
                    _crop_object,
                    _crop_index
                );

            if (instance_exists(_crop))
            {
                with (_crop)
                {
                    instance_destroy();
                }
            }
        }
    }
}

    with (obj_plantable_soil)
    {
        instance_destroy();
    }

    with (obj_water_container)
    {
        instance_destroy();
    }

    var _soil_count =
        array_length(
            _saved_soils
        );

    for (
        var _i = 0;
        _i < _soil_count;
        _i++
    )
    {
        var _soil_data =
            _saved_soils[_i];

        if (!is_struct(_soil_data))
        {
            continue;
        }

        var _soil_x =
            clamp(
                core_save_get_number(
                    _soil_data,
                    "x",
                    0
                ),
                0,
                room_width
            );

        var _soil_y =
            clamp(
                core_save_get_number(
                    _soil_data,
                    "y",
                    0
                ),
                0,
                room_height
            );

        var _soil_depth =
            floor(
                core_save_get_number(
                    _soil_data,
                    "depth",
                    100
                )
            );

        var _soil =
            instance_create_depth(
                _soil_x,
                _soil_y,
                _soil_depth,
                obj_plantable_soil
            );

        if (!instance_exists(_soil))
        {
            continue;
        }

        _soil.is_fertile =
            core_save_get(
                _soil_data,
                "is_fertile",
                true
            ) == true;

        _soil.is_hoed =
            core_save_get(
                _soil_data,
                "is_hoed",
                false
            ) == true;

        _soil.soil_water_capacity =
            max(
                1,
                floor(
                    core_save_get_number(
                        _soil_data,
                        "soil_water_capacity",
                        _soil.soil_water_capacity
                    )
                )
            );

        _soil.soil_water =
            clamp(
                floor(
                    core_save_get_number(
                        _soil_data,
                        "soil_water",
                        0
                    )
                ),
                0,
                _soil.soil_water_capacity
            );

        _soil.wet_start_timestamp =
            max(
                0,
                core_save_get_number(
                    _soil_data,
                    "wet_start_timestamp",
                    0
                )
            );

        _soil.wet_finish_timestamp =
            max(
                0,
                core_save_get_number(
                    _soil_data,
                    "wet_finish_timestamp",
                    0
                )
            );

        _soil.has_crop = false;
        _soil.crop_instance = noone;

        var _saved_has_crop =
            core_save_get(
                _soil_data,
                "has_crop",
                false
            ) == true;

        var _crop_data =
            core_save_get(
                _soil_data,
                "crop",
                undefined
            );

        if (
            _saved_has_crop &&
            is_struct(_crop_data)
        )
        {
            var _crop_id =
                floor(
                    core_save_get_number(
                        _crop_data,
                        "crop_id",
                        CropID.Pumpkin
                    )
                );

            var _crop_database_entry =
                crop_get(_crop_id);

            if (
                !is_undefined(
                    _crop_database_entry
                )
            )
            {
                _soil.is_hoed = true;

                var _crop_x =
                    _soil.x +
                    core_save_get_number(
                        _crop_data,
                        "offset_x",
                        0
                    );

                var _crop_y =
                    _soil.y +
                    core_save_get_number(
                        _crop_data,
                        "offset_y",
                        0
                    );

                var _crop_depth =
                    floor(
                        core_save_get_number(
                            _crop_data,
                            "depth",
                            -_crop_y
                        )
                    );

                var _crop =
                    instance_create_depth(
                        _crop_x,
                        _crop_y,
                        _crop_depth,
                        _crop_database_entry
                            .crop_object
                    );

                if (instance_exists(_crop))
                {
                    _crop.planted_soil_id =
                        _soil;

                    _soil.has_crop = true;
                    _soil.crop_instance = _crop;

                    _crop.growth_stage =
                        clamp(
                            floor(
                                core_save_get_number(
                                    _crop_data,
                                    "growth_stage",
                                    0
                                )
                            ),
                            0,
                            _crop.maximum_growth_stage
                        );

                    _crop.watered_growth_minutes =
                        max(
                            0,
                            core_save_get_number(
                                _crop_data,
                                "watered_growth_minutes",
                                0
                            )
                        );

                    var _current_timestamp =
                        global.game_time
                            .get_timestamp();

                    _crop.last_growth_timestamp =
                        clamp(
                            core_save_get_number(
                                _crop_data,
                                "last_growth_timestamp",
                                _current_timestamp
                            ),
                            0,
                            _current_timestamp
                        );

                    _crop.is_mature =
                        _crop.growth_stage >=
                        _crop.maximum_growth_stage;

                    if (_crop.is_mature)
                    {
                        _crop.growth_stage =
                            _crop.maximum_growth_stage;

                        _crop.watered_growth_minutes =
                            0;
                    }

                    _crop.image_index =
                        _crop.growth_stage;
                }
            }
        }

        _soil.update_visual();
    }

    var _water_source_count =
        array_length(
            _saved_water_sources
        );

    for (
        var _i = 0;
        _i < _water_source_count;
        _i++
    )
    {
        var _source_data =
            _saved_water_sources[_i];

        if (!is_struct(_source_data))
        {
            continue;
        }

        var _source_x =
            clamp(
                core_save_get_number(
                    _source_data,
                    "x",
                    0
                ),
                0,
                room_width
            );

        var _source_y =
            clamp(
                core_save_get_number(
                    _source_data,
                    "y",
                    0
                ),
                0,
                room_height
            );

        var _source_depth =
            floor(
                core_save_get_number(
                    _source_data,
                    "depth",
                    -_source_y
                )
            );

        var _source =
            instance_create_depth(
                _source_x,
                _source_y,
                _source_depth,
                obj_water_container
            );

        if (!instance_exists(_source))
        {
            continue;
        }

        _source.maximum_water =
            max(
                1,
                floor(
                    core_save_get_number(
                        _source_data,
                        "maximum_water",
                        _source.maximum_water
                    )
                )
            );

        _source.current_water =
            clamp(
                floor(
                    core_save_get_number(
                        _source_data,
                        "current_water",
                        _source.maximum_water
                    )
                ),
                0,
                _source.maximum_water
            );

        _source.update_water_visual();
    }

    return true;
}