/// CraftingUILayout.gml

function crafting_ui_get_layout(
    _ui,
    _table
)
{
    var _gui_width =
        display_get_gui_width();

    var _gui_height =
        display_get_gui_height();

    var _margin =
        _table.craft_ui_margin;

    var _right_limit =
        _gui_width - _margin;

    if (
        variable_global_exists(
            "player_inventory"
        )
    )
    {
        var _player_layout =
            inventory_ui_get_layout(
                _ui,
                global.player_inventory,
                0,
                true
            );

        _right_limit =
            _player_layout.panel_x -
            _table.craft_ui_panel_gap;
    }

    var _available_width =
        max(
            320,
            _right_limit - _margin
        );

    var _panel_width =
        min(
            _table.craft_ui_width,
            _available_width
        );

    var _panel_height =
        min(
            _table.craft_ui_height,
            _gui_height - _margin * 2
        );

    var _panel_x = _margin;

    var _panel_y =
        max(
            _margin,
            (_gui_height - _panel_height) * 0.5
        );

    var _padding =
        _table.craft_ui_padding;

    var _footer_y =
        _panel_y +
        _panel_height -
        _padding -
        _table.material_slot_size;

    var _content_top =
        _panel_y +
        _padding +
        _table.craft_ui_header_height;

    var _content_bottom =
        _footer_y - 28;

    var _divider_x =
        _panel_x +
        floor(
            _panel_width *
            _table.craft_ui_list_ratio
        );

    var _list_x =
        _panel_x + _padding;

    var _list_y =
        _content_top;

    var _list_width =
        max(
            120,
            _divider_x -
            _list_x -
            _padding
        );

    var _list_height =
        max(
            _table.recipe_row_height,
            _content_bottom -
            _list_y
        );

    var _detail_x =
        _divider_x + _padding;

    var _detail_y =
        _content_top;

    var _detail_width =
        max(
            160,
            _panel_x +
            _panel_width -
            _padding -
            _detail_x
        );

    var _detail_height =
        max(
            120,
            _content_bottom -
            _detail_y
        );

    var _craft_x =
        _panel_x +
        _panel_width -
        _padding -
        _table.craft_button_width;

    var _craft_y =
        _footer_y +
        (
            _table.material_slot_size -
            _table.craft_button_height
        ) * 0.5;

    var _progress_y =
        _content_bottom -
        _table.progress_bar_height -
        8;

    return
    {
        panel_x: _panel_x,
        panel_y: _panel_y,
        panel_w: _panel_width,
        panel_h: _panel_height,

        divider_x: _divider_x,

        list_x: _list_x,
        list_y: _list_y,
        list_w: _list_width,
        list_h: _list_height,

        detail_x: _detail_x,
        detail_y: _detail_y,
        detail_w: _detail_width,
        detail_h: _detail_height,

        material_x:
            _panel_x + _padding,

        material_y:
            _footer_y,

        material_slot_size:
            _table.material_slot_size,

        material_gap:
            _table.material_gap,

        craft_x: _craft_x,
        craft_y: _craft_y,

        craft_w:
            _table.craft_button_width,

        craft_h:
            _table.craft_button_height,

        progress_x:
            _detail_x,

        progress_y:
            _progress_y,

        progress_w:
            _detail_width,

        progress_h:
            _table.progress_bar_height
    };
}