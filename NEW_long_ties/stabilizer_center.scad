
$fn=100;
include <globals.scad>;
include <include.scad>;
use <long_bow_tie.scad>;
use <extention.scad>;

bolt_dia = 15-2*slop;
bolt_dia_minus = 15+2*slop;

pin_bolt_dia = 12-2*slop;
pin_bolt_dia_minus = 12+2*slop;

clip_bolt_dia = 10-2*slop;
clip_bolt_dia_minus = 10+2*slop;

long_bolt_length = 60;

module center() {
    difference() {
        cylinder(d=95, h=10);
        cylinder(d=45, h=11);
        for (i = [0:7]) {
            rotate([0,0,360/8*i]) translate([35,0,0]) cylinder(d=15,h=20);
        }
    }
}

module bolt() {
    _bolt(d=bolt_dia, h=30, h2=20, diameter=1, shaft=20, z_step=3, depth=1);
}

module clip_bolt() {
    _bolt(d=clip_bolt_dia, h=40, h2=20, diameter=1, shaft=30);
}

module nut() {
    _nut(d=bolt_dia_minus, d2=24, h=8, indents=35, z_step=3, depth=1);
}

module clip_nut() {
    _nut(d=clip_bolt_dia, d2=18, h=6, indents=23);
}

module hook(direction=0) {
    height=22;
    difference() {
        union() {
            difference() {
                hull() {
                    translate([10,10.5,height/2]) rounded_cube(20,20,height,4, center=true);
                    translate([0,28,height/2]) rotate([0,90,0]) cylinder(d=height,h=20);
                }
                translate([5-slop,7,0]) cube([10+2*slop,40,30]);
                translate([0,28,height/2]) rotate([0,90,0]) cylinder(d=bolt_dia_minus,h=25);
            }

            if (FAST) {
                translate([10,-long_bolt_length+1,height/2]) rotate([-90,0,0]) cylinder(d=pin_bolt_dia, h=long_bolt_length);
            } else {
                translate([10,-long_bolt_length+1,height/2]) _bolt_shaft(d=pin_bolt_dia, h=long_bolt_length, shaft=0, z_step=3, depth=1, direction=direction);
            }
        }
        translate([10,-long_bolt_length+1,height/2]) rotate([-90,0,0]) cylinder(d=3, h=long_bolt_length+10);
    }
}

module frame_clip() {
    side = 45;
    module side() {
        union() {
            difference() {
                cube([19.5,50,side]);
                translate([5,-1,-1]) cube([20,60,side+2]);
            }
            translate([10,50,0]) rotate([-90,0,90]) difference() {
                long_bow_tie(side);
                translate([0,-side-1,-1]) cube([20,side+2,12]);
            }
        }
    }
    
    rotate([0,-90,0]) difference() {
        union() {
            translate([0,sqrt(30*30/2),0]) rotate([45,0,0]) side();
            translate([0,sqrt(7*7),0]) rotate([-45,0,0]) mirror([0,1,0]) side();
            translate([5,sqrt(30*30/2)-sqrt(7*7),26]) rotate([0,90,0]) cylinder(d=bolt_dia,h=14.75);
        }
        translate([-1,-15,0]) cube([50,60,17]);
        translate([-1,sqrt(30*30/2)-sqrt(7*7),26]) rotate([0,90,0]) cylinder(d=clip_bolt_dia_minus,h=25);
        
        translate([0,sqrt(30*30/2)-sqrt(7*7),65]) rotate([45,0,0]) cube([25,20,20], center=true);
    }
    
    //side();
    //translate([5,65,0]) % rotate([90,0,0]) extention();
}

module frame_clip_slim() {
    translate([0,0,-2.5]) difference() {
        frame_clip();
        cube([200,200,5], center=true);
    } 
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
            translate([0,30,2.5]) cylinder(d=bolt_dia,h=14.75);
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

module frame_clip_corner() {
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
        translate([-10,fc_height-sqrt(8*8/2),10-sqrt(14.5*14.5*2)-sqrt(10.5*10.5/2)]) rotate([0,90,0]) cylinder(d=15,h=25);
    }
}

module frame_clip_corner2() {
    
