if (image_alpha < target_alpha)
{
    image_alpha = min(image_alpha + fade_speed, target_alpha);
}
else if (image_alpha > target_alpha)
{
    image_alpha = max(image_alpha - fade_speed, target_alpha);
}