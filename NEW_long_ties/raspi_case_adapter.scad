// meant for this: http://www.thingiverse.com/thing:209100
include <globals.scad>;
include <include.scad>;

module base() {

    //translate([-8.55,-4.45,-7.8]) intersection() {
    //    translate([-670,-10.5,0]) import("Raspberry_PI_Case_-_bottom.stl", convexity=10);
    //    translate([3.5,0,0]) cube([75,79,9.5]);
    //}

    $fn=23;

    difference() {
        union() {
            hull() {
                translate([0,0,0]) cylinder(d=9, h=4);
                translate([65,0,0]) cylinder(d=9, h=4);
            }
            hull() {
                translate([0,70,0]) cylinder(d=9, h=4);
                translate([65,70,0]) cylinder(d=9, h=4);
            }
            translate([65/2-30/2,-9/2,0]) cube([30,70+9,8]);
        }
        translate([65/2,-8,8]) rotate([-90,0,0]) male_dovetail();

        cylinder(d=bolt_hole_dia, h=5);
        translate([0,0,1.6]) M3_nut(cone=false);
        translate([65,0,0]) {
            cylinder(d=bolt_hole_dia, h=5);
            translate([0,0,1.6]) M3_nut(cone=false);
        }
        translate([0,70,0]) {
            cylinder(d=bolt_hole_dia, h=5);
            translate([0,0,1.6]) M3_nut(cone=false);
        }
        translate([65,70,0]) {
            cylinder(d=bolt_hole_dia, h=5);
            translate([0,0,1.6]) M3_nut(cone=false);
        }
    }
}

base();