include <globals.scad>;
include <include.scad>;

box_width = 83;
box_length = 123;

frame_mockup();

$fn=30;

module ear() {
    hull() {
        translate([0,0,0]) cube([5,15,0.1]);
        translate([20,7.5,0]) cylinder(d=15,h=0.1);

        translate([0,3.5,3.9]) cube([5,8,0.1]);
        translate([20,7.5,3.9]) cylinder(d=8,h=0.1);
    }
}

module ears() {
    difference() {
        hull() {
            ear();
            mirror([1,0,0]) ear();
        }
        translate([20,7.5,0]) cylinder(d=bolt_hole_dia,h=7);
        translate([20,7.5,1.8]) nut();
        
        translate([-20,7.5,0]) cylinder(d=bolt_hole_dia,h=7);
        translate([-20,7.5,1.8]) nut();

    }
}

module body() {
    difference() {
        union() {
            translate([0,3.5,0]) cube([20, box_length-27, 7.5]);
            translate([10, box_length-20-15, 0]) ears();
            translate([10, 0, 0]) ears();
        }
        translate([10, 0, 7.5]) rotate([-90,0,0]) male_dovetail(box_length);
        
    }
}

//translate([95,127.5,0]) rotate([90,0,0]) body();
body();