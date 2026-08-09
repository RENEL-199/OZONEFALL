function grass_scatter_initialize(
    _controller,
    _layer_name,
    _tile_indices,
    _spawn_chance = 0.35
)
{
    if (!instance_exists(_controller))
    {
        return false;
    }

    _controller.scatter_tilemap_id =
        layer_tilemap_get_id(
            _layer_name
        );

    _controller.scatter_tile_indices =
        _tile_indices;

    _controller.scatter_spawn_chance =
        clamp(
            _spawn_chance,
            0,
            1
        );

    if (
        _controller.scatter_tilemap_id ==
        -1
    )
    {
        show_debug_message(
            "Grass scatter error: tilemap layer '" +
            _layer_name +
            "' does not exist."
        );

        return false;
    }

    return true;
}


function grass_scatter_try_place(
    _controller,
    _tile_x,
    _tile_y
)
{
    if (!instance_exists(_controller))
    {
        return false;
    }

    if (
        !variable_instance_exists(
            _controller,
            "scatter_tilemap_id"
        ) ||
        _controller.scatter_tilemap_id == -1
    )
    {
        return false;
    }

    var _indices =
        _controller.scatter_tile_indices;

    var _variant_count =
        array_length(_indices);

    if (_variant_count <= 0)
    {
        return false;
    }

    var _existing_tile =
        tilemap_get(
            _controller.scatter_tilemap_id,
            _tile_x,
            _tile_y
        );

    if (_existing_tile != 0)
    {
        return true;
    }

    if (
        random(1) >
        _controller.scatter_spawn_chance
    )
    {
        return false;
    }

    var _tile_index =
        _indices[
            irandom(
                _variant_count - 1
            )
        ];

    var _tile_data =
        tile_set_index(
            0,
            _tile_index
        );

    tilemap_set(
        _controller.scatter_tilemap_id,
        _tile_data,
        _tile_x,
        _tile_y
    );

    return true;
}


function grass_scatter_clear(
    _controller,
    _tile_x,
    _tile_y
)
{
    if (
        !instance_exists(_controller) ||
        !variable_instance_exists(
            _controller,
            "scatter_tilemap_id"
        ) ||
        _controller.scatter_tilemap_id == -1
    )
    {
        return false;
    }

    tilemap_set(
        _controller.scatter_tilemap_id,
        0,
        _tile_x,
        _tile_y
    );

    return true;
}