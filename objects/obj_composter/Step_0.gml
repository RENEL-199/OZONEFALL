can_interact = false;

if (message_timer > 0)
{
    message_timer--;
}

if (completion_pulse_timer > 0)
{
    completion_pulse_timer--;
}


// Finish the current batch.
if (
    is_processing &&
    variable_global_exists(
        "game_time"
    ) &&
    global.game_time.timestamp_reached(
        processing_finish_timestamp
    )
)
{
    complete_processing();
}



// Start a full composter if game time was unavailable earlier.
if (
    !is_processing &&
    stored_materials >=
    material_capacity
)
{
    start_processing();
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


var _distance =
    point_distance(
        x,
        bbox_bottom,
        _player.x,
        _player.bbox_bottom
    );

var _nearest_composter =
    instance_nearest(
        _player.x,
        _player.y,
        obj_composter
    );

can_interact =
    _distance <= interaction_range &&
    _nearest_composter == id;


var _interact_pressed =
    keyboard_check_pressed(
        interaction_key
    );

if (
    variable_global_exists(
        "player_input"
    ) &&
    is_struct(
        global.player_input
    )
)
{
    _interact_pressed =
        _interact_pressed ||
        global.player_input.interact_pressed;
}


if (
    can_interact &&
    _interact_pressed
)
{
	
	
	 if (is_processing)
    {
        player_say(
            "The compost is still processing."
        );

        exit;
    }
	
	
    if (is_processing)
    {
        if (
            variable_global_exists(
                "game_time"
            )
        )
        {
            var _remaining_minutes =
                global.game_time.minutes_until(
                    processing_finish_timestamp
                );

            var _hours =
                _remaining_minutes div 60;

            var _minutes =
                _remaining_minutes mod 60;

            set_message(
                "Processing: " +
                string(_hours) +
                "h " +
                string(_minutes) +
                "m remaining."
            );
        }
    }
    else
    {
        deposit_selected_material();
    }
}


depth = -bbox_bottom;