    difference() {
        frame_clip_corner();
        translate([20,fc_height*2-sqrt(98),0]) mirror([0,1,0]) rotate([45,0,0]) cube([10,100,30], center=true);
    }
}

module frame_clip_corner3() {
    
    difference() {
        frame_clip_corner();
        translate([19,0]) cube([20,200,200], center=true);
        translate([-19,0]) cube([20,200,200], center=true);
    }
}

module frame_clip_corner4() {
    difference() {
        union() {
            difference() {
                frame_clip_corner3();
                translate([-20,-19.4,-40]) rotate([45,0,0]) cube([40,100,20]);
            translate([-40,-18,-40]) rotate([45,0,0]) cube([40,100,20]);
            }
            translate([0,24.5,3.8]) rotate([45,0,0]) long_bow_tie_half(47);
        }
        translate([0,20,-35]) cube([40,100,16],center=true);
        translate([0,-43.4,0]) rotate([-45,0,0]) cube([40,100,16],center=true);
    }
}



module long_bolt(direction=0) {
    length = 60;
    if (FAST) {
        translate([0,-20,0]) rotate([-90,0,0]) cylinder(d=pin_bolt_dia, h=length);
    } else {
        _bolt_shaft(d=pin_bolt_dia, h=length/2, shaft=3, z_step=3, depth=1);
        translate([0,30-length+3,0]) _bolt_shaft(d=pin_bolt_dia, h=length/2-3, shaft=0, z_step=3, depth=1, direction=direction);
    }
}

module long_nut() {
    side = 16;
    length = 80;
    difference() {
        translate([side/2,0,side/2]) rounded_cube(side,length,side,4,center=true);
        if (FAST) {
            translate([side/2,-length/2-.5,side/2]) rotate([-90,0,0]) cylinder(d=pin_bolt_dia_minus, h=length/2);
            translate([side/2,0.5,side/2]) rotate([-90,0,0]) cylinder(d=pin_bolt_dia_minus, h=length/2);
        } else {
            translate([side/2,-length/2-.5,side/2]) rotate([-90,0,0]) _threads(d=pin_bolt_dia_minus, h=length/2, z_step=3, depth=1);
            translate([side/2,0.5,side/2]) rotate([-90,0,0]) _threads(d=pin_bolt_dia_minus, h=length/2, z_step=3, depth=1,direction=1);
        }
        translate([side/2-5/2, -length/2-1, side/2+1]) cube([5,length+5,6]);
    }
    
}

module frame_center_clip() {
    difference() {
        intersection() {
            translate([0,0,5/2]) rotate([0,0,45]) cube([41,41,5], center=true);
            translate([-25,0,0]) cube([50,24,10]);
        }
        translate([0,bolt_dia_minus/2+5]) cylinder(d=bolt_dia_minus, h=5);
    }
    translate([-45/2,4.5,0]) rotate([0,-90,90]) long_bow_tie_half(45);
}

module view_proper() {
    frame_mockup(0, 2, 2, 3.5);
    
    angle = 61;
    translate([120+60-20,0,(3.5*120+120)/2]) rotate([0,90,0]) center();
    translate([120+60-32.5,-100,60]) rotate([90,-45,90]) frame_clip_slim();
    %translate([120+60-25,-27,(3.5*120+120)/2-55]) rotate([angle,0,0]) hook();
    %translate([120+60-25,-125,83]) rotate([angle+180,0,0]) hook();
    translate([120+60-15,-105,93]) rotate([angle,0,0]) long_bolt();
    translate([120+60-15,-58,185]) rotate([angle,0,0]) long_bolt();
    translate([120+60-15,-58,140]) rotate([angle,0,0]) long_nut();
    translate([160,-165,55]) rotate([-135,0,-90]) frame_clip_corner4();
    
    
}

//FAST=true;
FAST=false;

//center();
//bolt();
//nut();
//hook(0);

//frame_clip();
//frame_clip_slim();
//frame_clip_corner();
//frame_clip_corner2();
//frame_clip_corner3();
//frame_clip_corner4();
//frame_clip_middle();
//frame_clip_middle_2x();
//frame_center_clip();

//clip_bolt();
//clip_nut();

//long_bolt(0);
//long_bolt(1);
long_nut();

//view_proper();