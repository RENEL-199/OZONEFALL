if (!variable_global_exists("survival"))
{
    exit;
}

var _survival =
    global.survival;

var _delta_seconds =
    delta_time / 1000000;

_delta_seconds =
    min(
        _delta_seconds,
        0.1
    );


// Keep old saved or initialized directions compatible.
if (
    facing != "up" &&
    facing != "down" &&
    facing != "left" &&
    facing != "right"
)
{
    facing = "down";
}


// ================================================================
// GAMEPLAY LOCK
// ================================================================

if (gameplay_input_is_locked())
{
    xspeed = 0;
    yspeed = 0;

    is_interacting = false;
    interact_timer = 0;

    active_action_animation =
        "interact";

    animation_manager.play_animation(
        "idle_" + facing
    );

    _survival.update(
        _delta_seconds,
        false,
        false
    );

    exit;
}

// ================================================================
// INPUT
// ================================================================

if (!variable_global_exists("player_input"))
{
    exit;
}

var _input =
    global.player_input;

var move_x =
    _input.move_x;

var move_y =
    _input.move_y;

var is_moving =
    move_x != 0 ||
    move_y != 0;


// ================================================================
// DEATH
// ================================================================

if (_survival.is_dead)
{
    is_interacting = false;

    animation_manager.play_animation(
        "idle_" + facing
    );

    _survival.update(
        _delta_seconds,
        false,
        false
    );

    exit;
}


// ================================================================
// INTERACTION
// ================================================================

// ================================================================
// INTERACTION INPUT
// ================================================================

if (
    _input.interact_pressed &&
    !is_interacting
)
{
    start_action_animation(
        "interact",
        20
    );
}


// ================================================================
// SPRINTING
// ================================================================

var wants_to_sprint =
    _input.sprint_held &&
    is_moving &&
    !is_interacting;

var is_sprinting =
    wants_to_sprint &&
    _survival.can_sprint();

var current_speed =
    movement_speed;

if (is_sprinting)
{
    current_speed *=
        sprint_multiplier;
}


// ================================================================
// PREVIOUS POSITION
// ================================================================

var _previous_x = x;
var _previous_y = y;


// ================================================================
// MOVEMENT
// ================================================================

if (!is_interacting)
{
    // ------------------------------------------------------------
// FOUR-DIRECTION FACING
//
// Diagonal movement always uses left or right.
// ------------------------------------------------------------

if (is_moving)
{
    if (
        move_x != 0 &&
        move_y != 0
    )
    {
        if (move_x > 0)
        {
            facing = "right";
        }
        else
        {
            facing = "left";
        }
    }
    else if (move_x > 0)
    {
        facing = "right";
    }
    else if (move_x < 0)
    {
        facing = "left";
    }
    else if (move_y > 0)
    {
        facing = "down";
    }
    else if (move_y < 0)
    {
        facing = "up";
    }
}

    // ------------------------------------------------------------
    // NORMALIZE DIAGONAL MOVEMENT
    // ------------------------------------------------------------

    var _movement_length =
        point_distance(
            0,
            0,
            move_x,
            move_y
        );

    if (_movement_length > 0)
    {
        move_x /=
            _movement_length;

        move_y /=
            _movement_length;
    }


    // ------------------------------------------------------------
    // HORIZONTAL MOVEMENT
    // ------------------------------------------------------------

    if (
        !place_meeting(
            x + move_x * current_speed,
            y,
            obj_fadeble
        )
    )
    {
        x +=
            move_x *
            current_speed;
    }


    // ------------------------------------------------------------
    // VERTICAL MOVEMENT
    // ------------------------------------------------------------

    if (
        !place_meeting(
            x,
            y + move_y * current_speed,
            obj_fadeble
        )
    )
    {
        y +=
            move_y *
            current_speed;
    }


    // ------------------------------------------------------------
    // ANIMATION
    // ------------------------------------------------------------

    if (is_moving)
    {
        animation_manager.play_animation(
            "walk_" + facing
        );
    }
    else
    {
        animation_manager.play_animation(
            "idle_" + facing
        );
    }
}


// ================================================================
// INTERACTION TIMER
// ================================================================

// ================================================================
// INTERACTION ANIMATION AND TIMER
// ================================================================

if (is_interacting)
{
    xspeed = 0;
    yspeed = 0;

    animation_manager.play_animation(
        active_action_animation +
        "_" +
        facing
    );

    interact_timer--;

    if (interact_timer <= 0)
    {
        interact_timer = 0;
        is_interacting = false;

        active_action_animation =
            "interact";

        animation_manager.play_animation(
            "idle_" + facing
        );
    }
}


// ================================================================
// ACTUAL MOVEMENT
// ================================================================

var actually_moving =
    (
        x != _previous_x ||
        y != _previous_y
    ) &&
    !is_interacting;


// ================================================================
// WALKING DUST
// ================================================================

part_system_depth(
    dust_system,
    depth + 1
);

if (actually_moving)
{
    dust_spawn_timer--;

    if (dust_spawn_timer <= 0)
    {
        var _dust_x =
            (
                bbox_left +
                bbox_right
            ) * 0.5;

        var _dust_y =
            bbox_bottom - 1;

        _dust_x +=
            irandom_range(
                -2,
                2
            );

        part_particles_create(
            dust_system,
            _dust_x,
            _dust_y,
            dust_type,
            1
        );

        if (is_sprinting)
        {
            dust_spawn_timer =
                dust_sprint_interval;
        }
        else
        {
            dust_spawn_timer =
                dust_walk_interval;
        }
    }
}
else
{
    dust_spawn_timer = 0;
}


// ================================================================
// SURVIVAL
// ================================================================

_survival.update(
    _delta_seconds,
    actually_moving,
    is_sprinting
);