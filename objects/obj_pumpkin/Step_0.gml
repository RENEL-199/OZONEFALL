event_inherited();

crop_growth_update(id);

if (!is_mature)
{
    exit;
}

if (gameplay_input_is_locked())
{
    exit;
}

if (!player_input_interact_pressed())
{
    exit;
}

var _harvest_target =
    crop_get_harvest_target();

if (_harvest_target == id)
{
    crop_harvest(id);
}