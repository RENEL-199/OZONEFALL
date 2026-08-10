if (instance_number(object_index) > 1)
{
    instance_destroy();
    exit;
}

persistent = true;
depth = -bbox_bottom*5;

global.game_time = new GameTime(
    1,
    6,
    0
);

night_color =
    make_color_rgb(
        12,
        18,
        34
    );

clock_gui_x = 32;
clock_gui_y = 28;

clock_background_width = 220;
clock_background_height = 46;


// Camera-sized darkness surface
lighting_surface = -1;

// Higher values are smoother but require more circle draws.
light_falloff_layers = 14;