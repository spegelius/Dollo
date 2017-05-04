include <globals.scad>;
include <include.scad>;

difference() {
    intersection() {
        translate([0,0,-10]) sphere(d=60, $fn=90);
        translate([0,0,6]) cube([80,80,12], center=true);
    }
    cylinder(d=metal_rod_size,h=40, $fn=40);
    translate([0,7,12]) rotate([-90,0,0])male_dovetail(height=30);
    translate([0,-7-30,12]) rotate([-90,0,0])male_dovetail(height=30);
    rotate([0,0,90]) translate([0,7,12]) rotate([-90,0,0])male_dovetail(height=30);
    rotate([0,0,90]) translate([0,-7-30,12]) rotate([-90,0,0])male_dovetail(height=30);
    
    translate([13,13,-1]) cylinder(d=5, h=10, $fn=20);
    translate([-13,13,-1]) cylinder(d=5, h=10, $fn=20);
    translate([-13,-13,-1]) cylinder(d=5, h=10, $fn=20);
    translate([13,-13,-1]) cylinder(d=5, h=10, $fn=20);
}