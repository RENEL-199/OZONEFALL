/// obj_restoration_controller — Create Event

persistent = true;

grass_scatter_initialize(
    id,
    "Grass_Detail",
    [1, 2, 3],
    0.35
);
// ====================================================================
// TILEMAP
// ====================================================================

ground_tilemap_id =
    layer_tilemap_get_id("Dirt");
// ====================================================================
// VISUAL GROUND TILE INDICES
// ====================================================================

// All damaged-ground variations used by the visual tilemap.
damaged_tile_indices =
[
    367, 368, 369, 370, 371,
    407, 408, 409, 410, 411,
    447, 448, 449, 450, 451,
    487, 488, 489, 490, 491,
    527, 528, 529, 530, 531
];


//====================================================
// 3x3 GRASS TERRAIN TILES
// ====================================================================

grass_top_left = 175;
grass_top = 176;
grass_top_right = 177;

grass_left = 215;
grass_center = 216;
grass_right = 217;

grass_bottom_left = 255;
grass_bottom = 256;
grass_bottom_right = 257;


// All visual grass variants.
grass_tile_indices =
[
    grass_top_left,
    grass_top,
    grass_top_right,

    grass_left,
    grass_center,
    grass_right,

    grass_bottom_left,
    grass_bottom,
    grass_bottom_right
];

tile_width = 0;
tile_height = 0;

if (ground_tilemap_id != -1)
{
    tile_width =
        tilemap_get_tile_width(
            ground_tilemap_id
        );

    tile_height =
        tilemap_get_tile_height(
            ground_tilemap_id
        );
}
else
{
    show_debug_message(
        "Restoration error: tilemap layer 'Tree' does not exist."
    );
}


// ====================================================================
// RESTORATION SETTINGS
// ====================================================================

restoration_radius_tiles = 16;

// Five game hours between successfully restored tiles.
minutes_per_tile = 1;

// Prevent large time skips from changing too many tiles in one frame.
maximum_tiles_per_step = 4;


// ====================================================================
// REGISTERED MATURE TREES
// ====================================================================

restoration_sources = [];


// ====================================================================
// BUILD AND SHUFFLE CIRCULAR TILE OFFSETS
// ====================================================================

// ====================================================================
// BUILD CONNECTED OUTWARD TILE OFFSETS
//
// Uses breadth-first expansion from the tree's center. This guarantees
// that nearby tiles are processed before distant tiles and keeps the
// restored area connected.
// ====================================================================

// ====================================================================
// BUILD NATURAL CONNECTED RESTORATION SHAPE
// ====================================================================

build_tile_offsets = function(_radius)
{
    var _offsets =
    [
        {
            x : 0,
            y : 0
        }
    ];

    var _visited =
        ds_map_create();

    ds_map_add(
        _visited,
        "0_0",
        true
    );


    // Give each tree a slightly different overall shape.
    var _radius_x =
        random_range(
            _radius * 0.75,
            _radius * 1.10
        );

    var _radius_y =
        random_range(
            _radius * 0.75,
            _radius * 1.10
        );


    // Restore approximately 65–80% of the theoretical ellipse.
    // This leaves an irregular natural border.
    var _coverage =
        random_range(
            0.65,
            0.80
        );

    var _target_tiles =
        floor(
            3.14159265 *
            _radius_x *
            _radius_y *
            _coverage
        );

    _target_tiles =
        max(1, _target_tiles);


    var _directions =
    [
        [ 1,  0],
        [-1,  0],
        [ 0,  1],
        [ 0, -1]
    ];


    var _attempts = 0;

    var _maximum_attempts =
        _target_tiles * 80;


    while (
        array_length(_offsets) <
        _target_tiles &&
        _attempts <
        _maximum_attempts
    )
    {
        _attempts++;


        // Select any existing restored position.
        // The new tile must grow directly from it.
        var _source =
            _offsets[
                irandom(
                    array_length(
                        _offsets
                    ) - 1
                )
            ];

        var _direction =
            _directions[
                irandom(3)
            ];

        var _new_x =
            _source.x +
            _direction[0];

        var _new_y =
            _source.y +
            _direction[1];


        var _key =
            string(_new_x) +
            "_" +
            string(_new_y);

        if (
            ds_map_exists(
                _visited,
                _key
            )
        )
        {
            continue;
        }


        // Irregular elliptical boundary.
        var _normalized_distance =
            sqr(
                _new_x /
                _radius_x
            ) +
            sqr(
                _new_y /
                _radius_y
            );

        var _edge_variation =
            random_range(
                -0.22,
                0.16
            );

        if (
            _normalized_distance >
            1 + _edge_variation
        )
        {
            continue;
        }


        ds_map_add(
            _visited,
            _key,
            true
        );

        array_push(
            _offsets,
            {
                x : _new_x,
                y : _new_y
            }
        );
    }


    ds_map_destroy(
        _visited
    );

    return _offsets;
};


