length = 50;
include <include.scad>;
include <globals.scad>;
use <long_bow_tie.scad>;

module long_bow_tie_half() {
    intersection() {
        long_bow_tie();
        #translate([0.1,-length,-6]) cube([6, length, 12]);
    }
}

rotate ([0,-90,0]) long_bow_tie_half();