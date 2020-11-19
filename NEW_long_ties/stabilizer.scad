
$fn=100;
include <globals.scad>;
include <include.scad>;
use <long_bow_tie.scad>;
use <long_tie.scad>;
use <extention.scad>;
use <corner.scad>;
use <bed_carriage.scad>;
use <mockups.scad>;

function even(x) = x%2;

// de facto settings
//rail_d = 37;
//rail_offset = 30;

// for Dollo rework
rail_d = 43;
rail_offset = 35;

module center() {

    module _arm() {
        hull() {
            translate([50,50,0]) cylinder(d=clip_bolt_dia_minus+10,h=10,$fn=40);
            cylinder(d=40,h=10);
            translate([-50,-50,0]) cylinder(d=clip_bolt_dia_minus+10,h=10,$fn=40);
        }
    }
    
    difference() {
        union() {
            _arm();
            rotate([0,0,90]) _arm();
            difference() {
                translate([0,0,10/2]) cube([80,80,10],center=true);
                for (i = [0:3]) {
                    rotate([0,0,360/4*i]) translate([70,0,0]) cylinder(d=70,h=21,center=true);
                }
            }
        }
        for (i = [0:3]) {
            rotate([0,0,360/4*i]) translate([50,50,0]) cylinder(d=clip_bolt_dia_minus,h=21,center=true);
            rotate([0,0,360/4*i]) translate([20,0,0]) cylinder(d=15,h=21,center=true);

            // hidden infill
            rotate([0,0,360/4*i+45]) {
                translate([0,65/2,2/2+0.5+even(i)*0.5]) cube([0.1,65,2],center=true);
                translate([0,65/2,2/2+3.5+even(i)*0.5]) cube([0.1,65,2],center=true);
                translate([0,65/2,2/2+6.5+even(i)*0.5]) cube([0.1,65,2],center=true);
            }
        }
    }
}

module center_z_side() {

    w = (rail_d + rail_offset) * 2;
    corner_pos = rail_d + rail_offset - (clip_bolt_dia_minus+10)/2;
    h = 27;
    
    %translate([rail_offset,0,h+15]) rotate([90,0,0]) cylinder(d=rail_d,h=100,center=true);
    %translate([-rail_offset,0,h+15]) rotate([90,0,0]) cylinder(d=rail_d,h=100,center=true);

    difference() {
        translate([0,0,h/2]) union() {
            for (i = [0:3]) {
                rotate([0,0,360/4*i]) translate([corner_pos,corner_pos,0]) cylinder(d=clip_bolt_dia_minus+10,h=h,center=true);
            }
            cube([w-6,w-6,h],center=true);
        }
        translate([0,0,70/2+12]) chamfered_cube(w-9,260,70,30,center=true);
        for (i = [0:3]) {
            rotate([0,0,360/4*i]) {
                translate([corner_pos,corner_pos,-0.1]) {
                    cylinder(d=clip_bolt_dia_minus,h=h*3,center=true);
                    hull() {
                        cylinder(d1=39,d2=20,h=h-9.9);
                        cube([80,80,h-9.9]);
                    }
                }
                translate([0,corner_pos+20,0]) hull() {
                    cylinder(d=corner_pos+20,h=h*3,center=true);
                    translate([-(2*corner_pos)/2,-7]) cube([(2*corner_pos),1,h*2]);
                }
                translate([20,0,0]) cylinder(d=15,h=h*2);
            }
            // hidden infill
            rotate([0,0,360/4*i+45]) {
                translate([0,65/2,2/2+0.5+even(i)*0.5]) cube([0.1,w,1.5],center=true);
                translate([0,65/2,2/2+3+even(i)*0.5]) cube([0.1,w,1.5],center=true);
                translate([0,65/2,2/2+5.5+even(i)*0.5]) cube([0.1,w,1.5],center=true);
                translate([0,65/2,2/2+8+even(i)*0.5]) cube([0.1,w,1.5],center=true);
                translate([5,corner_pos-5,0]) rotate([-45,0,0]) cube([0.1,1,100],center=true);
                translate([0,corner_pos-5,0]) rotate([-45,0,0]) cube([0.1,1,100],center=true);
                translate([-5,corner_pos-5,0]) rotate([-45,0,0]) cube([0.1,1,100],center=true);
            }
        }

    }
}

