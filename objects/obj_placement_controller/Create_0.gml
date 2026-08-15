if (instance_number(object_index) > 1)
{
    instance_destroy();
    exit;
}

persistent = true;
depth = -1000000;

minimum_player_preview_distance = 12;
placement_forward_offset = 20;
maximum_placement_distance = 80;

placement_active = false;
placement_item_id = ItemID.None;
placement_object = noone;
placement_sprite = -1;
placement_data = undefined;

automatic_blocked_item_id = ItemID.None;
last_hotbar_slot = -1;
placement_input_delay = 0;

default_grid_size = 16;

placement_grid_size = default_grid_size;

placement_footprint_columns = 1;
placement_footprint_rows = 1;

placement_cell_width = default_grid_size;
placement_cell_height = default_grid_size;

placement_footprint_offset_x = 0;
placement_footprint_offset_y = 0;

placement_requires_farm_plot = false;
placement_consumes_farm_plot = false;

preview_x = 0;
preview_y = 0;

preview_center_x = 0;
preview_center_y = 0;

preview_left = 0;
preview_right = 0;
preview_top = 0;
preview_bottom = 0;

preview_valid = false;
preview_target_plot = noone;

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

placement_blocker_objects = [];
registered_placements = [];


add_placement_blocker = function(_object)
{
    if (!object_exists(_object))
    {
        return false;
    }

    var _count =
        array_length(
            placement_blocker_objects
        );

    for (var _i = 0; _i < _count; _i++)
    {
        if (
            placement_blocker_objects[_i] ==
            _object
        )
        {
            return false;
        }
    }

    placement_blocker_objects[_count] =
        _object;

    return true;
};


refresh_placement_blockers = function()
{
    placement_blocker_objects = [];

    add_placement_blocker(
        obj_fadeble
    );

    add_placement_blocker(
        obj_harvestable_tree_parent
    );

    add_placement_blocker(
        obj_harvestable_vegetation_parent
    );

    add_placement_blocker(
        obj_crafting_table
    );

    add_placement_blocker(
        obj_water_container
    );

    if (
        !variable_global_exists(
            "item_database"
        )
    )
    {
        return;
    }

    var _item_count =
        array_length(
            global.item_database
        );

    for (
        var _i = 0;
        _i < _item_count;
        _i++
    )
    {
        var _item_data =
            global.item_database[_i];

        if (
            is_undefined(_item_data) ||
            !is_struct(_item_data.placement)
        )
        {
            continue;
        }

        var _placeable_object =
            _item_data.placement.object;

        if (
            !object_exists(
                _placeable_object
            ) ||
            _placeable_object ==
            obj_farm_plot
        )
        {
            continue;
        }

        add_placement_blocker(
            _placeable_object
        );
    }
};


update_preview_bounds = function(
    _place_x,
    _place_y
)
{
    preview_center_x =
        _place_x +
        placement_footprint_offset_x;

    preview_center_y =
        _place_y +
        placement_footprint_offset_y;

    preview_left =
        preview_center_x -
        placement_cell_width * 0.5;

    preview_right =
        preview_center_x +
        placement_cell_width * 0.5;

    preview_top =
        preview_center_y -
        placement_cell_height * 0.5;

    preview_bottom =
        preview_center_y +
        placement_cell_height * 0.5;
};


register_placed_instance = function(
    _instance,
    _center_x,
    _center_y
)
{
    if (!instance_exists(_instance))
    {
        return false;
    }

    var _width =
        placement_cell_width;

    var _height =
        placement_cell_height;

    _instance.placement_occupies_grid =
        true;

    _instance.placement_grid_size =
        placement_grid_size;

    _instance.placement_footprint_columns =
        placement_footprint_columns;

    _instance.placement_footprint_rows =
        placement_footprint_rows;

    _instance.placement_footprint_left =
        _center_x -
        _width * 0.5;

    _instance.placement_footprint_right =
        _center_x +
        _width * 0.5;

    _instance.placement_footprint_top =
        _center_y -
        _height * 0.5;

    _instance.placement_footprint_bottom =
        _center_y +
        _height * 0.5;

    var _count =
        array_length(
            registered_placements
        );

    for (var _i = 0; _i < _count; _i++)
    {
        if (
            registered_placements[_i] ==
            _instance
        )
        {
            return true;
        }
    }

    registered_placements[_count] =
        _instance;

    return true;
};


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

    placement_footprint_columns = 1;
    placement_footprint_rows = 1;

    placement_footprint_offset_x = 0;
    placement_footprint_offset_y = 0;

    placement_requires_farm_plot = false;
    placement_consumes_farm_plot = false;

    if (
        is_struct(placement_data) &&
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

    if (sprite_exists(placement_sprite))
    {
        placement_footprint_columns =
            max(
                1,
                ceil(
                    sprite_get_width(
                        placement_sprite
                    ) /
                    placement_grid_size
                )
            );

        placement_footprint_rows =
            max(
                1,
                ceil(
                    sprite_get_height(
                        placement_sprite
                    ) /
                    placement_grid_size
                )
            );
    }

    if (is_struct(placement_data))
    {
        if (
            variable_struct_exists(
                placement_data,
                "footprint_columns"
            )
        )
        {
            placement_footprint_columns =
                max(
                    1,
                    floor(
                        placement_data
                            .footprint_columns
                    )
                );
        }
        else if (
            variable_struct_exists(
                placement_data,
                "cell_width"
            )
        )
        {
            placement_footprint_columns =
                max(
                    1,
                    ceil(
                        placement_data.cell_width /
                        placement_grid_size
                    )
                );
        }

        if (
            variable_struct_exists(
                placement_data,
                "footprint_rows"
            )
        )
        {
            placement_footprint_rows =
                max(
                    1,
                    floor(
                        placement_data
                            .footprint_rows
                    )
                );
        }
        else if (
            variable_struct_exists(
                placement_data,
                "cell_height"
            )
        )
        {
            placement_footprint_rows =
                max(
                    1,
                    ceil(
                        placement_data.cell_height /
                        placement_grid_size
                    )
                );
        }

        if (
            variable_struct_exists(
                placement_data,
                "footprint_offset_x"
            )
        )
        {
            placement_footprint_offset_x =
                placement_data
                    .footprint_offset_x;
        }

        if (
            variable_struct_exists(
                placement_data,
                "footprint_offset_y"
            )
        )
        {
            placement_footprint_offset_y =
                placement_data
                    .footprint_offset_y;
        }

        if (
            variable_struct_exists(
                placement_data,
                "requires_farm_plot"
            )
        )
        {
            placement_requires_farm_plot =
                placement_data
                    .requires_farm_plot;
        }

        if (
            variable_struct_exists(
                placement_data,
                "consumes_farm_plot"
            )
        )
        {
            placement_consumes_farm_plot =
                placement_data
                    .consumes_farm_plot;
        }
    }

    placement_cell_width =
        placement_footprint_columns *
        placement_grid_size;

    placement_cell_height =
        placement_footprint_rows *
        placement_grid_size;

    refresh_placement_blockers();

    placement_input_delay = 2;

    preview_valid = false;
    preview_target_plot = noone;

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

    placement_footprint_columns = 1;
    placement_footprint_rows = 1;

    placement_cell_width =
        default_grid_size;

    placement_cell_height =
        default_grid_size;

    placement_footprint_offset_x = 0;
    placement_footprint_offset_y = 0;

    placement_requires_farm_plot = false;
    placement_consumes_farm_plot = false;

    placement_input_delay = 0;

    preview_valid = false;
    preview_target_plot = noone;
};


