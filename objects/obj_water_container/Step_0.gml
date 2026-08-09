event_inherited()

can_interact = false;

if (message_timer > 0)
{
    message_timer--;
}


var _player =
    instance_find(
        obj_player,
        0
    );

if (!instance_exists(_player))
{
    exit;
}


can_interact =
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
    fill_selected_bottle();
}