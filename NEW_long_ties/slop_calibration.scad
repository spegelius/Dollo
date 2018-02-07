length = 20;

include <globals.scad>;
include <include.scad>;
use <bow_tie.scad>;
use <long_bow_tie.scad>;

slop = 0.15;

$fn=30;

translate([-5, 30, 0]) bow_tie();
translate([-15, 20, 0]) long_bow_tie(20); 
translate([-5, 20, 0]) long_bow_tie_split(20);

// half block
translate([22,0,0]) difference() {
    cube([20,10,10]);
    translate([10,00,0]) male_dovetail(10);
}

// overhang
translate([0,10,0]) rotate([90,0,0]) difference() {
    cube([20,10,10]);
    translate([10,00,0]) male_dovetail(10);
}
