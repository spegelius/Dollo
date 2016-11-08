include <include.scad>;
include <globals.scad>;

use <long_bow_tie.scad>;

length = 50;
max_width=7.9;
min_width=4.55;
height=4.9;
depth=5;


module split() {
    linear_extrude(height=length) polygon(points=[[0,-1], [0.9,-1], [2.1,-5], [-2.1,-5], [-0.9,-1]]);
}

rotate([90,0,0]) difference() {
    union() {
        dovetail_3d(max_width, min_width, height, length);
        mirror([0,1,0]) dovetail_3d(max_width, min_width, height, length);
    }
    split();
    rotate([0,0,180]) split();
}