module clip_bolt(length) {
    _bolt(d=clip_bolt_dia, h=length, diameter=1, shaft=length-10);
}

module clip_nut() {
    _nut(d=clip_bolt_dia, d2=16, h=6, indents=23);
}

module pin_nut() {
    _nut(d=pin_bolt_dia, d2=18, h=7, z_step=3, depth=1, indents=24);
}

module pin_bolt(length) {
    l = length + 0.02;
    difference() {
        union() {
            translate([0,-0.01,0]) _bolt_shaft(d=pin_bolt_dia, h=20, shaft=l/2-20, z_step=3, depth=1);
            rotate([0,0,180]) translate([0,-0.01,0]) _bolt_shaft(d=pin_bolt_dia, h=20, shaft=l/2-20, z_step=3, depth=1);
        }
        translate([1.5,0,-1.5]) rotate([-90,0,0]) cylinder(d=0.1,h=l, center=true);
        translate([0,0,1.5]) rotate([-90,0,0]) cylinder(d=0.1,h=l, center=true);
        translate([-1.5,0,-1.5]) rotate([-90,0,0]) cylinder(d=0.1,h=l, center=true);
    }
}

module corner_bolt(direction) {
    union() {
        _hook();
        length = 40;
        if (FAST) {
            translate([0,-9.9,0]) rotate([90,0,0]) cylinder(d=pin_bolt_dia, h=length);
        } else {
            translate([0,-9.9]) rotate([0,0,180]) difference() {
                _bolt_shaft(d=pin_bolt_dia, h=length, shaft=5, z_step=3, depth=1, direction=direction);
                
                // hidden infill
                translate([1.5,0,-1.5]) rotate([-90,0,0]) cylinder(d=0.1,h=length*2);
                translate([0,0,1.5]) rotate([-90,0,0]) cylinder(d=0.1,h=length*2);
                translate([-1.5,0,-1.5]) rotate([-90,0,0]) cylinder(d=0.1,h=length*2);
            }
        }
    }
}

module _hook(gap=10) {
    height = 10 + gap;
    hole_pos = 7;
    difference() {
        union() {
            difference() {
                hull() {
                    chamfered_cube(18,18,height,2,center=true);
                    translate([0,hole_pos,-height/2]) chamfered_cylinder(18,height,2);
                    translate([0,-12,0]) chamfered_cube(8,5,10,2,center=true);
                }
                translate([0,hole_pos,0]) cube([30,20,gap+2*slop],center=true);
                translate([0,hole_pos,0]) rotate([0,0,36]) cube([40,10,gap+2*slop],center=true);
                translate([0,hole_pos,0]) rotate([0,0,-36]) cube([40,10,gap+2*slop],center=true);
                translate([0,hole_pos,-height/2]) cylinder(d=clip_bolt_dia_minus,h=55,center=true);
            }
        }
        // extra infill
        translate([1.5,0,-1.5]) rotate([-90,0,0]) cylinder(d=0.1,h=40,center=true);
        translate([0,0,1.5]) rotate([-90,0,0]) cylinder(d=0.1,h=40,center=true);
        translate([-1.5,0,-1.5]) rotate([-90,0,0]) cylinder(d=0.1,h=40,center=true);
        
        translate([0,-6,0]) cylinder(d=0.1,h=40,center=true);
        translate([4,-6,0]) cylinder(d=0.1,h=40,center=true);
        translate([-4,-6,0]) cylinder(d=0.1,h=40,center=true);
    }
}

