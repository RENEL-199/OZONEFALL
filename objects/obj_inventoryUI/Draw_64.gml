draw_set_font(global.game_font);

/// obj_inventoryUI — Draw GUI Event

if (!variable_global_exists("player_inventory"))
{
    exit;
}

var _inventory =
    global.player_inventory;

var _gui_width =
    display_get_gui_width();

var _gui_height =
    display_get_gui_height();

var _mouse_x =
    device_mouse_x_to_gui(0);

var _mouse_y =
    device_mouse_y_to_gui(0);

var _crafting_station_open =
    instance_exists(container_instance) &&
    variable_instance_exists(
        container_instance,
        "is_crafting_station"
    ) &&
    container_instance.is_crafting_station;


// Hotbar
var _hotbar_width =
    hotbar_size *
    hotbar_slot_size +
    (
        hotbar_size - 1
    ) *
    hotbar_padding;

var _hotbar_x =
    (
        _gui_width -
        _hotbar_width
    ) * 0.5;

var _hotbar_y =
    _gui_height -
    hotbar_slot_size -
    hotbar_bottom_margin;

for (
    var _hotbar_index = 0;
    _hotbar_index < hotbar_size;
    _hotbar_index++
)
{
    var _slot_x =
        _hotbar_x +
        _hotbar_index *
        (
            hotbar_slot_size +
            hotbar_padding
        );

    var _hotbar_background =
        slot_sprite;

    if (
        _hotbar_index ==
        global.hotbar_selected
    )
    {
        _hotbar_background =
            slot_selected_sprite;
    }

    draw_sprite_stretched(
        _hotbar_background,

        0,
        _slot_x,
        _hotbar_y,
        hotbar_slot_size,
        hotbar_slot_size
    );

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);

    draw_text(
        _slot_x + 5,
        _hotbar_y + 4,
        string(_hotbar_index + 1)
    );

    if (_hotbar_index >= _inventory.size)
    {
        continue;
    }

    var _hotbar_slot =
        _inventory.slots[
            _hotbar_index
        ];

    if (_hotbar_slot.is_empty())
    {
        continue;
    }

    var _hotbar_data =
        item_get_data(
            _hotbar_slot.item_id
        );

    if (
        is_undefined(_hotbar_data) ||
        !sprite_exists(
            _hotbar_data.sprite
        )
    )
    {
        continue;
    }

    var _hotbar_scale =
        min(
            48 /
            sprite_get_width(
                _hotbar_data.sprite
            ),

            48 /
            sprite_get_height(
                _hotbar_data.sprite
            )
        );

    draw_sprite_ext(
        _hotbar_data.sprite,
        0,
        _slot_x +
        hotbar_slot_size * 0.5,
        _hotbar_y +
        hotbar_slot_size * 0.5,
        _hotbar_scale,
        _hotbar_scale,
        0,
        c_white,
        1
    );

    if (_hotbar_slot.amount > 1)
    {
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        draw_set_color(c_white);

        draw_text(
            _slot_x +
            hotbar_slot_size - 5,
            _hotbar_y +
            hotbar_slot_size - 5,
            string(_hotbar_slot.amount)
        );
    }
}


if (!open)
{
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_alpha(1);

    exit;
}


var _layout =
    inventory_ui_get_layout(
        self,
        _inventory,
        0,
        true
    );


draw_set_alpha(0.97);
draw_set_color(ui_background_color);

draw_rectangle(
    _layout.panel_x,
    _layout.panel_y,
    _layout.panel_x +
    _layout.panel_w,
    _layout.panel_y +
    _layout.panel_h,
    false
);

draw_set_alpha(1);
draw_set_color(ui_border_color);

draw_rectangle(
    _layout.panel_x,
    _layout.panel_y,
    _layout.panel_x +
    _layout.panel_w,
    _layout.panel_y +
    _layout.panel_h,
    true
);


// Tabs
var _tab_labels =
[
    "INV",
    "CRAFT",
    "STAT",
    "LOG",
    "SET"
];

