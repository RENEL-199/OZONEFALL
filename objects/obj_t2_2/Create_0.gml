/// obj_narra_2 — Create Event

event_inherited();

sprite_index = spr_t2_2;
image_index = 0;
image_speed = 0;
sway_strength = 0.75;
sway_speed = 0.85;

// ====================================================================
// GROWTH
// ====================================================================

// Juvenile → Mature after one additional game day.
tree_growth_initialize(
    id,
    obj_t2_3,
    1140
);


// ====================================================================
// HARVESTING
// ====================================================================

tree_harvest_initialize(
    id,
    3,

    [
        // Guaranteed Sticks
        new TreeHarvestDrop(
            ItemID.Stick,
            1,
            2,
            1
        ),

        // 50% chance of returning a Narra Seed
        new TreeHarvestDrop(
            ItemID.balete_seed,
            1,
            1,
            0.50
        )
    ]
);