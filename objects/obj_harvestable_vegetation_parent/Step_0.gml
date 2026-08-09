/// obj_harvestable_vegetation_parent — Step Event

player_nearby = false;
can_harvest = false;

var _player =
    instance_find(obj_player, 0);

if (!instance_exists(_player))
{
    exit;
}

var _distance =
    point_distance(
        x,
        y,
        _player.x,
        _player.y
    );

player_nearby =
    _distance <= harvest_range;

if (!player_nearby)
{
    exit;
}

can_harvest =
    hotbar_has_selected_item(
        required_tool_id
    );

if (
    can_harvest &&
    keyboard_check_pressed(harvest_key)
)
{
    var _nearest =
        vegetation_find_nearest(
            _player
        );

    if (_nearest == id)
    {
        vegetation_harvest(id);
    }
}