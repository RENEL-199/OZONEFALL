/// obj_input_controller — Begin Step Event

if (
    !variable_global_exists(
        "player_input"
    )
)
{
    global.player_input =
        new PlayerInputSystem();
}

if (
    keyboard_check_pressed(
        vk_f10
    )
)
{
    global.player_input
        .force_mobile_controls =
        !global.player_input
        .force_mobile_controls;
}

global.player_input.update();