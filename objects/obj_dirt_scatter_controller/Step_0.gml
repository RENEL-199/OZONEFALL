refresh_timer--;

if (refresh_timer <= 0)
{
    refresh_timer =
        refresh_interval_steps;

    refresh_scatter_cache();
}