// ====================================================================
// CHECK WHETHER A TREE IS ALREADY REGISTERED
// ====================================================================

is_tree_registered = function(_tree)
{
    var _source_count =
        array_length(
            restoration_sources
        );

    for (
        var _i = 0;
        _i < _source_count;
        _i++
    )
    {
        if (
            restoration_sources[_i].tree_id ==
            _tree
        )
        {
            return true;
        }
    }

    return false;
};


// ====================================================================
// REGISTER A MATURE TREE
// ====================================================================

register_tree = function(_tree)
{
    if (!instance_exists(_tree))
    {
        return false;
    }

    if (
        ground_tilemap_id == -1 ||
        tile_width <= 0 ||
        tile_height <= 0
    )
    {
        return false;
    }

    if (!variable_global_exists("game_time"))
    {
        return false;
    }

    if (is_tree_registered(_tree))
    {
        return true;
    }


    var _origin_tile_x =
        floor(
            _tree.x /
            tile_width
        );

    var _origin_tile_y =
        floor(
            _tree.bbox_bottom /
            tile_height
        );


    var _source =
    {
        tree_id :
            _tree,

        origin_tile_x :
            _origin_tile_x,

        origin_tile_y :
            _origin_tile_y,

        offsets :
            build_tile_offsets(
                restoration_radius_tiles
            ),

        next_offset :
            0,

        next_restore_timestamp :
            global.game_time
            .create_timestamp(
                minutes_per_tile
            ),

        completed :
            false
    };


    array_push(
        restoration_sources,
        _source
    );

    _tree.restoration_registered =
        true;

    show_debug_message(
        "Mature Narra registered as a restoration source."
    );

    return true;
};


// ====================================================================
// CHECK FOR DAMAGED GROUND
// ====================================================================

is_damaged_tile = function(_tile_index)
{
    var _count =
        array_length(
            damaged_tile_indices
        );

    for (var _i = 0; _i < _count; _i++)
    {
        if (
            damaged_tile_indices[_i] ==
            _tile_index
        )
        {
            return true;
        }
    }

    return false;
};


// ====================================================================
// CHOOSE GRASS TILE FROM TILE POSITION
//
// Keeps the restored grass in a repeating 2x2 pattern.
// ====================================================================

get_grass_tile_index = function(
    _tile_x,
    _tile_y
)
{
    var _column =
        _tile_x mod 2;

    var _row =
        _tile_y mod 2;

    if (_row == 0)
    {
        return (_column == 0)
            ? grass_top_left
            : grass_top_right;
    }

    return (_column == 0)
        ? grass_bottom_left
        : grass_bottom_right;
};

// ====================================================================
// GET TILE INDEX
// ====================================================================

get_ground_tile_index = function(
    _tile_x,
    _tile_y
)
{
    var _tile_data =
        tilemap_get(
            ground_tilemap_id,
            _tile_x,
            _tile_y
        );

    return _tile_data &
        tile_index_mask;
};


// ====================================================================
// CHECK WHETHER A TILE IS GRASS
// ====================================================================

is_grass_tile = function(_tile_index)
{
    var _count =
        array_length(
            grass_tile_indices
        );

    for (var _i = 0; _i < _count; _i++)
    {
        if (
            grass_tile_indices[_i] ==
            _tile_index
        )
        {
            return true;
        }
    }

    return false;
};


// ====================================================================
// CHECK GRASS AT A TILE POSITION
// ====================================================================

