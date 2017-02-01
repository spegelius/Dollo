include <globals.scad>;
include <include.scad>;

$fn=30;

difference() {
    cube([10,45,2.6]);
    translate([5, 7.5, -0.1]) cylinder(d=bolt_hole_dia, h=3);
    translate([5, 17.5, -0.1]) cylinder(d=bolt_hole_dia, h=3);
    translate([5, 27.5, -0.1]) cylinder(d=bolt_hole_dia, h=3);
    translate([5, 37.5, -0.1]) cylinder(d=bolt_hole_dia, h=3);
}

translate([-10,0,0]) rotate([0,-90,0]) difference() {
    union() {
        cube([10,30,2.6]);
        cube([10,10,12]);
    }
    translate([5, 5, -0.1]) cylinder(d=bolt_hole_dia, h=13);
}

translate([-25,0,0]) rotate([0,-90,0]) difference() {
    union() {
        cube([10,30,2.6]);
        cube([10,10,7]);
    }
    translate([5, 5, -0.1]) cylinder(d=bolt_hole_dia, h=13);
}