module beam(length, gap=10) {
    height = 10 + gap;
    difference() {
        union() {
            translate([0,length/2-7,0]) _hook(gap=gap);
            chamfered_cube(8,length-24,height,2,center=true);
            mirror([0,1,0]) translate([0,length/2-7,0]) _hook(gap=gap);
        }
        // hidden infill
        translate([0,0,3/2-9]) cube([0.1,length-22,3],center=true);
        translate([0,0,3/2-4]) cube([0.1,length-22,3],center=true);
        translate([0,0,3/2+1]) cube([0.1,length-22,3],center=true);
        translate([0,0,3/2+6]) cube([0.1,length-22,3],center=true);
    }
}

module frame_clip() {
    side = 45;
    module side() {
        intersection() {
            union() {
                difference() {
                    cube([19.5,50,side]);
                    translate([3,-1,-1]) cube([20,60,side+2]);
                }
                translate([8,50,0]) rotate([-90,0,90]) difference() {
                    translate([0,-side/2]) long_bow_tie(side);
                    translate([0,-side-1,-1]) cube([20,side+2,12]);
                }
            }
            cube([100,100,100]);
        }
    }
    
    rotate([0,-90,0]) difference() {
        union() {
            translate([0,sqrt(30*30/2),0]) rotate([45,0,0]) side();
            translate([0,sqrt(7*7),0]) rotate([-45,0,0]) mirror([0,1,0]) side();
        }
        difference() {
            translate([-1,-15,0]) cube([50,60,19]);
            translate([0,sqrt(30*30/2)-sqrt(7*7),22.6]) rotate([0,90,0]) cylinder(d=clip_bolt_dia_minus+10,h=3);
        }
        translate([-1,sqrt(30*30/2)-sqrt(7*7),22.6]) rotate([0,90,0]) cylinder(d=clip_bolt_dia_minus,h=25);
        
        translate([0,sqrt(30*30/2)-sqrt(7*7),65]) rotate([45,0,0]) cube([25,20,20], center=true);
    }
    
    %translate([-4.9,87,30/2+3])
    rotate([90,0,-45])
    extention(support=false);
}

module frame_clip_middle() {

    difference() {
        union() {
            intersection() {
                rotate([0,0,45]) rounded_cube(60,60,10,5,center=true);
                translate([-40,0,0]) cube([80,80,2.5]);
            }
            translate([40,0,-2.35]) rotate([0,0,-90]) difference() {
                translate([0,-80/2]) long_bow_tie(80);
                translate([0,-90,-1]) cube([10,90,20]);
                translate([-5,-90,-20+2.5+2.35]) cube([10,90,20]);
            }
        }
        translate([0,30,0]) cylinder(d=clip_bolt_dia_minus,h=25);
    }
}

module frame_clip_middle_2x() {
    union() {
        frame_clip_middle();
        translate([35,0,0]) frame_clip_middle();
    }
}

fc_width = 44+2*slop;
fc_length = 50;
fc_temp = 50/2 + 29/2;
fc_height = (sqrt(fc_temp*fc_temp/2));

module frame_clip_corner_large() {
    module part() {
        
        difference() {
            cube([fc_width,fc_length,29], center=true);
            translate([0,-1,8]) cube([30+2*slop,fc_length+5,29], center=true);
            
            translate([0,-fc_length/2-1,-29/2+8]) rotate([-90,0,0]) male_dovetail(fc_length+5);
            translate([-fc_width/2+7,-fc_length/2-1,-29/2+23+slop]) rotate([-90,90,0]) male_dovetail(fc_length+5);
            translate([fc_width/2-7,-fc_length/2-1,-29/2+23+slop]) rotate([-90,-90,0]) male_dovetail(fc_length+5);
            translate([0,fc_length/2,-29/2-1]) rotate([0,0,180]) male_dovetail(20);
        }
    }

    %translate([0,0,12])
    rotate([-45,0,0])
    extention(support=false);
    
