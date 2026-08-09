open = false;
active_page = 0; // 0 Inventory; other values are reserved for future pages.

bg_sprite = spr_inventory_bg;
slot_sprite = spr_slot;
slot_selected_sprite = spr_slot_selected;

columns = 6;
slot_size = 72;
slot_padding = 2;
inner_padding = 18;
title_height = 42;
section_gap = 10;
description_height = 210;
tab_width = 70;
tab_height = 70;
tab_gap = 4;
tab_count = 5;
screen_margin = 24;

selected_inventory = undefined;
selected_slot = -1;
hovered_inventory = undefined;
hovered_slot = -1;

hotbar_size = 8;
hotbar_slot_size = 95;
hotbar_padding = 12;
hotbar_bottom_margin = 32;
global.hotbar_selected = 0;
hotbar_use_key = ord("F");

container_inventory = undefined;
container_instance = noone;

dragging = false;
drag_source_inventory = undefined;
drag_source_slot = -1;
drag_item_id = ItemID.None;
drag_amount = 0;

button_height = 38;
button_gap = 10;
ui_background_color = make_color_rgb(47, 45, 42);
ui_border_color = make_color_rgb(27, 25, 24);
ui_text_color = make_color_rgb(235, 229, 213);
ui_description_color = make_color_rgb(205, 199, 186);
button_color = make_color_rgb(76, 73, 67);
button_hover_color = make_color_rgb(104, 99, 89);
button_disabled_color = make_color_rgb(55, 53, 50);


settings_page_index = 4;

settings_button_width = 280;
settings_button_height = 54;
settings_button_gap = 14;
settings_section_gap = 22;

settings_load_confirmation = false;
settings_load_confirmation_timer = 0;

settings_hovered_button = -1;