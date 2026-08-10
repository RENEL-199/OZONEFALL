if (
    instance_exists(
        planted_soil_id
    ) &&
    planted_soil_id.crop_instance ==
    id
)
{
    planted_soil_id.clear_crop();
}