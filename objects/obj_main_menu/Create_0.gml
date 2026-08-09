/// obj_main_menu — Create Event

display_set_gui_size(
    640,
    360
);

menu_home = 0;
menu_new_game = 1;
menu_load_game = 2;
menu_settings = 3;
menu_credits = 4;
menu_confirm_overwrite = 5;

menu_page = menu_home;
selected_option = 0;
selected_slot = 1;

save_controller =
    instance_find(
        obj_save_controller,
        0
    );

if (!instance_exists(save_controller))
{
    save_controller =
        instance_create_depth(
            0,
            0,
            -1000000,
            obj_save_controller
        );
}

save_controller.refresh_all_save_slots();

home_button_x = 44;
home_button_y = 116;
home_button_width = 180;
home_button_height = 34;
home_button_gap = 7;

panel_x = 252;
panel_y = 54;
panel_width = 344;
panel_height = 270;

slot_x = 270;
slot_y = 94;
slot_width = 308;
slot_height = 54;
slot_gap = 8;

back_button_x = 270;
back_button_y = 286;
back_button_width = 140;
back_button_height = 34;

confirm_slot = -1;
fullscreen_enabled =
    window_get_fullscreen();

menu_status = "";
menu_status_timer = 0;

menu_background_sprite =
    asset_get_index(
        "spr_mainmenu_bg"
    );

menu_button_sprite =
    asset_get_index(
        "spr_mainmenu_button"
    );

menu_button_selected_sprite =
    asset_get_index(
        "spr_mainmenu_button_selected"
    );