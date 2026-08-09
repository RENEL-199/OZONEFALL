/// VegetationSpawnSystem.gml


// ====================================================================
// TREE-SPECIFIC VEGETATION ENTRY
//
// Several entries can use the same tree object, allowing one tree
// species to support multiple plant types later.
// ====================================================================
function TreeVegetationEntry(
    _tree_object,
    _vegetation_object,
    _crowded_weight,
    _open_weight
)
constructor
{
    tree_object =
        _tree_object;

    vegetation_object =
        _vegetation_object;
		

    crowded_weight =
        max(0, _crowded_weight);

    open_weight =
        max(0, _open_weight);
}


// ====================================================================
// VEGETATION DATABASE
// ====================================================================
function vegetation_database_create()
{
    global.tree_vegetation_database =
    [
        // Narra vegetation.
        // Banaba becomes more likely when the surrounding area is open.
        new TreeVegetationEntry(
            obj_narra_3,
            obj_wild_berry,
			
            5,
            55
        ),
 
	

        // Narra vegetation.
        // Banaba becomes more likely when the surrounding area is open.
        new TreeVegetationEntry(
            obj_t2_3,
            obj_narra_grass,
			
            5,
            55
        )
    ];
}


// ====================================================================
// CHECK WHETHER A TILE IS RESTORED GRASS
// ====================================================================
function vegetation_is_grass_tile(
    _tilemap_id,
    _world_x,
    _world_y
)
{
    if (_tilemap_id == -1)
    {
        return false;
    }

    var _tile_data =
        tilemap_get_at_pixel(
            _tilemap_id,
            _world_x,
            _world_y
        );

    var _tile_index =
        _tile_data & tile_index_mask;

    return
        _tile_index == 175 ||
        _tile_index == 176 ||
        _tile_index == 177 ||
        _tile_index == 215 ||
        _tile_index == 216 ||
        _tile_index == 217 ||
        _tile_index == 255 ||
        _tile_index == 256 ||
        _tile_index == 257;
}


// ====================================================================
// CHECK WHETHER A LOCATION HAS ENOUGH SPACE
// ====================================================================
function vegetation_position_is_free(
    _x,
    _y,
    _spacing
)
{
    var _vegetation =
        collision_circle(
            _x,
            _y,
            _spacing,
            obj_harvestable_vegetation_parent,
            false,
            true
        );

    if (instance_exists(_vegetation))
    {
        return false;
    }

    // Prevent vegetation from appearing inside a tree.
    var _tree =
        collision_circle(
            _x,
            _y,
            10,
            obj_harvestable_tree_parent,
            false,
            true
        );

    if (instance_exists(_tree))
    {
        return false;
    }

    return true;
}


// ====================================================================
// MEASURE THE OPEN SPACE AROUND A TILE
//
// Returns:
// 0 = crowded, isolated, or unrestored
// 1 = surrounded by open grass
// ====================================================================
function vegetation_measure_openness(
    _tilemap_id,
    _world_x,
    _world_y,
    _tile_width,
    _tile_height,
    _spacing
)
{
    var _open_neighbors = 0;

    for (var _offset_y = -1; _offset_y <= 1; _offset_y++)
    {
        for (var _offset_x = -1; _offset_x <= 1; _offset_x++)
        {
            if (
                _offset_x == 0 &&
                _offset_y == 0
            )
            {
                continue;
            }

            var _check_x =
                _world_x +
                _offset_x * _tile_width;

            var _check_y =
                _world_y +
                _offset_y * _tile_height;

            if (
                vegetation_is_grass_tile(
                    _tilemap_id,
                    _check_x,
                    _check_y
                ) &&
                vegetation_position_is_free(
                    _check_x,
                    _check_y,
                    _spacing
                )
            )
            {
                _open_neighbors++;
            }
        }
    }

    return _open_neighbors / 8;
}


// ====================================================================
// CHOOSE COMMON OR TREE-SPECIFIC VEGETATION
// ====================================================================
function vegetation_choose_object(
    _tree_object,
    _openness,
    _common_object,
    _common_weight
)
{
    var _database =
        global.tree_vegetation_database;

    var _total_weight =
        max(0, _common_weight);

    // First calculate the combined weight.
    for (
        var _i = 0;
        _i < array_length(_database);
        _i++
    )
    {
        var _entry =
            _database[_i];

        if (_entry.tree_object == _tree_object)
        {
            _total_weight += lerp(
                _entry.crowded_weight,
                _entry.open_weight,
                _openness
            );
        }
    }

    if (_total_weight <= 0)
    {
        return noone;
    }

    var _roll =
        random(_total_weight);

    // Common grass always participates regardless of tree species.
    if (_roll < _common_weight)
    {
        return _common_object;
    }

    _roll -= _common_weight;

    // Select one of the tree-specific plants.
    for (
        var _i = 0;
        _i < array_length(_database);
        _i++
    )
    {
        var _entry =
            _database[_i];

        if (_entry.tree_object != _tree_object)
        {
            continue;
        }

        var _weight =
            lerp(
                _entry.crowded_weight,
                _entry.open_weight,
                _openness
            );

        if (_roll < _weight)
        {
            return _entry.vegetation_object;
        }

        _roll -= _weight;
    }

    return _common_object;
}