    difference() {
        union() {
            rotate([45,0,0]) part();
            translate([0,fc_height*2-sqrt(8*8*2),0]) mirror([0,1,0]) rotate([45,0,0]) part();
            translate([0, fc_height-(sqrt(8*8/2)), -fc_height-5]) rotate([45,0,0]) cube([10,fc_length,fc_length],center=true);
        }
        translate([-1,fc_height,-49-sqrt(14.5*14.5*2)-sqrt(10.5*10.5/2)-0.5]) cube([60,100,100],center=true);
        translate([-10,fc_height-sqrt(8*8/2),10-sqrt(14.5*14.5*2)-sqrt(10.5*10.5/2)]) rotate([0,90,0]) cylinder(d=clip_bolt_dia_minus,h=25);
    }
}

module frame_clip_corner_small() {
    
    rotate([-90,45,0]) difference() {
        chamfered_cube_side(60,60,15.8,5,center=true);
        translate([0,0,5+10/2]) chamfered_cube(60-18,60-18,10, 3, center=true);
        translate([0,0,-5-10/2]) chamfered_cube(60-18,60-18,10, 3, center=true);

        union() {
            rotate([0,0,45]) translate([100/2,0,0]) cube([100,100,25],center=true);
            intersection() {
                difference() {
                    translate([-6,-6]) cylinder(d=38,h=25, center=true);
                    translate([-6,-6]) cylinder(d=20,h=25, center=true);
                }
                cube([22,22,20],center=true);
            }
        }
        translate([-60/2,-60/2,0]) rotate([0,0,45]) cube([15,30,25],center=true);
        
        translate([-30.01,-40,0]) rotate([-90,-90,0]) male_dovetail();
        translate([50,-30.01,0]) rotate([-90,-90,90]) male_dovetail();
        
        translate([-6,-6]) cylinder(d=10+slop,h=25, center=true);
    }
}

module long_nut() {
    side = 16;
    length = 80;
    difference() {
        rounded_cube(side,length,side,4,center=true);
        if (FAST) {
            translate([0,-length/2-.5,0]) rotate([-90,0,0]) cylinder(d=pin_bolt_dia_minus, h=length/2);
            translate([0,0.5,0]) rotate([-90,0,0]) cylinder(d=pin_bolt_dia_minus, h=length/2);
        } else {
            translate([0,-length/2-.5,0]) rotate([-90,0,0]) _threads(d=pin_bolt_dia_minus, h=length/2, z_step=3, depth=1);
            translate([0,0.5,0]) rotate([-90,0,0]) _threads(d=pin_bolt_dia_minus, h=length/2, z_step=3, depth=1,direction=1);
        }
        translate([-5/2,-length/2-1,+1]) cube([5,length+5,6]);
    }
}

module frame_center_clip() {
    difference() {
        intersection() {
            translate([0,0,5/2]) rotate([0,0,45]) cube([41,41,5], center=true);
            translate([-25,0,0]) cube([50,24,10]);
        }
        translate([0,clip_bolt_dia_minus/2+7]) cylinder(d=clip_bolt_dia_minus, h=5);
    }
    translate([0,-0.2,0]) rotate([0,0,90]) long_bow_tie_half(50);
}

module frame_angle_clamp() {
    
    difference() {
        union() {
            translate([0,-7,0]) chamfered_cube(46,32,30,3,center=true);
            translate([0,-24,0]) intersection() {
                translate([0,0,-10]) rotate([45,00,0]) chamfered_cube_side(35,42,35,3,center=true);
                cube([40,50,30],center=true);
            }
        }
        cube([30,30,60],center=true);
        translate([0,-15,-30]) rotate([0,0,180]) male_dovetail();
        translate([-15,0,-30]) rotate([0,0,90]) male_dovetail();
        translate([15,0,-30]) rotate([0,0,-90]) male_dovetail();
        
        translate([0,-23/2-15-8,-30/2-1/2]) hull() {
            cube([25,23,1], center=true);
            translate([0,23/2-1/2,23]) cube([25,1,1],center=true);
        }
        translate([0,-37,-5]) rotate([45,0,0]) hull() {
            cylinder(d=pin_bolt_dia_minus,h=10,center=true,$fn=30);
            translate([0,-20,0]) cylinder(d=pin_bolt_dia_minus,h=10,center=true,$fn=30);
        }
    }
}

