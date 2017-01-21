use <long_tie.scad>;
include <include.scad>;
include <globals.scad>;

$fn=60;

rotate([90,180,0]) difference() {
    union() {
        scale([1.1,1,1.1]) rotate([90,0,0]) male_dovetail(15);
        translate([0,0,-5.2]) rotate([90,0,0]) difference() {
            cylinder(d=12, h=15);
            cylinder(d=9, h=16);
        }
    }
    rotate([0,8,0]) translate([-1,-15,-1]) cube([2,20,7]);
    rotate([0,-8,0]) translate([-1,-15,-1]) cube([2,20,7]);
}
