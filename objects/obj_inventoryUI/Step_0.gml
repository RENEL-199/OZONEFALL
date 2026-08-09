/// obj_inventoryUI — Step Event
if (settings_load_confirmation_timer > 0)
{
    settings_load_confirmation_timer--;

    if (
        settings_load_confirmation_timer <= 0
    )
    {
        settings_load_confirmation = false;
    }
}




if (gameplay_input_is_locked())
{
    dragging = false;
    drag_source_inventory = undefined;
    drag_source_slot = -1;
    drag_item_id = ItemID.None;
    drag_amount = 0;

    if (
        variable_global_exists(
            "player_inventory"
        )
    )
    {
        hotbar_sync_placement(
            global.player_inventory,
            global.hotbar_selected,
            true
        );
    }

    exit;
}


if (keyboard_check_pressed(vk_tab))
{
    open = !open;

    if (!open)
    {
        selected_inventory = undefined;
        selected_slot = -1;

        hovered_inventory = undefined;
        hovered_slot = -1;

        dragging = false;
        drag_source_inventory = undefined;
        drag_source_slot = -1;
        drag_item_id = ItemID.None;
        drag_amount = 0;

        if (instance_exists(container_instance))
        {
            container_instance.is_open = false;
        }

        container_inventory = undefined;
        container_instance = noone;
    }
}


if (!variable_global_exists("player_inventory"))
{
    exit;
}

var _inv =
    global.player_inventory;

// In obj_inventoryUI's Step Event, replace the existing hotbar
// keyboard and mouse-wheel input block with this block.

for (
    var _key = 0;
    _key < hotbar_size;
    _key++
)
{
    if (
        !open &&
        keyboard_check_pressed(
            ord(
                string(_key + 1)
            )
        )
    )
    {
        global.hotbar_selected =
            _key;
    }
}

if (!open)
{
    if (mouse_wheel_down())
    {
        global.hotbar_selected =
            (
                global.hotbar_selected +
                1
            )
            mod hotbar_size;
    }

    if (mouse_wheel_up())
    {
        global.hotbar_selected =
            (
                global.hotbar_selected -
                1 +
                hotbar_size
            )
            mod hotbar_size;
    }
}

if (
    !open &&
    keyboard_check_pressed(
        hotbar_use_key
    ) &&
    _inv.is_valid_slot(
        global.hotbar_selected
    )
)
{
    var _hotbar_slot =
        _inv.slots[
            global.hotbar_selected
        ];

if (!_hotbar_slot.is_empty())
{
    inventory_use_slot(
        _inv,
        global.hotbar_selected
    );
}
}



var _gui_width =
    display_get_gui_width();

var _gui_height =
    display_get_gui_height();

var _mouse_x =
    device_mouse_x_to_gui(0);

var _mouse_y =
    device_mouse_y_to_gui(0);


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


// Select a hotbar slot with the mouse.
if (
    !open &&
    mouse_check_button_pressed(
        mb_left
    )
)
{
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

        if (
            point_in_rectangle(
                _mouse_x,
                _mouse_y,
                _slot_x,
                _hotbar_y,
                _slot_x +
                hotbar_slot_size,
                _hotbar_y +
                hotbar_slot_size
            )
        )
        {
            global.hotbar_selected =
                _hotbar_index;

            break;
        }
    }
}


hotbar_sync_placement(
    global.player_inventory,
    global.hotbar_selected,
    open
);

if (!open)
{
    exit;
}


// Close a container if the player walks away.
if (instance_exists(container_instance))
{
    var _player =
        instance_find(obj_player, 0);

    if (
        instance_exists(_player) &&
        point_distance(
            _player.x,
            _player.y,
            container_instance.x,
            container_instance.y
        ) >
        container_instance.interaction_range +
        24
    )
    {
        container_instance.is_open =
            false;

        container_inventory =
            undefined;

        container_instance =
            noone;

        selected_inventory =
            undefined;

        selected_slot = -1;
    }
}


var _crafting_station_open =
    instance_exists(container_instance) &&
    variable_instance_exists(
        container_instance,
        "is_crafting_station"
    ) &&
    container_instance.is_crafting_station;


