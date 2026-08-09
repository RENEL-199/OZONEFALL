/// obj_dead_narra — Create Event

event_inherited();

image_speed = 0;

tree_harvest_initialize(
    id,
    5,

    [
        new TreeHarvestDrop(
            ItemID.Log,
            2,
            4,
            1
        ),

        new TreeHarvestDrop(
            ItemID.Stick,
            1,
            3,
            1
        ),

        new TreeHarvestDrop(
            ItemID.balete_seed,
            1,
            1,
            0.25
        )
    ]
);