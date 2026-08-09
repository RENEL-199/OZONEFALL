// ================================================================
// HUD LAYOUT
// ================================================================

hud_x = 24;
hud_y = 24;

// Change this to resize the entire HUD.
// Recommended values: 2 or 3.
hud_scale = 3;

// Native spacing based on the 55x16 sprite frames.
hud_row_spacing = 16;

// Interior section of the bars inside the sprite.
hud_bar_x = 10;
hud_bar_width = 43;
hud_bar_height = 4;

// The first frame's bar is slightly higher.
hud_fill_y = [4, 6, 6, 6, 6];

hud_sprite = spr_survival_ui;

// Set this to your pixel-font resource.
// Keep -1 to use the currently selected font.
hud_font = -1;


// ================================================================
// BAR COLORS
// ================================================================

empty_color = make_color_rgb(
    35,
    37,
    42
);

vitality_color = make_color_rgb(
    210,
    65,
    65
);

hunger_color = make_color_rgb(
    221,
    158,
    57
);

hydration_color = make_color_rgb(
    62,
    155,
    219
);

toxicity_color = make_color_rgb(
    116,
    201,
    85
);

stamina_color = make_color_rgb(
    235,
    215,
    91
);

value_color = c_white;
value_shadow_color = c_black;