for (
    var _tab_index = 0;
    _tab_index < tab_count;
    _tab_index++
)
{
    var _tab_y =
        _layout.tabs_y +
        _tab_index *
        (
            tab_height +
            tab_gap
        );

    var _tab_color =
        button_color;

    if (_tab_index == active_page)
    {
        _tab_color =
            button_hover_color;
    }

    draw_set_color(_tab_color);

    draw_rectangle(
        _layout.tabs_x,
        _tab_y,
        _layout.tabs_x +
        tab_width,
        _tab_y +
        tab_height,
        false
    );

    draw_set_color(ui_border_color);

    draw_rectangle(
        _layout.tabs_x,
        _tab_y,
        _layout.tabs_x +
        tab_width,
        _tab_y +
        tab_height,
        true
    );

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(ui_text_color);

    draw_text(
        _layout.tabs_x +
        tab_width * 0.5,
        _tab_y +
        tab_height * 0.5,
        _tab_labels[_tab_index]
    );
}


var _page_title = "";

if (
    active_page ==
    settings_page_index
)
{
    _page_title = "SETTINGS";
}
else if (active_page == 0)
{
    _page_title =
        _inventory.name;
}
else
{
    _page_title =
        _tab_labels[active_page];
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(ui_text_color);

draw_text(
    _layout.grid_x,
    _layout.panel_y + 12,
    _page_title
);


// Settings page
if (
    active_page ==
    settings_page_index
)
{
    var _save_controller =
        instance_find(
            obj_save_controller,
            0
        );

    var _settings =
        inventory_ui_get_settings_layout(
            self,
            _layout
        );

    draw_set_color(
        ui_background_color
    );

    draw_rectangle(
        _settings.slot_x,
        _settings.slot_y,
        _settings.slot_x +
        _settings.slot_w,
        _settings.slot_y +
        _settings.slot_h,
        false
    );

    draw_set_color(
        ui_border_color
    );

    draw_rectangle(
        _settings.slot_x,
        _settings.slot_y,
        _settings.slot_x +
        _settings.slot_w,
        _settings.slot_y +
        _settings.slot_h,
        true
    );

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(ui_text_color);

    draw_text(
        _settings.slot_x + 14,
        _settings.slot_y + 12,
        "SAVE SLOT 1"
    );

    draw_set_color(
        ui_description_color
    );

    var _save_summary_text =
        "Save controller missing";

    if (
        instance_exists(
            _save_controller
        )
    )
    {
        _save_summary_text =
            _save_controller
                .save_summary;
    }

    draw_text_ext(
        _settings.slot_x + 14,
        _settings.slot_y + 48,
        _save_summary_text,
        18,
        _settings.slot_w - 28
    );


    var _save_enabled =
        instance_exists(
            _save_controller
        ) &&
        !gameplay_input_is_locked();

    var _load_enabled =
        _save_enabled &&
        _save_controller
            .has_save_file;


    var _save_button_color =
        button_disabled_color;

    if (_save_enabled)
    {
        _save_button_color =
            button_color;

        if (settings_hovered_button == 0)
        {
            _save_button_color =
                button_hover_color;
        }
    }

    draw_set_color(
        _save_button_color
    );

    draw_rectangle(
        _settings.save_x,
        _settings.save_y,
        _settings.save_x +
        _settings.button_w,
        _settings.save_y +
        _settings.button_h,
        false
    );

    draw_set_color(ui_border_color);

    draw_rectangle(
        _settings.save_x,
        _settings.save_y,
        _settings.save_x +
        _settings.button_w,
        _settings.save_y +
        _settings.button_h,
        true
    );


    var _load_button_color =
        button_disabled_color;

    if (_load_enabled)
    {
        _load_button_color =
            button_color;

        if (settings_hovered_button == 1)
        {
            _load_button_color =
                button_hover_color;
        }
    }

    draw_set_color(
        _load_button_color
    );

    draw_rectangle(
        _settings.load_x,
        _settings.load_y,
        _settings.load_x +
        _settings.button_w,
        _settings.load_y +
        _settings.button_h,
        false
    );

    draw_set_color(ui_border_color);

    draw_rectangle(
        _settings.load_x,
        _settings.load_y,
        _settings.load_x +
        _settings.button_w,
        _settings.load_y +
        _settings.button_h,
        true
    );


    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    var _save_text_color =
        c_gray;

    if (_save_enabled)
    {
        _save_text_color =
            ui_text_color;
    }

    draw_set_color(
        _save_text_color
    );

    draw_text(
        _settings.save_x +
        _settings.button_w * 0.5,
        _settings.save_y +
        _settings.button_h * 0.5,
        "SAVE GAME"
    );

    var _load_text_color =
        c_gray;

    if (_load_enabled)
    {
        _load_text_color =
            ui_text_color;
    }

    draw_set_color(
        _load_text_color
    );

    var _load_button_text =
        "LOAD GAME";

    if (settings_load_confirmation)
    {
        _load_button_text =
            "CLICK AGAIN TO LOAD";
    }

    draw_text(
        _settings.load_x +
        _settings.button_w * 0.5,
        _settings.load_y +
        _settings.button_h * 0.5,

        _load_button_text
    );


    if (
        instance_exists(
            _save_controller
        ) &&
        _save_controller
            .status_message_timer > 0
    )
    {
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_set_color(
            ui_description_color
        );

        draw_text(
            _settings.page_x +
            _settings.page_w * 0.5,
            _settings.load_y +
            _settings.button_h +
            22,
            _save_controller
                .status_message
        );
    }


    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_alpha(1);

    exit;
}


// Future pages
if (active_page != 0)
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(
        ui_description_color
    );

    draw_text(
        _layout.panel_x +
        _layout.content_w * 0.5,
        _layout.panel_y +
        _layout.panel_h * 0.5,
        "This page will be added later."
    );

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_alpha(1);

    exit;
}


