/// obj_input_controller — Create Event

if (instance_number(object_index) > 1)
{
    instance_destroy();
    exit;
}

persistent = true;
depth = -1000001;

global.player_input =
    new PlayerInputSystem();