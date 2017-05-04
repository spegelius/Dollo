include <include.scad>;
include <globals.scad>;
use <long_bow_tie.scad>;

$fn=60;

module long_bow_tie_half(length=50) {
    intersection() {
        long_bow_tie(length);
        translate([0,-length,-1]) cube([6, length, 12]);
        translate([-length/1.9,-length/2,-3]) rotate([0,0,0]) cylinder(d=length*1.5,h=20);
    }
}

rotate ([0,-90,0]) long_bow_tie_half(50);