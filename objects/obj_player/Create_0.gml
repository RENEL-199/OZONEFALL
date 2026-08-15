// ================================================================
// INTERACTION
// ================================================================
is_interacting = false;
interact_timer = 0;

// ================================================================
// MOVEMENT
// ================================================================
movement_speed = 1;
sprint_multiplier = 2;

xspeed = 0;
yspeed = 0;


// ====================================================================
// WALKING DUST
// ====================================================================
dust_system = part_system_create();
dust_type = part_type_create();

// Draw dust behind the player.
part_system_depth(
    dust_system,
    depth + 1
);

// Use GameMaker's built-in pixel particle.
part_type_shape(
    dust_type,
    pt_shape_pixel
);

// Dust size
part_type_size(
    dust_type,
    2,
    3,
    -0.05,
    0
);

// Dust movement
part_type_speed(
    dust_type,
    0.10,
    0.35,
    -0.01,
    0
);

part_type_direction(
    dust_type,
    0,
    360,
    0,
    0
);

// Sandy gray-brown palette
part_type_color_mix(
    dust_type,
    make_color_rgb(155, 139, 112),
    make_color_rgb(105, 96, 82)
);

// Fade away
part_type_alpha2(
    dust_type,
    0.75,
    0
);

// Particle lifetime
part_type_life(
    dust_type,
    18,
    30
);

// Spawn settings
dust_spawn_timer = 0;
dust_walk_interval = 5;
dust_sprint_interval = 3;
// ================================================================
// DIRECTION
// ================================================================

facing = "down";
face = "down";

image_xscale = 1;


// ================================================================
// ANIMATION SYSTEM
// ================================================================

animation_manager =
    new AnimationManager(self);


// ================================================================
// IDLE
// ================================================================

animation_manager.add_animation(
    "idle_down",
    new Animation(
        0,
        5,
        0.08
    )
);

animation_manager.add_animation(
    "idle_left",
    new Animation(
        6,
        10,
        0.08
    )
);

animation_manager.add_animation(
    "idle_right",
    new Animation(
        11,
        15,
        0.08
    )
);

animation_manager.add_animation(
    "idle_up",
    new Animation(
        16,
        20,
        0.08
    )
);


// ================================================================
// WALKING
// ================================================================

animation_manager.add_animation(
    "walk_down",
    new Animation(
        21,
        26,
        0.08
    )
);

animation_manager.add_animation(
    "walk_left",
    new Animation(
        27,
        32,
        0.08
    )
);

animation_manager.add_animation(
    "walk_right",
    new Animation(
        33,
        38,
        0.08
    )
);

animation_manager.add_animation(
    "walk_up",
    new Animation(
        39,
        44,
        0.08
    )
);


animation_manager.add_animation(
    "interact_down",
    new Animation(
        45,
        49,
        0.25
    )
);

animation_manager.add_animation(
    "interact_left",
    new Animation(
        50,
        54,
        0.25
    )
);

animation_manager.add_animation(
    "interact_right",
    new Animation(
        55,
        59,
        0.25
    )
);

animation_manager.add_animation(
    "interact_up",
    new Animation(
        60,
        64,
        0.25
    )
);

animation_manager.add_animation(
    "hoe_down",
    new Animation(
        65,
        68,
        0.25
    )
);

animation_manager.add_animation(
    "hoe_left",
    new Animation(
        69,
        72,
        0.25
    )
);

animation_manager.add_animation(
    "hoe_right",
    new Animation(
        73,
        76,
        0.25
    )
);

animation_manager.add_animation(
    "hoe_up",
    new Animation(
        77,
        81,
        0.25
    )
);



animation_manager.instance.image_speed = 0;

active_action_animation =
    "interact";

start_action_animation = function(
    _action_name,
    _duration_steps = 20
)
{
    active_action_animation =
        string(_action_name);

    is_interacting = true;

    interact_timer =
        max(
            1,
            floor(_duration_steps)
        );

    animation_manager.play_animation(
        active_action_animation +
        "_" +
        facing
    );

    return true;
};