
$fn=100;
include <globals.scad>;
include <include.scad>;
use <long_bow_tie.scad>;
use <extention.scad>;
use <corner.scad>;

pin_bolt_dia = 12-2*slop;
pin_bolt_dia_minus = 12+2*slop;

clip_bolt_dia = 10-2*slop;
clip_bolt_dia_minus = 10+2*slop;

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
            rotate([0,0,360/4*i]) translate([50,50,0]) cylinder(d=clip_bolt_dia_minus,h=20);
            rotate([0,0,360/4*i]) translate([20,0,0]) cylinder(d=15,h=20);

            // hidden infill
            rotate([0,0,360/4*i+45]) {
                translate([0,65/2,2/2-4]) cube([0.1,65,2],center=true);
                translate([0,65/2,2/2-1]) cube([0.1,65,2],center=true);
                translate([0,65/2,2/2+2]) cube([0.1,65,2],center=true);
            }
        }

    }
}

module clip_bolt() {
    _bolt(d=clip_bolt_dia, h=40, h2=20, diameter=1, shaft=30);
}

module clip_nut() {
    _nut(d=clip_bolt_dia, d2=18, h=6, indents=23);
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
                translate([1.5,0,-1.5]) rotate([-90,0,0]) cylinder(d=0.1,h=length*2);
                translate([0,0,1.5]) rotate([-90,0,0]) cylinder(d=0.1,h=length*2);
                translate([-1.5,0,-1.5]) rotate([-90,0,0]) cylinder(d=0.1,h=length*2);
            }
        }
    }
}

module _hook(direction=0) {
    height = 20;
    hole_pos = 7;
    difference() {
        union() {
            difference() {
                hull() {
                    chamfered_cube(20,18,20,2,center=true);
                    translate([0,hole_pos,-20/2]) chamfered_cylinder(20,20,2);
                    translate([0,-12,0]) chamfered_cube(8,5,10,2,center=true);;
                }
                translate([0,hole_pos,0]) cube([30,20,10+2*slop],center=true);
                translate([0,hole_pos,-height/2]) cylinder(d=clip_bolt_dia_minus,h=25);
            }
        }
        translate([1.5,0,-1.5]) rotate([-90,0,0]) cylinder(d=0.1,h=40,center=true);
        translate([0,0,1.5]) rotate([-90,0,0]) cylinder(d=0.1,h=40,center=true);
        translate([-1.5,0,-1.5]) rotate([-90,0,0]) cylinder(d=0.1,h=40,center=true);
    }
}

module beam(length) {
    difference() {
        union() {
            translate([0,length/2-7,0]) _hook();
            chamfered_cube(8,length-24,20,2,center=true);
            mirror([0,1,0]) translate([0,length/2-7,0]) _hook();
        }
        // hidden infill
        translate([0,0,3/2-9]) cube([0.1,length-25,3],center=true);
        translate([0,0,3/2-4]) cube([0.1,length-25,3],center=true);
        translate([0,0,3/2+1]) cube([0.1,length-25,3],center=true);
        translate([0,0,3/2+6]) cube([0.1,length-25,3],center=true);
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
                    long_bow_tie(side);
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
        translate([-1,-15,0]) cube([50,60,17]);
        translate([-1,sqrt(30*30/2)-sqrt(7*7),26]) rotate([0,90,0]) cylinder(d=clip_bolt_dia_minus,h=25);
        
        translate([0,sqrt(30*30/2)-sqrt(7*7),65]) rotate([45,0,0]) cube([25,20,20], center=true);
    }
    
    //translate([5,65,0]) % rotate([90,0,0]) extention();
}

module frame_clip_middle() {

    difference() {
        union() {
            intersection() {
                rotate([0,0,45]) rounded_cube(60,60,10,5,center=true);
                translate([-40,0,0]) cube([80,80,2.5]);
            }
            translate([40,0,-2.35]) rotate([0,0,-90]) difference() {
                long_bow_tie(80);
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
    //translate([7,0,7]) %extention();
    
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

module frame_clip_corner_large2() {
    
    difference() {
        frame_clip_corner_large();
        translate([20,fc_height*2-sqrt(98),0]) mirror([0,1,0]) rotate([45,0,0]) cube([10,100,30], center=true);
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

module frame_clip_corner_small2() {
    difference() {
        union() {
            difference() {
                frame_clip_corner_small();
                translate([-20,-19.4,-40]) rotate([45,0,0]) cube([40,100,20]);
            translate([-40,-18,-40]) rotate([45,0,0]) cube([40,100,20]);
            }
            translate([0,24.5,3.8]) rotate([45,0,0]) rotate([0,90,0]) long_bow_tie_half(47);
        }
        translate([0,20,-35]) cube([40,100,16],center=true);
        translate([0,-43.4,0]) rotate([-45,0,0]) cube([40,100,16],center=true);
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
    translate([-50/2,4.5,0]) rotate([0,0,90]) long_bow_tie_half(50);
}

module view_proper() {
    frame_mockup(0, 2, 2, 3);
    //translate([165,-170,15]) rotate([0,-55,-45]) full_corner(support=false, extra_stiff=false);
    
    angle = 60.9;
    translate([120+60-20,0,(3*120+120)/2]) rotate([0,90,0]) center();
    translate([165,-120,60]) rotate([0,-135,90]) frame_clip_corner_small();
    translate([165,120,60]) rotate([0,135,90]) frame_clip_corner_small();
    translate([165,120,3*120+60]) rotate([0,45,90]) frame_clip_corner_small();
    translate([165,-120,3*120+60]) rotate([0,-45,90]) frame_clip_corner_small();
    
    beam_l = 156;
    translate([165,-126,54]) rotate([angle,0,0]) translate([0,beam_l/2,0]) rotate([0,90,0]) beam(beam_l);
    translate([165,126,54]) rotate([180-angle,0,0]) translate([0,beam_l/2,0]) rotate([0,90,0]) beam(beam_l);
    
    translate([165,126,3*120+66]) rotate([angle,0,0]) translate([0,-7,0]) rotate([0,90,0]) corner_bolt();
    translate([165,50,1.5*120+110]) rotate([180+angle,0,0]) translate([0,-7,0]) rotate([0,90,0]) corner_bolt();
    
    translate([120+60-15,89,360]) rotate([angle,0,0]) long_nut();
    
    //translate([120+60-32.5,-100,60]) rotate([90,-45,90]) frame_clip_slim();
    
    //%translate([120+60-25,-125,83]) rotate([angle+180,0,0]) hook();
    //translate([120+60-15,-105,93]) rotate([angle,0,0]) long_bolt();
    //translate([120+60-15,-58,185]) rotate([angle,0,0]) long_bolt();
    
}

FAST=true;
//FAST=false;

//view_proper();

//center();

//frame_clip();
//frame_clip_corner_large();
//frame_clip_corner_large2();
frame_clip_corner_small();
//frame_clip_corner_small2();
//frame_clip_middle();
//frame_clip_middle_2x();
//frame_center_clip();

//clip_bolt();
//clip_nut();

// right hand thread
//corner_bolt(0);
// left hand thread
//corner_bolt(1);

//long_nut();



