///scr_ledge_grab_state()
var jkey = keyboard_check_pressed(vk_up);
var dkey = keyboard_check(vk_down);

if(jkey){
    vspd = -jspd;
    state = scr_move_state;
}

if(dkey){
    state = scr_move_state;
}