is_grass_at = function(
    _tile_x,
    _tile_y
)
{
    var _pixel_x =
        _tile_x * tile_width;

    var _pixel_y =
        _tile_y * tile_height;

    if (
        _pixel_x < 0 ||
        _pixel_y < 0 ||
        _pixel_x >= room_width ||
        _pixel_y >= room_height
    )
    {
        return false;
    }

    return is_grass_tile(
        get_ground_tile_index(
            _tile_x,
            _tile_y
        )
    );
};


// ====================================================================
// CHOOSE THE CORRECT GRASS EDGE
// ====================================================================

get_grass_variant = function(
    _tile_x,
    _tile_y
)
{
    var _north =
        is_grass_at(
            _tile_x,
            _tile_y - 1
        );

    var _south =
        is_grass_at(
            _tile_x,
            _tile_y + 1
        );

    var _west =
        is_grass_at(
            _tile_x - 1,
            _tile_y
        );

    var _east =
        is_grass_at(
            _tile_x + 1,
            _tile_y
        );


    // Exterior corners
    if (!_north && !_west)
    {
        return grass_top_left;
    }

    if (!_north && !_east)
    {
        return grass_top_right;
    }

    if (!_south && !_west)
    {
        return grass_bottom_left;
    }

    if (!_south && !_east)
    {
        return grass_bottom_right;
    }


    // Straight edges
    if (!_north)
    {
        return grass_top;
    }

    if (!_south)
    {
        return grass_bottom;
    }

    if (!_west)
    {
        return grass_left;
    }

    if (!_east)
    {
        return grass_right;
    }


    // Surrounded by grass
    return grass_center;
};


// ====================================================================
// REFRESH ONE EXISTING GRASS TILE
// ====================================================================

refresh_grass_tile = function(
    _tile_x,
    _tile_y
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

    if (!is_grass_tile(_tile_index))
    {
        return false;
    }

    var _correct_index =
        get_grass_variant(
            _tile_x,
            _tile_y
        );

    var _new_tile_data =
        tile_set_index(
            _tile_data,
            _correct_index
        );

    tilemap_set(
        ground_tilemap_id,
        _new_tile_data,
        _tile_x,
        _tile_y
    );

    return true;
};


// ====================================================================
// REFRESH CHANGED TILE AND NEIGHBORS
// ====================================================================

refresh_grass_area = function(
    _center_x,
    _center_y
)
{
    for (
        var _offset_y = -1;
        _offset_y <= 1;
        _offset_y++
    )
    {
        for (
            var _offset_x = -1;
            _offset_x <= 1;
            _offset_x++
        )
        {
            refresh_grass_tile(
                _center_x + _offset_x,
                _center_y + _offset_y
            );
        }
    }
};

// ====================================================================
// RESTORE NEXT ELIGIBLE TILE
// ====================================================================

restore_next_tile = function(_source)
{
    var _offset_count =
        array_length(
            _source.offsets
        );

    while (
        _source.next_offset <
        _offset_count
    )
    {
        var _offset =
            _source.offsets[
                _source.next_offset
            ];

        _source.next_offset++;

        var _tile_x =
            _source.origin_tile_x +
            _offset.x;

        var _tile_y =
            _source.origin_tile_y +
            _offset.y;

        var _pixel_x =
            _tile_x *
            tile_width;

        var _pixel_y =
            _tile_y *
            tile_height;

        if (
            _pixel_x < 0 ||
            _pixel_y < 0 ||
            _pixel_x >= room_width ||
            _pixel_y >= room_height
        )
        {
            continue;
        }

        var _tile_data =
            tilemap_get(
                ground_tilemap_id,
                _tile_x,
                _tile_y
            );

        var _current_index =
            _tile_data &
            tile_index_mask;

        if (!is_damaged_tile(_current_index))
        {
            continue;
        }

        var _new_tile_data =
            tile_set_index(
                _tile_data,
                grass_center
            );

        tilemap_set(
            ground_tilemap_id,
            _new_tile_data,
            _tile_x,
            _tile_y
        );

        refresh_grass_area(
            _tile_x,
            _tile_y
        );

        grass_scatter_try_place(
            id,
            _tile_x,
            _tile_y
        );

        return true;
    }

    _source.completed = true;

    return false;
};