// ================================================================
// FIND PLAYER
// ================================================================
if (!instance_exists(follow)) {
    if (instance_exists(obj_player)) {
        follow = instance_find(obj_player, 0);
    }
    else {
        exit;
    }
}

// ================================================================
// DIRECT PIXEL-PERFECT FOLLOW
// ================================================================
var _camera_x =
    round(follow.x) -
    cam_width * 0.5;

var _camera_y =
    round(follow.y) -
    cam_height * 0.5;

// ================================================================
// CLAMP CAMERA TO ROOM
// ================================================================
var _maximum_x =
    max(0, room_width - cam_width);

var _maximum_y =
    max(0, room_height - cam_height);

_camera_x = clamp(
    _camera_x,
    0,
    _maximum_x
);

_camera_y = clamp(
    _camera_y,
    0,
    _maximum_y);

// Make absolutely sure the final position is whole.
_camera_x = round(_camera_x);
_camera_y = round(_camera_y);

camera_set_view_pos(
    cam,
    _camera_x,
    _camera_y
);