// Player inventory
for (
    var _slot_index = 0;
    _slot_index < _inventory.size;
    _slot_index++
)
{
    var _slot_x =
        _layout.grid_x +
        (
            _slot_index mod columns
        ) *
        (
            slot_size +
            slot_padding
        );

    var _slot_y =
        _layout.grid_y +
        (
            _slot_index div columns
        ) *
        (
            slot_size +
            slot_padding
        );

    var _selected =
        selected_inventory ==
        _inventory &&
        selected_slot ==
        _slot_index;

    var _hovered =
        hovered_inventory ==
        _inventory &&
        hovered_slot ==
        _slot_index;

    var _player_slot_background =
        slot_sprite;

    if (_selected || _hovered)
    {
        _player_slot_background =
            slot_selected_sprite;
    }

    draw_sprite_stretched(
        _player_slot_background,

        0,
        _slot_x,
        _slot_y,
        slot_size,
        slot_size
    );

    var _slot =
        _inventory.slots[
            _slot_index
        ];

    if (_slot.is_empty())
    {
        continue;
    }

    var _item_data =
        item_get_data(
            _slot.item_id
        );

    var _hidden =
        dragging &&
        drag_source_inventory ==
        _inventory &&
        drag_source_slot ==
        _slot_index;

    if (
        _hidden ||
        is_undefined(_item_data) ||
        !sprite_exists(
            _item_data.sprite
        )
    )
    {
        continue;
    }

    var _item_scale =
        min(
            42 /
            sprite_get_width(
                _item_data.sprite
            ),

            42 /
            sprite_get_height(
                _item_data.sprite
            )
        );

    draw_sprite_ext(
        _item_data.sprite,
        0,
        _slot_x +
        slot_size * 0.5,
        _slot_y +
        slot_size * 0.5,
        _item_scale,
        _item_scale,
        0,
        c_white,
        1
    );

    if (_slot.amount > 1)
    {
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        draw_set_color(c_white);

        draw_text(
            _slot_x +
            slot_size - 5,
            _slot_y +
            slot_size - 5,
            string(_slot.amount)
        );
    }
}