module frame_angle_clamp_slim() {
    difference() {
        union() {
            intersection() {
                frame_angle_clamp();
                translate([0,-25]) cube([35,50,100],center=true);
            }
            translate([15,-6,-30/2]) cube([2.5,6,30]);
            translate([-15-2.5,-6,-30/2]) cube([2.5,6,30]);
            
            translate([15.01,0,0]) rotate([90,0,0]) long_tie_half(30);
            translate([-15.01,0,0]) rotate([-90,0,180]) long_tie_half(30);
        }
        cube([27,10,80],center=true);
    }
}

module frame_clip_spacer() {
    difference() {
        cylinder(d=clip_bolt_dia_minus+3,h=7,$fn=30);
        cylinder(d=clip_bolt_dia_minus,h=7,$fn=30);
    }
}

module _bolt_nut(l=120) {
    corner_bolt();
    translate([0,-l/2,0]) long_nut();
    translate([0,-l,0]) mirror([0,1,0]) corner_bolt();
}


module view_proper_3_3_4() {
    frame_mockup(0, 3, 3, 4);

    //translate([165,-170,15]) rotate([0,-55,-45]) full_corner(support=false, extra_stiff=false);
    
    
    translate([180+60-20,0,(4*120+120)/2+4.5]) rotate([0,90,0]) center();
    translate([0,-240-27,(4*120+120)/2+31]) rotate([-90,0,0]) center_z_side();
    
    translate([225,-180,60]) rotate([0,-135,90]) frame_clip_corner_small();
    translate([225,180,60]) rotate([0,135,90]) frame_clip_corner_small();
    translate([225,180,4*120+60]) rotate([0,45,90]) frame_clip_corner_small();
    translate([225,-180,4*120+60]) rotate([0,-45,90]) frame_clip_corner_small();

    translate([-160,-243,4*120+60]) rotate([-90,45,0]) frame_clip();
    translate([-180,-243,80]) rotate([-90,-45,0]) frame_clip();
    
    beam_l = 242;
    angle = 55.8;
    translate([225,-186,54]) rotate([angle,0,0]) translate([0,beam_l/2,0]) rotate([0,90,0]) beam(beam_l);
    translate([225,186,54]) rotate([180-angle,0,0]) translate([0,beam_l/2,0]) rotate([0,90,0]) beam(beam_l);
    
    translate([225,186,4*120+66]) rotate([angle-2,0,0]) translate([0,-7,0]) rotate([0,90,0]) _bolt_nut(197.5);
    
    //translate([120+60-32.5,-100,60]) rotate([90,-45,90]) frame_clip_slim();
    
    //%translate([120+60-25,-125,83]) rotate([angle+180,0,0]) hook();
    //translate([120+60-15,-105,93]) rotate([angle,0,0]) long_bolt();
    //translate([120+60-15,-58,185]) rotate([angle,0,0]) long_bolt();
    
    //translate([0,-165,24]) rotate([-90,0,-90]) bed_rail_frame_mount();
//    translate([120,-165,3*120+60]) rotate([0,45,0]) frame_clip_corner_small();
//    translate([61.5,-165,42]) rotate([80.5,0,-90]) translate([0,250/2,0]) rotate([0,90,0]) beam(250, gap=14);
//    
//    translate([124.6,-165,3*120+59.7]) rotate([0,-80.5,0]) translate([0,-7,0]) rotate([0,90,-90]) corner_bolt();
//    translate([113,-175,350]) rotate([-80.5,0,90]) long_nut();
    
    translate([0,-196,(4*120+120)/2-2]) rotate([180,0,-90]) bed_screw_housing(render_threads=false);
    
    translate([0,-233,(4*120+120)/2-2]) rotate([180,0,0]) endstop_screw_mount();
    
    beam_l_z = 240;
    translate([-186,-245,4*120+66]) rotate([0,51.2,0]) translate([7,0,0]) rotate([0,90,90]) _bolt_nut(174);
    translate([-186,-245,54]) rotate([0,-60.5,0]) translate([beam_l_z/2,0,0]) rotate([0,90,90]) beam(beam_l_z);
}

