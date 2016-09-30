include <include.scad>;
include <globals.scad>;

height = 20;

module twist_corner_riser() {
    difference() {
        translate([5,5,0]) cube([35,35,height]);
        cube([30.2,30.2,height]);
        translate([15,30,height]) #rotate([-90,0,0]) male_dovetail(height=10);
        translate([40,15,height]) #rotate([-90,0,90]) male_dovetail(height=10);
    }
}

twist_corner_riser();