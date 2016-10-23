include <globals.scad>;
include <include.scad>;

height = 10;

// ver 1
difference() {
    union() {
        translate([0,0,5]) rotate([90,0,0]) male_dovetail(height=10);
        translate([-4.5, -14, 0]) cube([9,4,10]);
        translate([-2.5, -12, 0]) cube([5,12,5]);
        translate([-1.5, -height, 0]) cube([3,height,10]);
        translate([-8, -height-8, 0]) cube([16,8,15]);
    }
    translate([0, -height-8, 0]) male_dovetail(height=15);
}

// ver 2

difference() {
    union() {
        translate([20,0,0]) cube([20,10,8]);
        translate([20,5,0]) rotate([0,0,90]) scale([0.95,1,1]) male_dovetail(height=8);
    }
    translate([30,0,8]) rotate([-90,0,0]) male_dovetail(height=15);
}