// Normal chest/container panel
if (
    !is_undefined(container_inventory) &&
    !_crafting_station_open
)
{
    var _foreign_layout =
        inventory_ui_get_layout(
            self,
            container_inventory,
            1,
            false
        );

    draw_set_alpha(0.97);
    draw_set_color(
        ui_background_color
    );

    draw_rectangle(
        _foreign_layout.panel_x,
        _foreign_layout.panel_y,
        _foreign_layout.panel_x +
        _foreign_layout.panel_w,
        _foreign_layout.panel_y +
        _foreign_layout.panel_h,
        false
    );

    draw_set_alpha(1);
    draw_set_color(ui_border_color);

    draw_rectangle(
        _foreign_layout.panel_x,
        _foreign_layout.panel_y,
        _foreign_layout.panel_x +
        _foreign_layout.panel_w,
        _foreign_layout.panel_y +
        _foreign_layout.panel_h,
        true
    );

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(ui_text_color);

    draw_text(
        _foreign_layout.grid_x,
        _foreign_layout.panel_y + 12,
        container_inventory.name
    );

    for (
        var _container_slot = 0;
        _container_slot <
        container_inventory.size;
        _container_slot++
    )
    {
        var _container_x =
            _foreign_layout.grid_x +
            (
                _container_slot mod
                columns
            ) *
            (
                slot_size +
                slot_padding
            );

        var _container_y =
            _foreign_layout.grid_y +
            (
                _container_slot div
                columns
            ) *
            (
                slot_size +
                slot_padding
            );

        var _container_selected =
            selected_inventory ==
            container_inventory &&
            selected_slot ==
            _container_slot;

        var _container_hovered =
            hovered_inventory ==
            container_inventory &&
            hovered_slot ==
            _container_slot;

        var _container_slot_background =
            slot_sprite;

        if (
            _container_selected ||
            _container_hovered
        )
        {
            _container_slot_background =
                slot_selected_sprite;
        }

        draw_sprite_stretched(
            _container_slot_background,

            0,
            _container_x,
            _container_y,
            slot_size,
            slot_size
        );

        var _container_item =
            container_inventory
                .slots[_container_slot];

        if (_container_item.is_empty())
        {
            continue;
        }

        var _container_data =
            item_get_data(
                _container_item.item_id
            );

        var _container_hidden =
            dragging &&
            drag_source_inventory ==
            container_inventory &&
            drag_source_slot ==
            _container_slot;

        if (
            _container_hidden ||
            is_undefined(
                _container_data
            ) ||
            !sprite_exists(
                _container_data.sprite
            )
        )
        {
            continue;
        }

        var _container_scale =
            min(
                42 /
                sprite_get_width(
                    _container_data.sprite
                ),

                42 /
                sprite_get_height(
                    _container_data.sprite
                )
            );

        draw_sprite_ext(
            _container_data.sprite,
            0,
            _container_x +
            slot_size * 0.5,
            _container_y +
            slot_size * 0.5,
            _container_scale,
            _container_scale,
            0,
            c_white,
            1
        );

        if (_container_item.amount > 1)
        {
            draw_set_halign(fa_right);
            draw_set_valign(fa_bottom);
            draw_set_color(c_white);

            draw_text(
                _container_x +
                slot_size - 5,
                _container_y +
                slot_size - 5,
                string(
                    _container_item.amount
                )
            );
        }
    }
}


// Description panel
var _description_layout =
    _layout;

if (
    !_crafting_station_open &&
    !is_undefined(container_inventory) &&
    selected_inventory ==
    container_inventory
)
{
    _description_layout =
        inventory_ui_get_layout(
            self,
            container_inventory,
            1,
            false
        );
}

draw_set_color(ui_border_color);

draw_rectangle(
    _description_layout.description_x,
    _description_layout.description_y,
    _description_layout.description_x +
    _description_layout.description_w,
    _description_layout.description_y +
    _description_layout.description_h,
    true
);


var _has_selection =
    !is_undefined(
        selected_inventory
    ) &&
    selected_inventory.is_valid_slot(
        selected_slot
    ) &&
    !selected_inventory
        .slots[selected_slot]
        .is_empty();

var _can_use = false;
var _can_split = false;

