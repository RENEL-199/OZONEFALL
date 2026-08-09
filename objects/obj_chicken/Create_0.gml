// Movement variables
dir        = irandom(3);          // direction: 0=up,1=down,2=left,3=right
move_timer = irandom_range(60, 120); 
speed_walk =0.5;

// Current speed (smooth)
xspd = 0;
yspd = 0;

depth = -y