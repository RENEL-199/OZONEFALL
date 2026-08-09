can_open = false;

var _player =
    instance_find(obj_player, 0);

if (!instance_exists(_player))
{
    exit;
}

var _distance = point_distance(
    x,
    y,
    _player.x,
    _player.y
);

can_open =
    _distance <= interaction_range;

if (
    can_open &&
    player_input_interact_pressed()
)
{
    var _ui =
        instance_find(obj_inventoryUI, 0);

    if (instance_exists(_ui))
    {
        // Close this chest if already open.
        if (
            _ui.open &&
            _ui.container_instance == id
        )
        {
            _ui.open = false;
            _ui.container_inventory = undefined;
            _ui.container_instance = noone;

            is_open = false;
        }
        else
        {
            // Close another chest if one is open.
            if (
                instance_exists(
                    _ui.container_instance
                )
            )
            {
                _ui.container_instance.is_open =
                    false;
            }

            _ui.open = true;
            _ui.container_inventory =
                chest_inventory;

            _ui.container_instance = id;

            is_open = true;
        }
    }
}