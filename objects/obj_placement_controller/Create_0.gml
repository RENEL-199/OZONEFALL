persistent = true;
depth = -1000000;
minimum_player_preview_distance = 12;
placement_forward_offset = 20;
placement_active = false;

placement_item_id =
    ItemID.None;

placement_object = noone;
placement_sprite = -1;
placement_data = undefined;


automatic_blocked_item_id =
    ItemID.None;

last_hotbar_slot = -1;

placement_input_delay = 0;

maximum_placement_distance = 80;


// Grid settings
default_grid_size = 16;

placement_grid_size =
    default_grid_size;

placement_cell_width =
    default_grid_size;

placement_cell_height =
    default_grid_size;


// Preview state
preview_x = 0;
preview_y = 0;
preview_valid = false;

preview_alpha = 0.65;

grid_outline_alpha = 0.18;
selected_grid_alpha = 0.90;

valid_color = c_white;

invalid_color =
    make_color_rgb(
        255,
        85,
        85
    );


// Add more blocking parents or objects here later.
placement_blocker_objects =
[
    obj_fadeble,
    obj_harvestable_tree_parent,
    obj_harvestable_vegetation_parent,
    obj_crop_parent,
    obj_campfire,
    obj_composter,
    obj_crafting_table,
    obj_water_container
];


begin_placement = function(
    _item_id,
    _object,
    _sprite,
    _placement_data = undefined
)
{
    if (placement_active)
    {
        return false;
    }

    if (
        !object_exists(_object) ||
        !variable_global_exists(
            "player_inventory"
        )
    )
    {
        return false;
    }

    if (
        global.player_inventory.count_item(
            _item_id
        ) <= 0
    )
    {
        return false;
    }

    placement_active = true;

    placement_item_id =
        _item_id;

    placement_object =
        _object;

    placement_sprite =
        _sprite;

    placement_data =
        _placement_data;


    placement_grid_size =
        default_grid_size;

    placement_cell_width =
        default_grid_size;

    placement_cell_height =
        default_grid_size;


    if (is_struct(placement_data))
    {
        if (
            variable_struct_exists(
                placement_data,
                "grid_size"
            )
        )
        {
            placement_grid_size =
                max(
                    1,
                    floor(
                        placement_data.grid_size
                    )
                );
        }

        if (
            variable_struct_exists(
                placement_data,
                "cell_width"
            )
        )
        {
            placement_cell_width =
                max(
                    1,
                    floor(
                        placement_data.cell_width
                    )
                );
        }
        else
        {
            placement_cell_width =
                placement_grid_size;
        }

        if (
            variable_struct_exists(
                placement_data,
                "cell_height"
            )
        )
        {
            placement_cell_height =
                max(
                    1,
                    floor(
                        placement_data.cell_height
                    )
                );
        }
        else
        {
            placement_cell_height =
                placement_grid_size;
        }
    }


    placement_input_delay = 2;

    preview_valid = false;

    return true;
};


cancel_placement = function(
    _manual_cancel = false
)
{
    if (
        _manual_cancel &&
        placement_active
    )
    {
        automatic_blocked_item_id =
            placement_item_id;
    }

    placement_active = false;

    placement_item_id =
        ItemID.None;

    placement_object = noone;
    placement_sprite = -1;
    placement_data = undefined;

    placement_grid_size =
        default_grid_size;

    placement_cell_width =
        default_grid_size;

    placement_cell_height =
        default_grid_size;

    placement_input_delay = 0;

    preview_valid = false;
};


snap_placement_x = function(_world_x)
{
    return
        floor(
            _world_x /
            placement_grid_size
        ) *
        placement_grid_size +
        placement_grid_size *
        0.5;
};


snap_placement_y = function(_world_y)
{
    return
        floor(
            _world_y /
            placement_grid_size
        ) *
        placement_grid_size +
        placement_grid_size *
        0.5;
};


placement_position_is_valid = function(
    _place_x,
    _place_y,
    _player
)
{
    if (!instance_exists(_player))
    {
        return false;
    }


    var _half_width =
        placement_cell_width *
        0.5;

    var _half_height =
        placement_cell_height *
        0.5;

    var _left =
        _place_x -
        _half_width +
        1;

    var _right =
        _place_x +
        _half_width -
        1;

    var _top =
        _place_y -
        _half_height +
        1;

    var _bottom =
        _place_y +
        _half_height -
        1;


    if (
        _left < 0 ||
        _top < 0 ||
        _right >= room_width ||
        _bottom >= room_height
    )
    {
        return false;
    }


    var _distance =
        point_distance(
            _player.x,
            _player.bbox_bottom,
            _place_x,
            _place_y
        );

    if (
        _distance >
        maximum_placement_distance
    )
    {
        return false;
    }


    // Never place directly underneath the player.
    if (
        rectangle_in_rectangle(
            _left,
            _top,
            _right,
            _bottom,

            _player.bbox_left,
            _player.bbox_top,
            _player.bbox_right,
            _player.bbox_bottom
        )
    )
    {
        return false;
    }


    // Prevent another instance of the same object from sharing the cell.
    if (
        object_exists(
            placement_object
        ) &&
        collision_rectangle(
            _left,
            _top,
            _right,
            _bottom,
            placement_object,
            false,
            true
        ) != noone
    )
    {
        return false;
    }


    var _blocker_count =
        array_length(
            placement_blocker_objects
        );

    for (
        var _i = 0;
        _i < _blocker_count;
        _i++
    )
    {
        var _blocker_object =
            placement_blocker_objects[_i];

        if (
            collision_rectangle(
                _left,
                _top,
                _right,
                _bottom,
                _blocker_object,
                false,
                true
            ) != noone
        )
        {
            return false;
        }
    }


    return true;
};