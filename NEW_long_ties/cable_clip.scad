include <include.scad>;
include <globals.scad>;

use <long_tie.scad>;
use <long_bow_tie.scad>;
use <mockups.scad>;

$fn=60;

//clip_verylarge();
//clip_large();
clip_small();
//cable_shroud_frame_mount();
//cable_shroud_frame_clip();
//cable_shroud_frame_clip2();
//cable_shroud_motor_clip();
//frame_spacer();

module _clip(d=12) {
    rotate([90,180,0]) difference() {
        union() {
            scale([1.1,1,1.1]) rotate([90,0,0]) male_dovetail(15);
            translate([0,0,-d/2+(1.5-3*0.01*d)]) rotate([90,0,0]) difference() {
                cylinder(d=d, h=15);
                cylinder(d=d-3, h=16);
            }
        }
        rotate([0,9,0]) translate([-1,-15,-2]) cube([2,20,8]);
        rotate([0,-9,0]) translate([-1,-15,-2]) cube([2,20,8]);
    }
}

module clip_verylarge() {
    _clip(d=15);
}

module clip_large() {
    _clip(d=12);
}

module clip_small() {
    _clip(d=9);
}

module _shroud_holder(h=25,d=13.5,edge_h=1, gap=9) {
    outer_d = d + 5;
    difference() {
        hull() {
            cylinder(d=outer_d, h=h, $fn=30);
            translate([-outer_d/2,-outer_d/2,0]) cube([outer_d,1,h]);
        }
        cylinder(d=d-2, h=h+1, $fn=30);
        translate([0,0,edge_h]) cylinder(d1=d-2, d2=d, h=0.7, $fn=30);
        translate([0,0,edge_h+0.7]) cylinder(d=d, h=h+1-edge_h, $fn=30);
        translate([-gap/2,0,0]) cube([gap,outer_d,h+1]);
    }
}

module cable_shroud_frame_mount() {
    h = 25;
    d = 13.5;

    union() {
        difference() {
            rounded_cube_side(20,20,h+1,4);
            translate([8,0,0]) cube([30,40,30]);
            translate([8.01,20/2,0]) rotate([0,0,90]) male_dovetail(h+1.1);
        }

        translate([-(12+2.4)/2+0.01,10,0]) rotate([0,0,90]) _shroud_holder();
    }
}

module cable_shroud_frame_clip() {
    h = 25;
    d = 13.5;

    union() {
        difference() {
            rounded_cube_side(20,20,h+1,4);
            translate([8,0,0]) cube([30,40,30]);
            translate([8.01,20/2,0]) rotate([0,0,90]) male_dovetail(h+1.1);
        }

        translate([-(12+2.4)/2+0.01,10,0]) rotate([0,0,90]) _shroud_holder(edge_h=-1, gap=11);
    }
}

use <../../_downloaded/Customizable_Cable_Shroud/shroud-twirl-gap.scad>;

module cable_shroud_frame_clip2() {

    h = 50;
    w = 16.6;

    intersection() {
        difference() {
            union() {
                cube([w,20,h]);
                translate([w/2,-6,-1]) rotate([0,0,180]) _shroud_holder(h=h+2,d=11.6,edge_h=0,gap=8);
            }
            translate([0,8,0]) cube([30,40,h+1]);
            translate([w/2,-16.5,h/2]) chamfered_cube(w+50,32,h-8,14,center=true);
            translate([w/2,8.01,0]) rotate([0,0,180]) male_dovetail(h+1.1);

            translate([w/2,-30/2+2.8,h/2]) difference() {
                cylinder(d=30,h=3,$fn=50,center=true);
                cylinder(d=27,h=4,$fn=50,center=true);
            }
        }
        translate([w/2,0,h/2]) cube([w+2,100,h],center=true);
    }
}

module _cable_shroud_motor_clip_body(h=12) {
    //%rotate([90,0,180])
    //translate([0,0,-motor_side_length/2])
    //mock_stepper_motor(false);

    difference() {
        union() {
            chamfered_cube_side(
                motor_side_length + 8,
                motor_side_length + 8,
                h, 4, center=true);

            translate(
                [0, -(motor_side_length + 8)/2 - 20/2 + 13, 0])
            chamfered_cube_side(16.5 + 7, 20, h, 2, center=true);
        }
        difference() {
            chamfered_cube_side(
                motor_side_length + slop,
                motor_side_length + slop,
                h + 1, 2, center=true);

            for(i=[0:3]) {
                rotate([0, 0, 360/4*i]) {
                    translate(
                        [motor_side_length/2 + 3/2 - 0.5, 4, 0])
                    cylinder(d=3, h=h, center=true, $fn=20);

                    translate(
                        [motor_side_length/2 + 3/2 - 0.5, -4, 0])
                    cylinder(d=3, h=h, center=true, $fn=20);
                }
            }
        }

        translate([0, -(motor_side_length + slop)/2, 0])
        cube([16.5, 15, h + 1], center=true);
    }

}

module cable_shroud_motor_clip() {

    difference() {
        union() {
            _cable_shroud_motor_clip_body();

            translate([-motor_side_length/2-3,-motor_side_length/2+4])
            rotate([90,0,0])
            cylinder(d=5,h=15,center=true,$fn=40);
        }
        translate([-motor_side_length/2-3,-motor_side_length/2+4])
        rotate([90,0,0])
        cylinder(d=2.4,h=36,center=true,$fn=40);
    }
}

module frame_spacer() {
    difference() {
        union() {
            translate([0,0,30/2]) cube([20,15,30],center=true);
            translate([0,15/2+0.2,30/2]) rotate([-90,0,0]) long_bow_tie_split(30, middle=true);
        }
        translate([0,-15/2,0]) male_dovetail(31);
    }
}

module debug() {
    frame_mockup();
}