var _layout =
    inventory_ui_get_layout(
        self,
        _inv,
        0,
        true
    );


// Future-page tabs.
if (
    mouse_check_button_pressed(
        mb_left
    )
)
{
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

        if (
            point_in_rectangle(
                _mouse_x,
                _mouse_y,
                _layout.tabs_x,
                _tab_y,
                _layout.tabs_x +
                tab_width,
                _tab_y +
                tab_height
            )
        )
        {
            active_page =
                _tab_index;

            if (_tab_index != 0)
            {
                dragging = false;
                hovered_slot = -1;
            }

            exit;
        }
    }
}

if (
    active_page ==
    settings_page_index
)
{
    settings_hovered_button = -1;

    var _save_controller =
        instance_find(
            obj_save_controller,
            0
        );

    var _settings_layout =
        inventory_ui_get_settings_layout(
            self,
            _layout
        );

    var _save_hovered =
        point_in_rectangle(
            _mouse_x,
            _mouse_y,
            _settings_layout.save_x,
            _settings_layout.save_y,
            _settings_layout.save_x +
            _settings_layout.button_w,
            _settings_layout.save_y +
            _settings_layout.button_h
        );

    var _load_hovered =
        point_in_rectangle(
            _mouse_x,
            _mouse_y,
            _settings_layout.load_x,
            _settings_layout.load_y,
            _settings_layout.load_x +
            _settings_layout.button_w,
            _settings_layout.load_y +
            _settings_layout.button_h
        );

    if (_save_hovered)
    {
        settings_hovered_button = 0;
    }
    else if (_load_hovered)
    {
        settings_hovered_button = 1;
    }

    if (
        instance_exists(_save_controller) &&
        mouse_check_button_pressed(mb_left)
    )
    {
        if (_save_hovered)
        {
            settings_load_confirmation =
                false;

            settings_load_confirmation_timer =
                0;

            _save_controller.request_save();
        }
        else if (
            _load_hovered &&
            _save_controller.has_save_file
        )
        {
            if (settings_load_confirmation)
            {
                settings_load_confirmation =
                    false;

                settings_load_confirmation_timer =
                    0;

                _save_controller.request_load();
            }
            else
            {
                settings_load_confirmation =
                    true;

                settings_load_confirmation_timer =
                    180;
            }
        }
    }

    exit;
}

if (active_page != 0)
{
    exit;
}


var _player_layout =
    inventory_ui_get_layout(
        self,
        _inv,
        0,
        true
    );


hovered_inventory = undefined;
hovered_slot = -1;


// Player inventory slots.
for (
    var _player_slot = 0;
    _player_slot < _inv.size;
    _player_slot++
)
{
    var _player_slot_x =
        _player_layout.grid_x +
        (
            _player_slot mod columns
        ) *
        (
            slot_size +
            slot_padding
        );

    var _player_slot_y =
        _player_layout.grid_y +
        (
            _player_slot div columns
        ) *
        (
            slot_size +
            slot_padding
        );

    if (
        point_in_rectangle(
            _mouse_x,
            _mouse_y,
            _player_slot_x,
            _player_slot_y,
            _player_slot_x +
            slot_size,
            _player_slot_y +
            slot_size
        )
    )
    {
        hovered_inventory =
            _inv;

        hovered_slot =
            _player_slot;

        break;
    }
}


// Foreign inventory or crafting material slots.
if (
    hovered_slot == -1 &&
    !is_undefined(container_inventory)
)
{
    if (_crafting_station_open)
    {
        var _craft_layout =
            crafting_ui_get_layout(
                self,
                container_instance
            );

        for (
            var _material_slot = 0;
            _material_slot <
            container_inventory.size;
            _material_slot++
        )
        {
            var _material_x =
                _craft_layout.material_x +
                _material_slot *
                (
                    _craft_layout
                        .material_slot_size +
                    _craft_layout
                        .material_gap
                );

            var _material_y =
                _craft_layout.material_y;

            if (
                point_in_rectangle(
                    _mouse_x,
                    _mouse_y,
                    _material_x,
                    _material_y,
                    _material_x +
                    _craft_layout
                        .material_slot_size,
                    _material_y +
                    _craft_layout
                        .material_slot_size
                )
            )
            {
                hovered_inventory =
                    container_inventory;

                hovered_slot =
                    _material_slot;

                break;
            }
        }
    }
    else
    {
        var _foreign_layout =
            inventory_ui_get_layout(
                self,
                container_inventory,
                1,
                false
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

            if (
                point_in_rectangle(
                    _mouse_x,
                    _mouse_y,
                    _container_x,
                    _container_y,
                    _container_x +
                    slot_size,
                    _container_y +
                    slot_size
                )
            )
            {
                hovered_inventory =
                    container_inventory;

                hovered_slot =
                    _container_slot;

                break;
            }
        }
    }
}


