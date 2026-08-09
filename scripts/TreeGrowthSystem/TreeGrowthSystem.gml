/// TreeGrowthSystem.gml

// ====================================================================
// INITIALIZE TREE GROWTH
// ====================================================================

function tree_growth_initialize(
    _tree,
    _next_stage_object,
    _duration_minutes,
    _start_timestamp = undefined
)
{
    if (!instance_exists(_tree))
    {
        return false;
    }

    _tree.growth_next_object =
        _next_stage_object;

    _tree.growth_duration_minutes =
        max(
            0,
            floor(_duration_minutes)
        );

    _tree.growth_start_timestamp = 0;
    _tree.growth_finish_timestamp = 0;

    if (
        _tree.growth_duration_minutes <= 0 ||
        _next_stage_object == noone
    )
    {
        return true;
    }

    if (!variable_global_exists("game_time"))
    {
        show_debug_message(
            "Tree growth error: global.game_time does not exist."
        );

        return false;
    }


    // Use the supplied timestamp when catching up after a
    // previous growth transition.
    if (is_undefined(_start_timestamp))
    {
        _tree.growth_start_timestamp =
            global.game_time.get_timestamp();
    }
    else
    {
        _tree.growth_start_timestamp =
            _start_timestamp;
    }

    _tree.growth_finish_timestamp =
        _tree.growth_start_timestamp +
        _tree.growth_duration_minutes;

    return true;
}


// ====================================================================
// UPDATE TREE GROWTH
// ====================================================================

function tree_growth_update(_tree)
{
    if (!instance_exists(_tree))
    {
        return false;
    }

    if (
        _tree.growth_next_object == noone ||
        _tree.growth_duration_minutes <= 0 ||
        _tree.growth_finish_timestamp <= 0
    )
    {
        return false;
    }

    if (!variable_global_exists("game_time"))
    {
        return false;
    }

    if (
        !global.game_time.timestamp_reached(
            _tree.growth_finish_timestamp
        )
    )
    {
        return false;
    }


    // The exact time when this stage was scheduled to finish.
    var _transition_timestamp =
        _tree.growth_finish_timestamp;

    var _next_object =
        _tree.growth_next_object;


    // Preserve visual and positional values.
    var _tree_x = _tree.x;
    var _tree_y = _tree.y;

    var _tree_depth =
        _tree.depth;

    var _tree_xscale =
        _tree.image_xscale;

    var _tree_yscale =
        _tree.image_yscale;

    var _tree_angle =
        _tree.image_angle;

    var _tree_alpha =
        _tree.image_alpha;


    // Create the next growth stage.
    var _next_tree =
        instance_create_depth(
            _tree_x,
            _tree_y,
            _tree_depth,
            _next_object
        );

    if (!instance_exists(_next_tree))
    {
        show_debug_message(
            "Tree growth error: failed to create " +
            object_get_name(_next_object)
        );

        return false;
    }


    // Restore visual properties.
    _next_tree.image_xscale =
        _tree_xscale;

    _next_tree.image_yscale =
        _tree_yscale;

    _next_tree.image_angle =
        _tree_angle;

    _next_tree.image_alpha =
        _tree_alpha;

    _next_tree.depth =
        -_next_tree.bbox_bottom;


    // The next object's Create Event initializes its own duration.
    // Override its starting time with the previous scheduled finish
    // so skipped time can be caught up correctly.
    _next_tree.growth_start_timestamp =
        _transition_timestamp;

    if (
        _next_tree.growth_duration_minutes > 0 &&
        _next_tree.growth_next_object != noone
    )
    {
        _next_tree.growth_finish_timestamp =
            _transition_timestamp +
            _next_tree.growth_duration_minutes;
    }
    else
    {
        _next_tree.growth_finish_timestamp = 0;
    }


    show_debug_message(
        object_get_name(_tree.object_index) +
        " grew into " +
        object_get_name(_next_object)
    );


    // Only destroy the previous stage after the next stage
    // has been created successfully.
    with (_tree)
    {
        instance_destroy();
    }

    return true;
}