module view_proper_2_2_3() {
    
    frame_mockup(0, 2, 2, 3);

    //translate([165,-170,15]) rotate([0,-55,-45]) full_corner(support=false, extra_stiff=false);
    
    angle = 62;
    translate([120+60-20,0,(3*120+120)/2+4.5]) rotate([0,90,0]) center();
    translate([0,-180-31,(3*120+120)/2-2]) rotate([-90,0,0]) center_z_side();
    
    translate([165,-120,60]) rotate([0,-135,90]) frame_clip_corner_small();
    translate([165,120,60]) rotate([0,135,90]) frame_clip_corner_small();
    translate([165,120,3*120+60]) rotate([0,45,90]) frame_clip_corner_small();
    translate([165,-120,3*120+60]) rotate([0,-45,90]) frame_clip_corner_small();

    translate([-100,-183,3*120+60]) rotate([-90,45,0]) frame_clip();
    translate([-120,-183,80]) rotate([-90,-45,0]) frame_clip();
    
    beam_l = 160;
    translate([165,-126,54]) rotate([angle,0,0]) translate([0,beam_l/2,0]) rotate([0,90,0]) beam(beam_l);
    translate([165,126,54]) rotate([180-angle,0,0]) translate([0,beam_l/2,0]) rotate([0,90,0]) beam(beam_l);
    
    translate([165,126,3*120+66]) rotate([angle-2,0,0]) translate([0,-7,0]) rotate([0,90,0]) _bolt_nut(137.5);
    
    
    //translate([120+60-32.5,-100,60]) rotate([90,-45,90]) frame_clip_slim();
    
    //%translate([120+60-25,-125,83]) rotate([angle+180,0,0]) hook();
    //translate([120+60-15,-105,93]) rotate([angle,0,0]) long_bolt();
    //translate([120+60-15,-58,185]) rotate([angle,0,0]) long_bolt();
    
    //translate([0,-165,24]) rotate([-90,0,-90]) bed_rail_frame_mount();
//    translate([120,-165,3*120+60]) rotate([0,45,0]) frame_clip_corner_small();
//    translate([61.5,-165,42]) rotate([80.5,0,-90]) translate([0,250/2,0]) rotate([0,90,0]) beam(250, gap=14);
//    
//    translate([124.6,-165,3*120+59.7]) rotate([0,-80.5,0]) translate([0,-7,0]) rotate([0,90,-90]) corner_bolt();
//    translate([113,-175,350]) rotate([-80.5,0,90]) long_nut();

    beam_l_z = 140;
    translate([-123,-165,3*120+59.7]) rotate([0,-117.5,0]) translate([0,-20,0]) rotate([0,90,-90]) _bolt_nut(129);
    translate([-93,-265,116.5]) rotate([0,180-angle,0]) translate([0,beam_l_z/2,0]) rotate([0,90,90]) beam(beam_l_z);
}

module debug_center() {
    intersection() {
        center();
        rotate([0,0,45]) translate([0,-200,0]) cube([400,400,100]);
    }
}

module debug_center_z_side() {
    intersection() {
        center_z_side();
        rotate([0,0,45]) translate([0,0,0]) cube([400,400,100]);
    }
}

//debug_center();
//debug_center_z_side();

FAST=true;
//FAST=false;

//view_proper_2_2_3();
//view_proper_3_3_4();

//frame_clip();
frame_clip_corner_large();
//frame_clip_corner_small();
//frame_clip_middle();
//frame_clip_middle_2x();
//frame_center_clip();

//frame_clip_spacer();

//frame_angle_clamp();
//frame_angle_clamp_slim();

//clip_bolt(30);
//clip_nut();

//pin_bolt(50);
//pin_bolt(140);
//pin_nut();

// right hand thread
//corner_bolt(0);
// left hand thread
//corner_bolt(1);

//long_nut();

//beam(160);
//beam(140);
//rotate([0,0,45]) beam(210);
//beam(242);
//rotate([0,0,45]) beam(242);

//center();
//center_z_side();
