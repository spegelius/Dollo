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

module clip_verylarge() {
    _clip(d=15);
}

module clip_large() {
    _clip(d=12);
}

module clip_small() {
    _clip(d=7);
}

module _shroud_holder(h=25,d=13.5,edge_h=1) {
    outer_d = d + 5;
    difference() {
        hull() {
            cylinder(d=outer_d, h=h, $fn=30);
            translate([-outer_d/2,-outer_d/2,0]) cube([outer_d,1,h]);
        }
        cylinder(d=d-2, h=h+1, $fn=30);
        translate([0,0,edge_h]) cylinder(d1=d-2, d2=d, h=0.7, $fn=30);
        translate([0,0,edge_h+0.7]) cylinder(d=d, h=h, $fn=30);
        translate([-9/2,0,0]) cube([9,outer_d,h+1]);
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

//clip_verylarge();
//clip_large();
//clip_small();
cable_shroud_frame_mount();