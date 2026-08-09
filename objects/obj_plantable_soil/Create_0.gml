image_index = 0;
image_speed = 0;

is_plantable_soil = true;
is_fertile = true;

can_plant = true;
has_crop = false;
crop_instance = noone;

grid_size = 16;


// Keep soil close to the ground visually.
var _ground_layer =
    layer_get_id(
        "Ground_Details"
    );

placement_depth = 100;

if (_ground_layer != -1)
{
    placement_depth =
        layer_get_depth(
            _ground_layer
        );
}

depth = placement_depth;


// Check whether this soil can receive a seed.
can_accept_seed = function()
{
    if (
        has_crop &&
        !instance_exists(crop_instance)
    )
    {
        has_crop = false;
        crop_instance = noone;
    }

    return
        is_fertile &&
        can_plant &&
        !has_crop;
};


// Reserve the soil for a planted crop.
assign_crop = function(_crop)
{
    if (
        !instance_exists(_crop) ||
        !can_accept_seed()
    )
    {
        return false;
    }

    has_crop = true;
    crop_instance = _crop;

    return true;
};


// Called when the crop is harvested or destroyed.
clear_crop = function()
{
    has_crop = false;
    crop_instance = noone;

    return true;
};