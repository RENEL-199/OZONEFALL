// Destroy the particle type.
if (part_type_exists(dust_type))
{
    part_type_destroy(dust_type);
}

// Destroy all remaining particles and the system.
if (part_system_exists(dust_system))
{
    part_system_destroy(dust_system);
}