// Item action layout.
var _action_layout =
    _player_layout;

if (
    !_crafting_station_open &&
    !is_undefined(container_inventory) &&
    selected_inventory ==
    container_inventory
)
{
    _action_layout =
        inventory_ui_get_layout(
            self,
            container_inventory,
            1,
            false
        );
}


var _use_x1 =
    _action_layout.description_x;

var _use_x2 =
    _use_x1 +
    (
        _action_layout.description_w -
        button_gap
    ) * 0.5;

var _unstack_x1 =
    _use_x2 +
    button_gap;

var _unstack_x2 =
    _action_layout.description_x +
    _action_layout.description_w;

var _button_y2 =
    _action_layout.description_y +
    _action_layout.description_h -
    12;

var _button_y1 =
    _button_y2 -
    button_height;

var _button_handled =
    false;


// Use and Unstack buttons.
if (
    !_crafting_station_open &&
    mouse_check_button_pressed(
        mb_left
    ) &&
    !is_undefined(
        selected_inventory
    ) &&
    selected_inventory.is_valid_slot(
        selected_slot
    )
)
{
    var _selected_slot =
        selected_inventory
            .slots[selected_slot];

    if (
        !_selected_slot.is_empty() &&
        point_in_rectangle(
            _mouse_x,
            _mouse_y,
            _use_x1,
            _button_y1,
            _use_x2,
            _button_y2
        )
    )
    {
        _button_handled = true;

       if (
    selected_inventory ==
    global.player_inventory &&
    inventory_use_slot(
        selected_inventory,
        selected_slot
    )
)
{
    if (
        selected_inventory
            .slots[selected_slot]
            .is_empty()
    )
    {
        selected_inventory =
            undefined;

        selected_slot = -1;
    }
}
    }
    else if (
        !_selected_slot.is_empty() &&
        point_in_rectangle(
            _mouse_x,
            _mouse_y,
            _unstack_x1,
            _button_y1,
            _unstack_x2,
            _button_y2
        )
    )
    {
        _button_handled = true;

        if (
            _selected_slot.amount > 1 &&
            selected_inventory
                .find_empty_slot() != -1
        )
        {
            selected_inventory
                .split_stack(
                    selected_slot
                );
        }
    }
}


// Select a slot and begin dragging.
if (
    mouse_check_button_pressed(
        mb_left
    ) &&
    !_button_handled &&
    hovered_slot != -1 &&
    !is_undefined(
        hovered_inventory
    )
)
{
    selected_inventory =
        hovered_inventory;

    selected_slot =
        hovered_slot;

    var _clicked_slot =
        hovered_inventory
            .slots[hovered_slot];

    if (!_clicked_slot.is_empty())
    {
        dragging = true;

        drag_source_inventory =
            hovered_inventory;

        drag_source_slot =
            hovered_slot;

        drag_item_id =
            _clicked_slot.item_id;

        drag_amount =
            _clicked_slot.amount;
    }
}


// Finish drag and drop.
if (
    mouse_check_button_released(
        mb_left
    ) &&
    dragging
)
{
    if (
        hovered_slot != -1 &&
        !is_undefined(
            hovered_inventory
        )
    )
    {
        drag_source_inventory
            .move_slot_to(
                drag_source_slot,
                hovered_inventory,
                hovered_slot
            );

        selected_inventory =
            hovered_inventory;

        selected_slot =
            hovered_slot;
    }

    dragging = false;

    drag_source_inventory =
        undefined;

    drag_source_slot = -1;

    drag_item_id =
        ItemID.None;

    drag_amount = 0;
}