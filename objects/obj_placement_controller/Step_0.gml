if (!placement_active)
{
    exit;
}

if (gameplay_input_is_locked())
{
    cancel_placement(false);
    exit;
}

if (placement_input_delay > 0)
{
    placement_input_delay--;
    exit;
}

if (
    !variable_global_exists(
        "player_inventory"
    )
)
{
    cancel_placement(false);
    exit;
}

var _player =
    instance_find(
        obj_player,
        0
    );

if (!instance_exists(_player))
{
    cancel_placement(false);
    exit;
}

if (
    global.player_inventory.count_item(
        placement_item_id
    ) <= 0
)
{
    cancel_placement(false);
    exit;
}

if (
    keyboard_check_pressed(vk_escape) ||
    mouse_check_button_pressed(mb_right)
)
{
    cancel_placement(true);
    exit;
}


preview_x =
    snap_placement_x(
        device_mouse_x(0)
    );

preview_y =
    snap_placement_y(
        device_mouse_y(0)
    );


var _player_foot_x =
    _player.x;

var _player_foot_y =
    _player.bbox_bottom;

var _preview_distance =
    point_distance(
        _player_foot_x,
        _player_foot_y,
        preview_x,
        preview_y
    );

if (
    _preview_distance <
    minimum_player_preview_distance
)
{
    var _offset_x = 0;
    var _offset_y = 0;

    var _facing = "down";

    if (
        variable_instance_exists(
            _player,
            "facing"
        )
    )
    {
        _facing =
            _player.facing;
    }

    switch (_facing)
    {
        case "up":
            _offset_y =
                -placement_forward_offset;
            break;

        case "left":
            _offset_x =
                -placement_forward_offset;
            break;

        case "right":
            _offset_x =
                placement_forward_offset;
            break;

        default:
            _offset_y =
                placement_forward_offset;
            break;
    }

    preview_x =
        snap_placement_x(
            _player_foot_x +
            _offset_x
        );

    preview_y =
        snap_placement_y(
            _player_foot_y +
            _offset_y
        );
}


preview_valid =
    placement_position_is_valid(
        preview_x,
        preview_y,
        _player
    );

preview_target_plot = noone;


// ================================================================
// TREE SOIL REQUIREMENT
// ================================================================

if (
    preview_valid &&
    placement_requires_farm_plot
)
{
    preview_target_plot =
        instance_position(
            preview_center_x,
            preview_center_y,
            obj_farm_plot
        );

    if (
        !instance_exists(
            preview_target_plot
        )
    )
    {
        preview_valid = false;
    }
    else
    {
        var _plot_has_crop = false;

        if (
            variable_instance_exists(
                preview_target_plot,
                "has_valid_crop"
            )
        )
        {
            _plot_has_crop =
                preview_target_plot
                    .has_valid_crop();
        }

        if (_plot_has_crop)
        {
            preview_valid = false;
        }

        if (
            variable_instance_exists(
                preview_target_plot,
                "is_fertile"
            ) &&
            !preview_target_plot.is_fertile
        )
        {
            preview_valid = false;
        }
    }
}
else if (
    preview_valid &&
    collision_rectangle(
        preview_left + 1,
        preview_top + 1,
        preview_right - 1,
        preview_bottom - 1,
        obj_farm_plot,
        false,
        true
    ) != noone
)
{
    preview_valid = false;
}


// ================================================================
// CONFIRM
// ================================================================

if (
    !preview_valid ||
    !mouse_check_button_pressed(mb_left)
)
{
    exit;
}


if (placement_requires_farm_plot)
{
    preview_target_plot =
        instance_position(
            preview_center_x,
            preview_center_y,
            obj_farm_plot
        );

    if (!instance_exists(preview_target_plot))
    {
        preview_valid = false;
        exit;
    }

    if (
        variable_instance_exists(
            preview_target_plot,
            "has_valid_crop"
        ) &&
        preview_target_plot
            .has_valid_crop()
    )
    {
        preview_valid = false;
        exit;
    }
}


if (
    global.player_inventory.count_item(
        placement_item_id
    ) <= 0
)
{
    cancel_placement(false);
    exit;
}


var _remaining =
    global.player_inventory.remove_item(
        placement_item_id,
        1
    );

if (_remaining != 0)
{
    exit;
}


var _placed_instance =
    instance_create_depth(
        preview_x,
        preview_y,
        0,
        placement_object
    );

if (!instance_exists(_placed_instance))
{
    global.player_inventory.add_item(
        placement_item_id,
        1
    );

    cancel_placement(false);
    exit;
}


if (
    variable_instance_exists(
        _placed_instance,
        "apply_placement_data"
    )
)
{
    _placed_instance.apply_placement_data(
        placement_data
    );
}


if (
    placement_requires_farm_plot &&
    placement_consumes_farm_plot
)
{
    if (!instance_exists(preview_target_plot))
    {
        with (_placed_instance)
        {
            instance_destroy();
        }

        global.player_inventory.add_item(
            placement_item_id,
            1
        );

        preview_valid = false;
        exit;
    }

    with (preview_target_plot)
    {
        instance_destroy();
    }
}


register_placed_instance(
    _placed_instance,
    preview_center_x,
    preview_center_y
);


if (
    variable_instance_exists(
        _placed_instance,
        "placement_depth"
    )
)
{
    _placed_instance.depth =
        _placed_instance
            .placement_depth;
}
else
{
    _placed_instance.depth =
        -_placed_instance.bbox_bottom;
}

cancel_placement(false);