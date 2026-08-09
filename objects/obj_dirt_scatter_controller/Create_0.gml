scatter_sprite =
    spr_dirt_scatter;

// Change these if your current names are different.
ground_layer_name = "Dirt";
dirt_tile_indices =
[
      367, 368, 369, 370, 371,
    407, 408, 409, 410, 411,
    447, 448, 449, 450, 451,
    487, 488, 489, 490, 491,
    527, 528, 529, 530, 531
];

scatter_density = 0.45;
scatter_alpha = 0.90;

// Visible cache refreshes twice per second.
refresh_interval_steps = 30;
refresh_timer = 0;

ground_tilemap_id = -1;

tile_width = 16;
tile_height = 16;

scatter_x = [];
scatter_y = [];
scatter_frame = [];
scatter_xscale = [];


resolve_ground_tilemap = function()
{
    ground_tilemap_id =
        layer_tilemap_get_id(
            ground_layer_name
        );

    if (ground_tilemap_id == -1)
    {
        return false;
    }

    tile_width =
        tilemap_get_tile_width(
            ground_tilemap_id
        );

    tile_height =
        tilemap_get_tile_height(
            ground_tilemap_id
        );

    return
        tile_width > 0 &&
        tile_height > 0;
};


is_dirt_tile = function(_tile_index)
{
    var _count =
        array_length(
            dirt_tile_indices
        );

    for (
        var _i = 0;
        _i < _count;
        _i++
    )
    {
        if (
            dirt_tile_indices[_i] ==
            _tile_index
        )
        {
            return true;
        }
    }

    return false;
};


refresh_scatter_cache = function()
{
    if (
        ground_tilemap_id == -1 &&
        !resolve_ground_tilemap()
    )
    {
        return false;
    }

    var _camera =
        view_camera[0];

    if (_camera == -1)
    {
        return false;
    }

    if (!sprite_exists(scatter_sprite))
    {
        return false;
    }


    var _camera_x =
        camera_get_view_x(_camera);

    var _camera_y =
        camera_get_view_y(_camera);

    var _camera_width =
        camera_get_view_width(_camera);

    var _camera_height =
        camera_get_view_height(_camera);


    // Extra tiles prevent visible popping at the screen edges.
    var _margin_tiles = 2;

    var _left_tile =
        max(
            0,
            floor(
                _camera_x /
                tile_width
            ) -
            _margin_tiles
        );

    var _top_tile =
        max(
            0,
            floor(
                _camera_y /
                tile_height
            ) -
            _margin_tiles
        );

    var _right_tile =
        min(
            ceil(
                room_width /
                tile_width
            ) - 1,

            ceil(
                (
                    _camera_x +
                    _camera_width
                ) /
                tile_width
            ) +
            _margin_tiles
        );

    var _bottom_tile =
        min(
            ceil(
                room_height /
                tile_height
            ) - 1,

            ceil(
                (
                    _camera_y +
                    _camera_height
                ) /
                tile_height
            ) +
            _margin_tiles
        );


    scatter_x = [];
    scatter_y = [];
    scatter_frame = [];
    scatter_xscale = [];

    var _frame_count =
        max(
            1,
            sprite_get_number(
                scatter_sprite
            )
        );


    for (
        var _tile_y = _top_tile;
        _tile_y <= _bottom_tile;
        _tile_y++
    )
    {
        for (
            var _tile_x = _left_tile;
            _tile_x <= _right_tile;
            _tile_x++
        )
        {
            var _tile_data =
                tilemap_get(
                    ground_tilemap_id,
                    _tile_x,
                    _tile_y
                );

            var _tile_index =
                _tile_data &
                tile_index_mask;

            if (!is_dirt_tile(_tile_index))
            {
                continue;
            }


            // Larger four-tile clusters make the dirt look natural
            // instead of uniformly speckled.
            var _cluster_x =
                _tile_x div 4;

            var _cluster_y =
                _tile_y div 4;

            var _cluster_hash =
                abs(
                    sin(
                        _cluster_x * 27.17 +
                        _cluster_y * 91.43
                    ) *
                    43758.5453
                );

            var _cluster_random =
                _cluster_hash -
                floor(_cluster_hash);

            var _local_density =
                scatter_density *
                lerp(
                    0.45,
                    1.45,
                    _cluster_random
                );

            _local_density =
                clamp(
                    _local_density,
                    0,
                    0.80
                );


            var _placement_hash =
                abs(
                    sin(
                        _tile_x * 12.9898 +
                        _tile_y * 78.233
                    ) *
                    43758.5453
                );

            var _placement_random =
                _placement_hash -
                floor(_placement_hash);

            if (
                _placement_random >
                _local_density
            )
            {
                continue;
            }


            var _frame_hash =
                abs(
                    sin(
                        _tile_x * 53.121 +
                        _tile_y * 19.731
                    ) *
                    24634.6345
                );

            var _frame_random =
                _frame_hash -
                floor(_frame_hash);

            var _frame =
                floor(
                    _frame_random *
                    _frame_count
                );

            _frame =
                clamp(
                    _frame,
                    0,
                    _frame_count - 1
                );


            var _flip_hash =
                abs(
                    sin(
                        _tile_x * 31.73 +
                        _tile_y * 67.19
                    ) *
                    35721.8731
                );

            var _flip_random =
                _flip_hash -
                floor(_flip_hash);

            var _xscale = 1;

            if (_flip_random < 0.5)
            {
                _xscale = -1;
            }


            var _draw_x =
                _tile_x *
                tile_width;

            var _draw_y =
                _tile_y *
                tile_height;

            if (_xscale < 0)
            {
                _draw_x +=
                    tile_width;
            }


            var _entry =
                array_length(
                    scatter_x
                );

            scatter_x[_entry] =
                _draw_x;

            scatter_y[_entry] =
                _draw_y;

            scatter_frame[_entry] =
                _frame;

            scatter_xscale[_entry] =
                _xscale;
        }
    }

    return true;
};


resolve_ground_tilemap();
refresh_scatter_cache();