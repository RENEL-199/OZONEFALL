/// obj_crafting_table — Cleanup Event

if (
    variable_instance_exists(
        id,
        "release_crafting_lock"
    )
)
{
    release_crafting_lock();
}