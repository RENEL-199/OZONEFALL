/// obj_crafting_table — End Step Event

target_alpha = 1;

var _player =
    instance_find(obj_player, 0);

if (instance_exists(_player))
{
    // Use the player's feet.
    var _player_x =
        _player.x;

    var _player_y =
        _player.bbox_bottom;

    var _range = 10;

    var _left =
        bbox_left - _range;

    var _right =
        bbox_right + _range;

    var _top =
        bbox_top - _range;

    var _bottom =
        bbox_bottom - _range;

    if (
        _player_x >= _left &&
        _player_x <= _right &&
        _player_y >= _top &&
        _player_y <= _bottom
    )
    {
        target_alpha =
            fade_alpha;
    }
}

image_alpha = lerp(
    image_alpha,
    target_alpha,
    fade_speed
);