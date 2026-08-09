/// obj_save_controller — Create Event

if (instance_number(object_index) > 1)
{
    instance_destroy();
    exit;
}

persistent = true;
depth = -1000000;

save_slot_count = 3;
active_slot = 1;

save_file_name = "";

slot_has_save =
    array_create(
        save_slot_count,
        false
    );

slot_summaries =
    array_create(
        save_slot_count,
        "Empty Slot"
    );

slot_timestamps =
    array_create(
        save_slot_count,
        0
    );

has_save_file = false;
save_summary = "No saved game";

pending_load = false;
pending_save_data = undefined;
pending_room_name = "";

enable_debug_hotkeys = false;
save_key = vk_f5;
load_key = vk_f9;

status_message = "";
status_message_timer = 0;


get_slot_filename = function(_slot)
{
    _slot = clamp(
        floor(_slot),
        1,
        save_slot_count
    );

    return
        "save_slot_" +
        string(_slot) +
        ".json";
};


set_status_message = function(
    _message,
    _duration = 180
)
{
    status_message = _message;

    status_message_timer =
        max(1, _duration);
};


set_active_slot = function(_slot)
{
    if (
        _slot < 1 ||
        _slot > save_slot_count
    )
    {
        return false;
    }

    active_slot = floor(_slot);

    save_file_name =
        get_slot_filename(
            active_slot
        );

    has_save_file =
        slot_has_save[
            active_slot - 1
        ];

    save_summary =
        slot_summaries[
            active_slot - 1
        ];

    return true;
};


refresh_save_slot = function(_slot)
{
    if (
        _slot < 1 ||
        _slot > save_slot_count
    )
    {
        return false;
    }

    var _index =
        _slot - 1;

    var _filename =
        get_slot_filename(
            _slot
        );

    slot_has_save[_index] =
        file_exists(
            _filename
        );

    slot_summaries[_index] =
        "Empty Slot";

    slot_timestamps[_index] = 0;

    if (!slot_has_save[_index])
    {
        return false;
    }

    var _save_data =
        core_save_read_file(
            _filename
        );

    if (is_undefined(_save_data))
    {
        slot_has_save[_index] = false;

        slot_summaries[_index] =
            "Invalid Save";

        return false;
    }

    slot_summaries[_index] =
        core_save_format_summary(
            _save_data
        );

    slot_timestamps[_index] =
        core_save_get_number(
            _save_data,
            "saved_at",
            0
        );

    return true;
};


refresh_all_save_slots = function()
{
    for (
        var _slot = 1;
        _slot <= save_slot_count;
        _slot++
    )
    {
        refresh_save_slot(
            _slot
        );
    }

    set_active_slot(
        active_slot
    );
};


refresh_save_cache = function()
{
    refresh_save_slot(
        active_slot
    );

    set_active_slot(
        active_slot
    );

    return has_save_file;
};


get_most_recent_slot = function()
{
    refresh_all_save_slots();

    var _latest_slot = -1;
    var _latest_time = -1;

    for (
        var _slot = 1;
        _slot <= save_slot_count;
        _slot++
    )
    {
        var _index =
            _slot - 1;

        if (!slot_has_save[_index])
        {
            continue;
        }

        var _timestamp =
            slot_timestamps[_index];

        if (
            _latest_slot == -1 ||
            _timestamp > _latest_time
        )
        {
            _latest_slot = _slot;
            _latest_time = _timestamp;
        }
    }

    return _latest_slot;
};


request_save = function(
    _slot = active_slot
)
{
    if (gameplay_input_is_locked())
    {
        set_status_message(
            "Cannot save during crafting."
        );

        return false;
    }

    if (!set_active_slot(_slot))
    {
        set_status_message(
            "Invalid save slot."
        );

        return false;
    }

    if (
        !core_save_write_file(
            save_file_name
        )
    )
    {
        set_status_message(
            "Save failed."
        );

        return false;
    }

    refresh_save_slot(
        active_slot
    );

    set_active_slot(
        active_slot
    );

    set_status_message(
        "Game saved in Slot " +
        string(active_slot) +
        "."
    );

    return true;
};


request_load = function(
    _slot = active_slot
)
{
    if (gameplay_input_is_locked())
    {
        set_status_message(
            "Cannot load during crafting."
        );

        return false;
    }

    if (!set_active_slot(_slot))
    {
        set_status_message(
            "Invalid save slot."
        );

        return false;
    }

    var _loaded_data =
        core_save_read_file(
            save_file_name
        );

    if (is_undefined(_loaded_data))
    {
        refresh_save_slot(
            active_slot
        );

        set_status_message(
            "No valid save in Slot " +
            string(active_slot) +
            "."
        );

        return false;
    }

    var _target_room_name =
        string(
            core_save_get(
                _loaded_data,
                "room_name",
                ""
            )
        );

    var _target_room =
        asset_get_index(
            _target_room_name
        );

    if (_target_room == -1)
    {
        set_status_message(
            "Saved room does not exist."
        );

        return false;
    }

    pending_save_data =
        _loaded_data;

    pending_room_name =
        _target_room_name;

    pending_load = true;

    set_status_message(
        "Loading Slot " +
        string(active_slot) +
        "..."
    );

    if (
        room_get_name(room) !=
        pending_room_name
    )
    {
        room_goto(
            _target_room
        );
    }

    return true;
};


request_continue = function()
{
    var _slot =
        get_most_recent_slot();

    if (_slot == -1)
    {
        set_status_message(
            "No saved game found."
        );

        return false;
    }

    return request_load(
        _slot
    );
};


request_new_game = function(
    _slot,
    _gameplay_room
)
{
    if (!set_active_slot(_slot))
    {
        set_status_message(
            "Invalid save slot."
        );

        return false;
    }

    var _filename =
        get_slot_filename(
            active_slot
        );

    if (file_exists(_filename))
    {
        file_delete(_filename);
    }

    pending_load = false;
    pending_save_data = undefined;
    pending_room_name = "";

    refresh_save_slot(
        active_slot
    );

    set_active_slot(
        active_slot
    );

    set_status_message(
        "Starting new game..."
    );

    room_goto(
        _gameplay_room
    );

    return true;
};


delete_save_slot = function(_slot)
{
    if (
        _slot < 1 ||
        _slot > save_slot_count
    )
    {
        return false;
    }

    var _filename =
        get_slot_filename(
            _slot
        );

    if (file_exists(_filename))
    {
        file_delete(_filename);
    }

    refresh_save_slot(
        _slot
    );

    set_active_slot(
        active_slot
    );

    return true;
};


refresh_all_save_slots();
set_active_slot(1);