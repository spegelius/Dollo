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

module tie() {
    translate([0,0,scaled_male_dove_depth()]) rotate([0,180,0]) difference(){
        long_bow_tie(length);
        translate([-5,-length-1,scaled_male_dove_depth()]) cube([10,length+2,male_dove_depth]);
    }
}

difference () {
    tie();
    translate([0, -(length -3.5), 0]) end();
    translate([0, -3.5, 0]) rotate([0,0,180]) end();
}