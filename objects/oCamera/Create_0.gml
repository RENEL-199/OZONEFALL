cam = view_camera[0];

cam_width =
    camera_get_view_width(cam);

cam_height =
    camera_get_view_height(cam);

follow = noone;

if (instance_exists(obj_player)) {
    follow = instance_find(obj_player, 0);
}