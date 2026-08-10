enum FarmCropID
{
    Pumpkin = 0,
    Kamote = 1,
    Count = 2
}


function farm_config_get(
    _config,
    _name,
    _default_value
)
{
    if (
        !is_struct(_config) ||
        !variable_struct_exists(
            _config,
            _name
        )
    )
    {
        return _default_value;
    }

    return variable_struct_get(
        _config,
        _name
    );
}


function farm_uniform_stage_times(
    _growth_sprite,
    _minutes_per_stage
)
{
    if (!sprite_exists(_growth_sprite))
    {
        return [];
    }

    var _transition_count =
        max(
            0,
            sprite_get_number(
                _growth_sprite
            ) - 1
        );

    return array_create(
        _transition_count,
        max(
            1,
            floor(_minutes_per_stage)
        )
    );
}


function FarmCropData(
    _crop_id,
    _config
)
constructor
{
    crop_id =
        _crop_id;

    name =
        string(
            farm_config_get(
                _config,
                "name",
                "Unknown Crop"
            )
        );

    seed_item_id =
        farm_config_get(
            _config,
            "seed_item_id",
            ItemID.None
        );

    produce_item_id =
        farm_config_get(
            _config,
            "produce_item_id",
            ItemID.None
        );

    growth_sprite =
        farm_config_get(
            _config,
            "growth_sprite",
            -1
        );

    transition_minutes =
        farm_config_get(
            _config,
            "transition_minutes",
            []
        );

    if (!is_array(transition_minutes))
    {
        transition_minutes = [];
    }

    produce_minimum =
        max(
            0,
            floor(
                farm_config_get(
                    _config,
                    "produce_minimum",
                    1
                )
            )
        );

    produce_maximum =
        max(
            produce_minimum,
            floor(
                farm_config_get(
                    _config,
                    "produce_maximum",
                    produce_minimum
                )
            )
        );

    seed_minimum =
        max(
            0,
            floor(
                farm_config_get(
                    _config,
                    "seed_minimum",
                    1
                )
            )
        );

    seed_maximum =
        max(
            seed_minimum,
            floor(
                farm_config_get(
                    _config,
                    "seed_maximum",
                    seed_minimum
                )
            )
        );

    requires_water =
        farm_config_get(
            _config,
            "requires_water",
            true
        );

    regrow_stage =
        floor(
            farm_config_get(
                _config,
                "regrow_stage",
                -1
            )
        );

    traits =
        farm_config_get(
            _config,
            "traits",
            {}
        );
}


function farm_crop_database_create()
{
    var _database =
        array_create(
            FarmCropID.Count,
            undefined
        );


    _database[
        FarmCropID.Pumpkin
    ] = new FarmCropData(
        FarmCropID.Pumpkin,

        {
            name:
                "Pumpkin",

            seed_item_id:
                ItemID.Pumpkin_seed,

            produce_item_id:
                ItemID.Pumpkin,

            growth_sprite:
                spr_pumpkin_sheet,

            transition_minutes:
                farm_uniform_stage_times(
                    spr_pumpkin_sheet,
                    24 * 60
                ),

            produce_minimum:
                1,

            produce_maximum:
                2,

            seed_minimum:
                1,

            seed_maximum:
                3,

            requires_water:
                true,

            regrow_stage:
                -1,

            traits:
                {}
        }
    );


    _database[
        FarmCropID.Kamote
    ] = new FarmCropData(
        FarmCropID.Kamote,

        {
            name:
                "Kamote",

            seed_item_id:
                ItemID.Kamote_seed,

            produce_item_id:
                ItemID.Kamote,

            growth_sprite:
                spr_kamote_set,

            transition_minutes:
                farm_uniform_stage_times(
                    spr_kamote_set,
                    24 * 60
                ),

            produce_minimum:
                2,

            produce_maximum:
                4,

            seed_minimum:
                1,

            seed_maximum:
                2,

            requires_water:
                true,

            regrow_stage:
                -1,

            traits:
                {}
        }
    );


    global.farm_crop_database =
        _database;


    for (
        var _i = 0;
        _i < FarmCropID.Count;
        _i++
    )
    {
        var _crop_data =
            global.farm_crop_database[
                _i
            ];

        if (!is_struct(_crop_data))
        {
            show_debug_message(
                "Farming database error: missing CropID " +
                string(_i)
            );

            continue;
        }

        if (
            !sprite_exists(
                _crop_data.growth_sprite
            )
        )
        {
            show_debug_message(
                "Farming database error: invalid growth sprite for " +
                _crop_data.name
            );
        }
    }


    show_debug_message(
        "Farming database ready: " +
        string(
            array_length(
                global.farm_crop_database
            )
        ) +
        " crops."
    );

    return true;
}


function farm_crop_get(_crop_id)
{
    if (
        !variable_global_exists(
            "farm_crop_database"
        )
    )
    {
        return undefined;
    }

    var _database =
        global.farm_crop_database;

    if (!is_array(_database))
    {
        return undefined;
    }

    var _index =
        floor(_crop_id);

    if (
        _index < 0 ||
        _index >= array_length(_database)
    )
    {
        return undefined;
    }

    var _crop_data =
        _database[_index];

    if (!is_struct(_crop_data))
    {
        return undefined;
    }

    return _crop_data;
}


function farm_crop_get_from_seed(
    _seed_item_id
)
{
    if (
        !variable_global_exists(
            "farm_crop_database"
        )
    )
    {
        return undefined;
    }

    var _database =
        global.farm_crop_database;

    if (!is_array(_database))
    {
        return undefined;
    }

    var _count =
        array_length(_database);

    for (
        var _i = 0;
        _i < _count;
        _i++
    )
    {
        var _crop_data =
            _database[_i];

        if (
            is_struct(_crop_data) &&
            _crop_data.seed_item_id ==
            _seed_item_id
        )
        {
            return _crop_data;
        }
    }

    return undefined;
}


function farm_item_is_seed(_item_id)
{
    return !is_undefined(
        farm_crop_get_from_seed(
            _item_id
        )
    );
}