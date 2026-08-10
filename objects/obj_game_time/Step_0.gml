/// obj_game_time — Step Event

if (keyboard_check(vk_alt)) {
	global.game_time.add_hours(1); // for debuging
}

if (!variable_global_exists("game_time"))
{
    exit;
}

// delta_time is measured in microseconds.
// Convert it to seconds for the clock.
var _real_seconds =
    delta_time / 1000000;

// Prevent a large time jump if the game freezes,
// minimizes, or loads slowly.
_real_seconds = min(
    _real_seconds,
    0.25
);

global.game_time.update(
    _real_seconds
);