snap_placement_x = function(_world_x)
{
    var _center_x;

    if (
        placement_footprint_columns
        mod 2 == 0
    )
    {
        _center_x =
            round(
                _world_x /
                placement_grid_size
            ) *
            placement_grid_size;
    }
    else
    {
        _center_x =
            floor(
                _world_x /
                placement_grid_size
            ) *
            placement_grid_size +
            placement_grid_size * 0.5;
    }

    return
        _center_x -
        placement_footprint_offset_x;
};


snap_placement_y = function(_world_y)
{
    var _center_y;

    if (
        placement_footprint_rows
        mod 2 == 0
    )
    {
        _center_y =
            round(
                _world_y /
                placement_grid_size
            ) *
            placement_grid_size;
    }
    else
    {
        _center_y =
            floor(
                _world_y /
                placement_grid_size
            ) *
            placement_grid_size +
            placement_grid_size * 0.5;
    }

    return
        _center_y -
        placement_footprint_offset_y;
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

    update_preview_bounds(
        _place_x,
        _place_y
    );

    var _collision_left =
        preview_left + 1;

    var _collision_right =
        preview_right - 1;

    var _collision_top =
        preview_top + 1;

    var _collision_bottom =
        preview_bottom - 1;

    if (
        preview_left < 0 ||
        preview_top < 0 ||
        preview_right > room_width ||
        preview_bottom > room_height
    )
    {
        return false;
    }

    var _distance =
        point_distance(
            _player.x,
            _player.bbox_bottom,
            preview_center_x,
            preview_center_y
        );

    if (
        _distance >
        maximum_placement_distance
    )
    {
        return false;
    }

    var _overlaps_player =
        !(
            preview_right <=
            _player.bbox_left ||

            preview_left >=
            _player.bbox_right ||

            preview_bottom <=
            _player.bbox_top ||

            preview_top >=
            _player.bbox_bottom
        );

    if (_overlaps_player)
    {
        return false;
    }

    for (
        var _i =
            array_length(
                registered_placements
            ) - 1;

        _i >= 0;

        _i--
    )
    {
        var _existing =
            registered_placements[_i];

        if (!instance_exists(_existing))
        {
            array_delete(
                registered_placements,
                _i,
                1
            );

            continue;
        }

        if (
            placement_requires_farm_plot &&
            _existing.object_index ==
            obj_farm_plot
        )
        {
            continue;
        }

        var _overlaps_existing =
            !(
                preview_right <=
                _existing
                    .placement_footprint_left ||

                preview_left >=
                _existing
                    .placement_footprint_right ||

                preview_bottom <=
                _existing
                    .placement_footprint_top ||

                preview_top >=
                _existing
                    .placement_footprint_bottom
            );

        if (_overlaps_existing)
        {
            return false;
        }
    }

    if (
        object_exists(
            placement_object
        ) &&
        collision_rectangle(
            _collision_left,
            _collision_top,
            _collision_right,
            _collision_bottom,
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

        var _blocker =
            collision_rectangle(
                _collision_left,
                _collision_top,
                _collision_right,
                _collision_bottom,
                _blocker_object,
                false,
                true
            );

        if (_blocker == noone)
        {
            continue;
        }

        if (
            placement_requires_farm_plot &&
            _blocker.object_index ==
            obj_farm_plot
        )
        {
            continue;
        }

        return false;
    }

    return true;
};