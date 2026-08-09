/// obj_vegetation_controller — Step Event

if (!variable_global_exists("game_time"))
{
    exit;
}


// Recover the restoration controller if it does not exist yet
// or if the room was restarted.
if (!instance_exists(restoration_controller))
{
    restoration_controller =
        instance_find(
            obj_restoration_controller,
            0
        );
}

if (!instance_exists(restoration_controller))
{
    exit;
}

if (
    restoration_controller.ground_tilemap_id
    == -1
)
{
    exit;
}


// Start the first scheduled vegetation cycle.
if (next_spawn_timestamp <= 0)
{
    next_spawn_timestamp =
        global.game_time.create_timestamp(
            spawn_interval_minutes
        );

    exit;
}


var _cycles_processed = 0;

var _spawn_budget =
    maximum_spawns_per_step;


// Catch up after sleeping or skipping time, but keep a frame limit.
while (
    _cycles_processed <
    maximum_spawn_cycles_per_step &&

    _spawn_budget > 0 &&

    global.game_time.timestamp_reached(
        next_spawn_timestamp
    )
)
{
    var _spawned =
        vegetation_process_cycle(
            restoration_controller,
            id,
            _spawn_budget
        );

    _spawn_budget -=
        _spawned;

    next_spawn_timestamp +=
        spawn_interval_minutes;

    _cycles_processed++;
}