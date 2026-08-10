event_inherited();

can_interact = false;

var _player =
    instance_find(
        obj_player,
        0
    );

if (!instance_exists(_player))
{
    exit;
}

var _nearest_container =
    instance_nearest(
        _player.x,
        _player.y,
        obj_water_container
    );

can_interact =
    _nearest_container == id &&
    point_distance(
        x,
        y,
        _player.x,
        _player.y
    ) <= interaction_range;

if (
    can_interact &&
    !gameplay_input_is_locked() &&
    player_input_interact_pressed()
)
{
    interact_with_water();
}