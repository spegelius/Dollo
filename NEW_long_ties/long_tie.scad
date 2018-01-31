length = 50;

include <include.scad>;
include <globals.scad>;

use <long_bow_tie.scad>;

$fn=30;
module end(){
    difference() {
        translate([-4, -5, -0.2]) cube([8, 5, 6]);
        translate([0, 0, -0.5])cylinder(r=3.8, h=7);
    }
}

module tie(length) {
    translate([0,0,scaled_male_dove_depth()]) rotate([0,180,0]) difference(){
        long_bow_tie(length);
        translate([-5,-length-1,scaled_male_dove_depth()]) cube([10,length+2,male_dove_depth]);
    }
}

module long_tie(length=50) {
    difference () {
        tie(length);
        translate([0, -(length -3.5), 0]) end();
        translate([0, -3.5, 0]) rotate([0,0,180]) end();
    }
}

module long_tie_split(length=50) {
    union() {
        difference() {
            translate([0,0,-male_dove_depth+slop]) long_bow_tie_split(length);
            translate([0,-length/2, -3.5]) cube([10,length+1,7], center=true);
        }
        translate([0,-length/2, 0.8]) cube([4,length,1.6], center=true);
    }
}

module long_tie_half(length=50) {
    rotate([0,-90,0]) intersection() {
        long_tie(length);
        translate([0,-length,0]) cube([5,length,5]);
    }
}

long_tie(length);
//long_tie_half(length);
//long_tie_split(length);