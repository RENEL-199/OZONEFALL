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


// ====================================================================
// GRID POSITION
// ====================================================================

preview_x =
    snap_placement_x(
        device_mouse_x(0)
    );

preview_y =
    snap_placement_y(
        device_mouse_y(0)
    );


// Move placement one tile in front when the cursor is
// directly underneath the player.
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
	

if (
    preview_valid &&
    placement_object ==
    obj_farm_plot
)
{
    if (
        collision_rectangle(
            preview_x - 7,
            preview_y - 7,
            preview_x + 7,
            preview_y + 7,
            obj_farm_plot,
            false,
            true
        ) != noone
    )
    {
        preview_valid = false;
    }
}
// ====================================================================
// TREE SEED AND SOIL VALIDATION
// ====================================================================

var _placing_tree_seed =
    tree_species_is_seed(
        placement_item_id
    );

var _placing_crop_seed =
farm_item_is_seed(
    placement_item_id
);

var _requires_soil =
    _placing_tree_seed ||
    _placing_crop_seed;

var _target_soil = noone;

if (_requires_soil)

{
    _target_soil =
        instance_position(
            preview_x,
            preview_y,
            obj_farm_plot
        );

    if (!instance_exists(_target_soil))
    {
        preview_valid = false;
    }
    else if (
        !variable_instance_exists(
            _target_soil,
            "can_accept_seed"
        )
    )
    {
        preview_valid = false;
    }
    else if (
        !_target_soil.can_accept_seed()
    )
    {
        preview_valid = false;
    }
}
else
{
    // Other objects cannot be placed over fertile soil.
    if (
        instance_position(
            preview_x,
            preview_y,
            obj_farm_plot
        ) != noone
    )
    {
        preview_valid = false;
    }
}


// ====================================================================
// WAIT FOR VALID CONFIRMATION
// ====================================================================

if (
    !preview_valid ||
    !mouse_check_button_pressed(mb_left)
)
{
    exit;
}


// ====================================================================
// RECHECK TREE SOIL
// ====================================================================

if (_requires_soil)
{
    _target_soil =
        instance_position(
            preview_x,
            preview_y,
            obj_farm_plot
        );

    if (
        !instance_exists(_target_soil) ||
        !variable_instance_exists(
            _target_soil,
            "can_accept_seed"
        ) ||
        !_target_soil.can_accept_seed()
    )
    {
        preview_valid = false;
        exit;
    }
}


// ====================================================================
// REMOVE PLACEMENT ITEM
// ====================================================================

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


// ====================================================================
// CREATE PLACED INSTANCE
// ====================================================================

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


// ====================================================================
// APPLY PLACEMENT DATA
// ====================================================================

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


// ====================================================================
// RESERVE SOIL FOR PLANTED TREE
// ====================================================================

var _placement_succeeded = true;

if (_requires_soil)
{
    if (
        !instance_exists(_target_soil) ||
        !variable_instance_exists(
            _target_soil,
            "assign_crop"
        )
    )
    {
        _placement_succeeded = false;
    }
    else
    {
        _placement_succeeded =
            _target_soil.assign_crop(
                _placed_instance
            );
    }

    if (_placement_succeeded)
    {
        _placed_instance.planted_soil_id =
            _target_soil;
    }
}


// ====================================================================
// REFUND FAILED PLACEMENT
// ====================================================================

if (!_placement_succeeded)
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


// ====================================================================
// PLACEMENT DEPTH
// ====================================================================

if (
    variable_instance_exists(
        _placed_instance,
        "placement_depth"
    )
)
{
    _placed_instance.depth =
        _placed_instance.placement_depth;
}
else
{
    _placed_instance.depth =
        -_placed_instance.bbox_bottom;
}

cancel_placement(false);