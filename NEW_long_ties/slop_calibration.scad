length = 20;

include <globals.scad>;
include <include.scad>;
use <long_bow_tie.scad>;

slop = 0.15;

scaling_x = (max_width - 2*slop) / max_width;
scaling_z =(depth*2-2*slop)/(depth*2);
scaling_y = 1;
echo(scaling_x);
echo(scaling_z);

$fn=30;

translate([-5, 20, 0]) long_bow_tie(20, scaling_x, scaling_y, scaling_z); 

// closed block
difference() {
    cube([20,20,10]);
    translate([10,10,0]) male_dovetail(10);
    #translate([10,10.0001,10]) rotate([180,0,0]) male_dovetail(10);
}

// half block
translate([22,0,0]) difference() {
    cube([20,10,10]);
    translate([10,00,0]) male_dovetail(10);
}