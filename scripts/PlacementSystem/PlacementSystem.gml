/// PlacementSystem.gml

function placement_begin(
    _item_id,
    _object,
    _sprite,
    _placement_data = undefined
)
{
    var _controller =
        instance_find(
            obj_placement_controller,
            0
        );

    if (!instance_exists(_controller))
    {
        show_debug_message(
            "Placement error: obj_placement_controller does not exist."
        );

        return false;
    }

    return _controller.begin_placement(
        _item_id,
        _object,
        _sprite,
        _placement_data
    );
}