/// obj_narra_3 — Create Event

event_inherited();

sprite_index = spr_narra_3;
image_index = 0;
image_speed = 0;
sway_strength = 1.15;
sway_speed = 0.65;

shadow_enabled = true;

shadow_width_scale = 1.15;
shadow_height_ratio = 0.68;

shadow_offset_x = 3;
shadow_offset_y = -5;

shadow_alpha = 0.30;

// Mature trees register with the restoration controller.
restoration_registered = false;
// ====================================================================
// MATURE GROWTH STATE
// ====================================================================

growth_next_object = noone;
growth_duration_minutes = 0;

growth_start_timestamp =
    variable_global_exists("game_time")
        ? global.game_time.get_timestamp()
        : 0;

growth_finish_timestamp = 0;


// ====================================================================
// MATURE NARRA HARVESTING
// ====================================================================

tree_harvest_initialize(
    id,
    5,

    [
        // Guaranteed Logs
        new TreeHarvestDrop(
            ItemID.Log,
            2,
            4,
            1
        ),

        // Guaranteed Sticks
        new TreeHarvestDrop(
            ItemID.Stick,
            1,
            3,
            1
        ),

        // Exactly two Narra Seeds, guaranteed
        new TreeHarvestDrop(
            ItemID.Narra_seed,
            2,
            2,
            1
        )
    ]
);