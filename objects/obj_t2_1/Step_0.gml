/// obj_narra_1 — Step Event

// If the tree grows this step, stop processing the old instance.
if (tree_growth_update(id))
{
    exit;
}

tree_harvest_update(id);