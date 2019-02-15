include <globals.scad>;
include <include.scad>;

use <z_screw.scad>;
use <mockups.scad>;
use <extention.scad>;
use <long_tie.scad>;
use <z_coupler.scad>;

module z_motor_mount() {
    l = 66;
    translate([0,0,l/2]) rotate([90,0,0]) intersection() {
        difference() {
            union() {
                difference() {
                    translate([-15.5,0,32.5/2-3]) cube([72,l,34.5], center=true);
                    translate([56,0,5]) rotate([0,-45,0]) cube([50,80,500], center=true);
                }
                translate([-30/2-z_screw_d/2-1,0,-3.99]) intersection() {
                    translate([0,-(l+10)/2,0]) rotate([180,0,0]) long_tie(l+10);
                    cube([10,l,10],center=true);
                }
            }
            
            translate([-30/2-z_screw_d/2-1,0,50/2+5]) cube([30,100,50],center=true);
            
            translate([0,0,5]) cylinder(d=z_screw_d+0.5,h=50,$fn=50);
            translate([0,0,5]) hull() {
                translate([-5,0,50/2]) cube([1,35,50],center=true);
                translate([35,0,50/2]) cube([50,l,50],center=true);
            }

            translate([0,-50/2,37.9]) rotate([45,0,0]) cube([120,50,20],center=true);
            translate([0,50/2,37.9]) rotate([-45,0,0]) cube([120,50,20],center=true);

            translate([0,0,-11/2]) hull() {
                cube([43,43,11],center=true);
                cube([43,51,1],center=true);
            }
            
            translate([20,0,-9/2]) hull() {
                cube([40,l,9],center=true);
                cube([48,l,1],center=true);
            }

            translate([-30/2-z_screw_d/2-1,80/2,5.01]) rotate([90,180,0]) male_dovetail(80);
            translate([-z_screw_d/2-1.01,40+9,30/2+5]) rotate([90,90,0]) male_dovetail(40);
            translate([-z_screw_d/2-1.01,-9,30/2+5]) rotate([90,90,0]) male_dovetail(40);
            translate([-30-z_screw_d/2-1,80/2,30/2+5]) rotate([90,-90,0]) male_dovetail(80);
            
            translate([-30-z_screw_d/2-8,0,30/2+5]) cube([5,10,5],center=true);
            
            translate([0,0,34]) rotate([45,0,0]) cube([180,8,8],center=true);
            
            motor_plate_holes(h=5, bolt_head_cones=true);
            translate([-motor_bolt_hole_distance/2,motor_bolt_hole_distance/2,5]) cylinder(d=bolt_head_hole_dia,h=50,$fn=20);
            translate([-motor_bolt_hole_distance/2,-motor_bolt_hole_distance/2,5]) cylinder(d=bolt_head_hole_dia,h=50,$fn=20);
            
        }
        translate([-16,0,0]) rotate([0,0,45]) cube([80,80,100],center=true);
        
    }
    // supports
    translate([-43.5,-16.5,0]) cylinder(d=4,h=4.2);
    translate([-44.5,-22.5,0]) cylinder(d=4,h=8);
    translate([-13,-22.5,0]) cylinder(d=4,h=8);
}

module debug() {
    z_motor_mount();
    %translate([0,40/2,12]) rotate([0,0,180]) mock_stepper_motor();
    %translate([0,-6,12+42/2]) rotate([90,0,0]) motor_shaft_adapter();
    %translate([0,-23,42/2+12]) rotate([90,0,0]) z_screw_motor_flex_coupler(fast_render=true);
}
debug();
//z_motor_mount();