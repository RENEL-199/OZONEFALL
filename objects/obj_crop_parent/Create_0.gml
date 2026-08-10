crop_id = -1;

growth_stage = 0;
maximum_growth_stage = 0;

stage_duration_minutes = 0;
watered_growth_minutes = 0;

last_growth_timestamp = 0;

is_mature = false;

planted_soil_id = noone;

image_speed = 0;


apply_placement_data = function(
    _placement_data
)
{
    if (
        !is_struct(_placement_data) ||
        !variable_struct_exists(
            _placement_data,
            "crop_id"
        )
    )
    {
        return false;
    }

    return crop_initialize(
        id,
        _placement_data.crop_id
    );
};