/// obj_game — Create Event

window_set_fullscreen(false);

display_set_gui_size(
    1920,
    1080
);


// INPUT CONTROLLER

if (
    !instance_exists(
        obj_input_controller
    )
)
{
    instance_create_depth(
        0,
        0,
        -1000001,
        obj_input_controller
    );
}


// FARMING CONTROLLER

if (
    !instance_exists(
        obj_farming_controller
    )
)
{
    instance_create_depth(
        0,
        0,
        -1000000000000,
        obj_farming_controller
    );
}


gpu_set_texfilter(false);

global.game_font =
    fnt_pixel;


// DATABASES

item_database_create();
farm_crop_database_create();
crafting_recipe_database_create();
tree_species_database_create();
campfire_recipe_database_create();

vegetation_sway_initialize();


// GLOBAL GAMEPLAY STATE

global.gameplay_lock_owner =
    noone;

global.player_inventory =
    new Inventory(
        30,
        "Player Inventory"
    );

global.hotbar_size = 8;
global.hotbar_selected = 0;

global.survival =
    new SurvivalSystem();


// TEMPORARY DEBUG ITEMS



global.player_inventory.add_item(
    ItemID.Kamote_seed,
    10
);

global.player_inventory.add_item(
    ItemID.Hoe,
    1
);

global.player_inventory.add_item(
    ItemID.Watering_Can,
    1
);

