use <long_tie.scad>;
include <include.scad>;
include <globals.scad>;

$fn=60;

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

module clip_large() {
    _clip(d=12);
}

module clip_small() {
    _clip(d=7);
}

//clip_large();
//clip_small();

module cable_shroud_frame_mount() {

    module holder() {
        difference() {
            hull() {
                cylinder(d=12+2.4, h=14, $fn=30);
                translate([-(12+2.4)/2,-(12+2.4)/2,0]) cube([12+2.4,1,14]);
            }
            cylinder(d=10, h=15, $fn=30);
            translate([0,0,1]) cylinder(d=12, h=15, $fn=30);
            translate([-9/2,0,0]) cube([9,9,15]);
        }
    }

    union() {
        difference() {
            rounded_cube_side(20,20,15,4);
            translate([8,0,0]) cube([30,40,30]);
            translate([8.01,20/2,0]) rotate([0,0,90]) male_dovetail(15);
        }

        translate([-(12+2.4)/2+0.01,10,0]) rotate([0,0,90]) holder();
    }
}

cable_shroud_frame_mount();