function inventory_ui_get_layout(_ui, _inventory, _side = 0, _include_tabs = true)
{
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _rows = ceil(_inventory.size / _ui.columns);
    var _grid_w = _ui.columns * _ui.slot_size + (_ui.columns - 1) * _ui.slot_padding;
    var _grid_h = _rows * _ui.slot_size + max(0, _rows - 1) * _ui.slot_padding;
    var _content_w = _grid_w + _ui.inner_padding * 2;
    var _panel_w = _content_w + (_include_tabs ? _ui.tab_width : 0);
    var _panel_h = _ui.title_height + _grid_h + _ui.section_gap + _ui.description_height + _ui.inner_padding * 2;
    _panel_h = min(_panel_h, _gh - _ui.screen_margin * 2);

    // _side 0 = right/player, _side 1 = left/foreign inventory.
    var _panel_x = (_side == 1)
        ? _ui.screen_margin
        : _gw - _panel_w - _ui.screen_margin;
    var _panel_y = max(_ui.screen_margin, (_gh - _panel_h) * 0.5);
    var _grid_x = _panel_x + _ui.inner_padding;
    var _grid_y = _panel_y + _ui.title_height;
    var _description_y = _grid_y + _grid_h + _ui.section_gap;

    return {
        panel_x : _panel_x, panel_y : _panel_y,
        panel_w : _panel_w, panel_h : _panel_h,
        content_w : _content_w,
        grid_x : _grid_x, grid_y : _grid_y,
        grid_w : _grid_w, grid_h : _grid_h,
        description_x : _panel_x + _ui.inner_padding,
        description_y : _description_y,
        description_w : _grid_w,
        description_h : _ui.description_height,
        tabs_x : _panel_x + _content_w,
        tabs_y : _panel_y
    };
}
