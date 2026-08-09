/// obj_narra_1 — Create Event

event_inherited();

sprite_index = spr_narra_1;
image_index = 0;
image_speed = 0;
sway_strength = 0.35;
sway_speed = 1;

// ====================================================================
// GROWTH
// ====================================================================

// Planted → Juvenile after one game day.
tree_growth_initialize(
    id,
    obj_narra_2,
    1140
);


// ====================================================================
// HARVESTING
// ====================================================================

tree_harvest_initialize(
    id,
    1,

    [
        // Cutting a planted Narra returns its Seed.
        new TreeHarvestDrop(
            ItemID.Narra_seed,
            1,
            1,
            1
        )
    ]
);