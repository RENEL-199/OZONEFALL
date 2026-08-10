event_inherited();

if (
    !crop_initialize(
        id,
        FarmCropID.Pumpkin
    )
)
{
    show_debug_message(
        "Failed to initialize Kamote crop."
    );
}

image_index = 0;
image_speed = 0;