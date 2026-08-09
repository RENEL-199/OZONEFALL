if (!restoration_registered)
{
    var _restoration_controller =
        instance_find(
            obj_restoration_controller,
            0
        );

    if (
        instance_exists(
            _restoration_controller
        )
    )
    {
        _restoration_controller
        .register_tree(id);
    }
}

tree_harvest_update(id);