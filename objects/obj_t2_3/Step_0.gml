/// obj_narra_3 — Step Event

// ====================================================================
// REGISTER RESTORATION SOURCE
// ====================================================================

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


// ====================================================================
// HARVESTING
// ====================================================================

tree_harvest_update(id);