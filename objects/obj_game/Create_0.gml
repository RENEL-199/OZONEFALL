/// obj_game — Create Event

window_set_fullscreen(false);

display_set_gui_size(
    1920,
    1080
);
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
gpu_set_texfilter(false);

global.game_font =
    fnt_pixel;

item_database_create();
crafting_recipe_database_create();
tree_species_database_create();
vegetation_sway_initialize();
campfire_recipe_database_create();

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