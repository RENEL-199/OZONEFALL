/// obj_vegetation_controller — Create Event

vegetation_database_create();

restoration_controller =
    noone;


// Common vegetation can grow around every restoration tree.
common_vegetation_object =
    obj_green_grass;

// Green grass remains more common than tree-specific vegetation.
common_vegetation_weight = 120;


// Match the restoration system's eight-tile radius.
restoration_radius_tiles = 8;


// One vegetation cycle per in-game hour.
spawn_interval_minutes = 30;

// Each tree gets several lightweight random attempts per cycle.
spawn_attempts_per_source = 4;

// Not every valid attempt produces vegetation.
spawn_chance_per_attempt = 0.55;

// Prevent crowded vegetation.
minimum_plant_spacing = 20;

// Maximum current plants inside one restoration area.
// Harvesting creates room for new plants to grow later.
maximum_plants_per_source = 32;


// Prevent large time skips from creating too much work in one frame.
maximum_spawn_cycles_per_step = 2;
maximum_spawns_per_step = 4;

next_spawn_timestamp = 0;