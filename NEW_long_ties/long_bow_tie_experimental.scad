include <include.scad>;
include <globals.scad>;

use <long_bow_tie.scad>;

length = 50;

module split() {
    translate([0,0,-1]) linear_extrude(height=length+2) polygon(points=[[0,-1], [1,-1], [2.1,-5], [-2.1,-5], [-1,-1]]);
}

module long_bow_tie_split(length) {
    rotate([90,0,0]) difference() {
        translate([0,-(male_dove_depth-slop),0]) rotate([-90,0,0]) long_bow_tie(length);
        split();
        rotate([0,0,180]) split();
    }
}

long_bow_tie_split(length);
