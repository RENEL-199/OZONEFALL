if (instance_number(object_index) > 1)
{
    instance_destroy();
    exit;
}

persistent = true;

update_interval_steps = 15;
update_timer = 0;

interaction_forward_distance = 22;
interaction_maximum_distance = 40;
interaction_side_width = 18;

global.farm_target =
    noone;