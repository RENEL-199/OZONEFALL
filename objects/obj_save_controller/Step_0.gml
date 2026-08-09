/// obj_save_controller — Step Event

if (status_message_timer > 0)
{
    status_message_timer--;
}

if (enable_debug_hotkeys)
{
    if (keyboard_check_pressed(save_key))
    {
        request_save();
    }

    if (keyboard_check_pressed(load_key))
    {
        request_load();
    }
}

if (!pending_load)
{
    exit;
}

var _room_ready =
    room_get_name(room) ==
    pending_room_name;

var _systems_ready =
    variable_global_exists(
        "player_inventory"
    ) &&
    variable_global_exists(
        "survival"
    ) &&
    variable_global_exists(
        "game_time"
    );

var _player_ready =
    instance_exists(
        obj_player
    );

if (
    !_room_ready ||
    !_systems_ready ||
    !_player_ready
)
{
    exit;
}

var _load_succeeded =
    core_save_apply_data(
        pending_save_data
    );

pending_load = false;
pending_save_data = undefined;
pending_room_name = "";

if (_load_succeeded)
{
    set_status_message(
        "Game loaded from Slot " +
        string(active_slot) +
        "."
    );

    refresh_all_save_slots();
}
else
{
    set_status_message(
        "Load failed."
    );
}