if (_has_selection)
{
    var _selected_slot =
        selected_inventory
            .slots[selected_slot];

    var _selected_data =
        item_get_data(
            _selected_slot.item_id
        );

    if (!is_undefined(_selected_data))
    {
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(ui_text_color);

        draw_text(
            _description_layout
                .description_x + 12,
            _description_layout
                .description_y + 10,
            _selected_data.name
        );

        draw_set_halign(fa_right);

        draw_text(
            _description_layout
                .description_x +
            _description_layout
                .description_w - 12,
            _description_layout
                .description_y + 10,
            "x" +
            string(
                _selected_slot.amount
            )
        );

        draw_set_halign(fa_left);
        draw_set_color(
            ui_description_color
        );

        draw_text_ext(
            _description_layout
                .description_x + 12,
            _description_layout
                .description_y + 42,
            _selected_data.description,
            18,
            _description_layout
                .description_w - 24
        );

        _can_use =
            !_crafting_station_open &&
            selected_inventory ==
            global.player_inventory &&
            item_can_use(
                _selected_slot.item_id
            );

        _can_split =
            !_crafting_station_open &&
            _selected_slot.amount > 1 &&
            selected_inventory
                .find_empty_slot() != -1;
    }
}
else
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(
        ui_description_color
    );

    draw_text(
        _description_layout
            .description_x +
        _description_layout
            .description_w * 0.5,

        _description_layout
            .description_y + 75,

        "Select an item to view its description."
    );
}


var _use_x1 =
    _description_layout.description_x;

var _use_x2 =
    _use_x1 +
    (
        _description_layout.description_w -
        button_gap
    ) * 0.5;

var _split_x1 =
    _use_x2 +
    button_gap;

var _split_x2 =
    _description_layout.description_x +
    _description_layout.description_w;

var _button_y2 =
    _description_layout.description_y +
    _description_layout.description_h -
    12;

var _button_y1 =
    _button_y2 -
    button_height;

var _use_hovered =
    point_in_rectangle(
        _mouse_x,
        _mouse_y,
        _use_x1,
        _button_y1,
        _use_x2,
        _button_y2
    );

var _split_hovered =
    point_in_rectangle(
        _mouse_x,
        _mouse_y,
        _split_x1,
        _button_y1,
        _split_x2,
        _button_y2
    );


var _use_button_color =
    button_disabled_color;

if (_can_use)
{
    _use_button_color =
        button_color;

    if (_use_hovered)
    {
        _use_button_color =
            button_hover_color;
    }
}

draw_set_color(
    _use_button_color
);

draw_rectangle(
    _use_x1,
    _button_y1,
    _use_x2,
    _button_y2,
    false
);


var _split_button_color =
    button_disabled_color;

if (_can_split)
{
    _split_button_color =
        button_color;

    if (_split_hovered)
    {
        _split_button_color =
            button_hover_color;
    }
}

draw_set_color(
    _split_button_color
);

draw_rectangle(
    _split_x1,
    _button_y1,
    _split_x2,
    _button_y2,
    false
);


draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _use_text_color =
    c_gray;

if (_can_use)
{
    _use_text_color =
        ui_text_color;
}

draw_set_color(
    _use_text_color
);

draw_text(
    (_use_x1 + _use_x2) * 0.5,
    (_button_y1 + _button_y2) * 0.5,
    "USE"
);

var _split_text_color =
    c_gray;

if (_can_split)
{
    _split_text_color =
        ui_text_color;
}

draw_set_color(
    _split_text_color
);

draw_text(
    (_split_x1 + _split_x2) * 0.5,
    (_button_y1 + _button_y2) * 0.5,
    "UNSTACK"
);


// Drag preview
if (
    dragging &&
    drag_item_id != ItemID.None
)
{
    var _drag_data =
        item_get_data(
            drag_item_id
        );

    if (
        !is_undefined(_drag_data) &&
        sprite_exists(
            _drag_data.sprite
        )
    )
    {
        var _drag_scale =
            min(
                42 /
                sprite_get_width(
                    _drag_data.sprite
                ),

                42 /
                sprite_get_height(
                    _drag_data.sprite
                )
            );

        draw_sprite_ext(
            _drag_data.sprite,
            0,
            _mouse_x,
            _mouse_y,
            _drag_scale,
            _drag_scale,
            0,
            c_white,
            1
        );

        if (drag_amount > 1)
        {
            draw_set_halign(fa_right);
            draw_set_valign(fa_bottom);
            draw_set_color(c_white);

            draw_text(
                _mouse_x + 24,
                _mouse_y + 24,
                string(drag_amount)
            );
        }
    }
}


draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