// ====================================================================
// COUNT CURRENT VEGETATION AROUND A TREE
// ====================================================================
function vegetation_count_near(
    _x,
    _y,
    _radius
)
{
    var _total = 0;

    var _instance_count =
        instance_number(
            obj_harvestable_vegetation_parent
        );

    for (
        var _i = 0;
        _i < _instance_count;
        _i++
    )
    {
        var _plant =
            instance_find(
                obj_harvestable_vegetation_parent,
                _i
            );

        if (
            instance_exists(_plant) &&
            point_distance(
                _x,
                _y,
                _plant.x,
                _plant.y
            ) <= _radius
        )
        {
            _total++;
        }
    }

    return _total;
}


// ====================================================================
// TRY TO SPAWN ONE PLANT AROUND A RESTORATION TREE
// ====================================================================
function vegetation_try_spawn_for_tree(
    _tree,
    _tilemap_id,
    _controller
)
{
    if (!instance_exists(_tree))
    {
        return false;
    }

    var _tile_width =
        tilemap_get_tile_width(
            _tilemap_id
        );

    var _tile_height =
        tilemap_get_tile_height(
            _tilemap_id
        );

    if (
        _tile_width <= 0 ||
        _tile_height <= 0
    )
    {
        return false;
    }

    var _world_radius =
        _controller.restoration_radius_tiles *
        max(_tile_width, _tile_height);

    var _current_count =
        vegetation_count_near(
            _tree.x,
            _tree.y,
            _world_radius
        );

    if (
        _current_count >=
        _controller.maximum_plants_per_source
    )
    {
        return false;
    }

    var _tree_tile_x =
        floor(_tree.x / _tile_width);

    var _tree_tile_y =
        floor(_tree.y / _tile_height);

    for (
        var _attempt = 0;
        _attempt <
        _controller.spawn_attempts_per_source;
        _attempt++
    )
    {
        if (
            random(1) >
            _controller.spawn_chance_per_attempt
        )
        {
            continue;
        }

        var _offset_x =
            irandom_range(
                -_controller.restoration_radius_tiles,
                _controller.restoration_radius_tiles
            );

        var _offset_y =
            irandom_range(
                -_controller.restoration_radius_tiles,
                _controller.restoration_radius_tiles
            );

        // Keep candidates inside the approximate restoration range.
        if (
            _offset_x * _offset_x +
            _offset_y * _offset_y >
            _controller.restoration_radius_tiles *
            _controller.restoration_radius_tiles
        )
        {
            continue;
        }

        var _tile_x =
            _tree_tile_x + _offset_x;

        var _tile_y =
            _tree_tile_y + _offset_y;

        var _candidate_x =
            _tile_x * _tile_width +
            _tile_width * 0.5;

        var _candidate_y =
            _tile_y * _tile_height +
            _tile_height * 0.5;

        // Only restored grass is eligible.
        if (
            !vegetation_is_grass_tile(
                _tilemap_id,
                _candidate_x,
                _candidate_y
            )
        )
        {
            continue;
        }

        if (
            !vegetation_position_is_free(
                _candidate_x,
                _candidate_y,
                _controller.minimum_plant_spacing
            )
        )
        {
            continue;
        }

        var _openness =
            vegetation_measure_openness(
                _tilemap_id,
                _candidate_x,
                _candidate_y,
                _tile_width,
                _tile_height,
                _controller.minimum_plant_spacing
            );

        var _vegetation_object =
            vegetation_choose_object(
                _tree.object_index,
                _openness,
                _controller.common_vegetation_object,
                _controller.common_vegetation_weight
            );

        if (_vegetation_object == noone)
        {
            continue;
        }

        // Small offset prevents plants from forming a visible grid.
        var _spawn_x =
            _candidate_x +
            irandom_range(-3, 3);

        var _spawn_y =
            _candidate_y +
            irandom_range(-3, 3);

        var _plant =
            instance_create_depth(
                _spawn_x,
                _spawn_y,
                -_spawn_y,
                _vegetation_object
            );

        if (!instance_exists(_plant))
        {
            return false;
        }

        // Useful later for saving and ecosystem ownership.
        _plant.restoration_tree_id =
            _tree.id;

        _plant.depth =
            -_plant.bbox_bottom;

        return true;
    }

    return false;
}


// ====================================================================
// PROCESS ALL ACTIVE RESTORATION SOURCES
// ====================================================================
function vegetation_process_cycle(
    _restoration,
    _controller,
    _spawn_budget
)
{
    if (
        !instance_exists(_restoration) ||
        _spawn_budget <= 0
    )
    {
        return 0;
    }

    if (
        !variable_instance_exists(
            _restoration,
            "restoration_sources"
        )
    )
    {
        return 0;
    }

    var _sources =
        _restoration.restoration_sources;

    var _source_count =
        array_length(_sources);

    if (_source_count <= 0)
    {
        return 0;
    }

    var _spawned = 0;

    // Random starting position prevents the same tree from always
    // receiving the first spawning opportunity.
    var _start_index =
        irandom(_source_count - 1);

    for (
        var _n = 0;
        _n < _source_count;
        _n++
    )
    {
        if (_spawned >= _spawn_budget)
        {
            break;
        }

        var _source_index =
            (_start_index + _n)
            mod _source_count;

        var _source =
            _sources[_source_index];

        if (!instance_exists(_source.tree_id))
        {
            continue;
        }

        if (
            vegetation_try_spawn_for_tree(
                _source.tree_id,
                _restoration.ground_tilemap_id,
                _controller
            )
        )
        {
            _spawned++;
        }
    }

    return _spawned;
}