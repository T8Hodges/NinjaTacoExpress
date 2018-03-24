///Script Move State
// platform physics

var rkey = keyboard_check(vk_right);
var lkey = keyboard_check(vk_left);
var jkey = keyboard_check_pressed(vk_up);
var jkey2 = keyboard_check(vk_up);
var ckey = keyboard_check(vk_down);

//check for ground
if (place_meeting(x, y+1, obj_solid)) 
{
    vspd = 0;
    dblj = true;
    //jumping
    if (jkey)
    {
        vspd = -jspd;
    }
}
else
{
    //wall slide
    if (place_meeting(x+1, y, obj_solid)) || (place_meeting(x-1, y, obj_solid))
    {
        if (!ckey)
        {
            if (vspd < 5)
            {
            vspd += grav;
            }
            else
            {
                vspd -= grav;
            }
        }
        else
        {
            if (vspd < 50)
            {
                vspd += (grav * 10);
                smash = true;
            }
            //quick wall slide
            //if (vspd < 25)
            //{
            //vspd += (grav * 5);
            //}
            //else
            //{
                //vspd -= (grav * 5);
            //}
        }
        //wall jump
        if (place_meeting(x+1, y, obj_solid)) && (!place_meeting(x, y+1, obj_solid))
        {
            if (jkey)
            {
                vspd = -jspd;
                hspd += -(spd * 3);           
            }
        }
        else
        {
            if (place_meeting(x-1, y, obj_solid)) && (!place_meeting(x, y+1, obj_solid))
            {
                if (jkey)
                {
                    vspd = -jspd;
                    hspd += (spd * 3);
                }
            }
        }
    }
    else
    {
        //double jump
        if (dblj = true)
        {
            if (jkey)
            {
                if (vspd > 0)
                {
                    vspd = 0;
                }
                vspd = -jspd;
                dblj = false;
            }
        }
        //gravity
        if (!ckey)
        {
            if (vspd < 20)
            {
                vspd += grav;
            }
            else
            {
                vspd -= (grav * 5);
            }
        }
        else
        {
            //quickfall
            if (vspd < 50)
            {
                vspd += (grav * 10);
                smash = true;
            }
        }
    }
}

//jump height modifier
//if (vspd < 0) && (!jkey2) {vspd = max(vspd, -(jspd / 2))}

//Collisions start

//movement
//right
if (rkey)
{
    if (place_meeting(x, y+1, obj_solid))
    {
        hspd = spd;
    }
    else
    {
        if (hspd < spd)
        {
            hspd += spd;
        }
    }
}
if (hspd > spd)
{
    hspd -= (spd/4);
}
//left
if (lkey)
{
    if (place_meeting(x, y+1, obj_solid))
    {
        hspd = -spd;
    }
    else
    {
        if (hspd > -spd)
        {
            hspd += -spd;
        }
    }
}
if (hspd < -spd)
{
    hspd -= -(spd/4);
}
//check for not moving
if ((rkey && lkey) or (!rkey && !lkey))
{
    if (vspd = 0)
    {
        hspd = 0;
    }
    else
    {
        if (hspd > 0)
        {
            hspd += -(spd/4);
        }
        if (hspd < 0)
        {
            hspd += (spd/4);
        }
    }   
}

if(hspd != 0){
    hspd_dir = sign(hspd);
}

//horizontal collisions
if (place_meeting(x+hspd, y, obj_solid))
{
    while (!place_meeting(x+sign(hspd), y, obj_solid))
    {
        x += sign(hspd);
    }
    hspd = 0;
}
//horizontal movement
x += hspd;

//vertical collisions
if (place_meeting(x, y+vspd, obj_solid))
{
    while (!place_meeting(x, y+sign(vspd), obj_solid))
    {
        y += sign(vspd);
    }
    vspd = 0;
}
//vertical movement
y += vspd;
//X MUST COME BEFORE Y
//Collisions end
var right_was_free = !position_meeting(x+(25*hspd_dir), yprevious-4, obj_solid);
var right_is_not_free = position_meeting(x+(25*hspd_dir), y-4, obj_solid);
var moving_down = yprevious < y;

if(right_was_free && right_is_not_free && moving_down) {
    hspd = 0;
    vspd = 0;
    
    // Move against the ledge
    while(!place_meeting(x+hspd_dir, y, obj_solid)){
        x+=hspd_dir;
    }
    
    // Make sure we are the right height
    while(position_meeting(x+(25*hspd_dir), y-14, obj_solid)){
        y-=1;
    }
    
    state = scr_ledge_grab_state;
}
