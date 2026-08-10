if (instance_number(object_index) > 1)
{
    instance_destroy();
    exit;
}

interaction_range = 42;

target_soil = noone;

last_time_timestamp = -1;

depth = -100000;