include <globals.scad>;
include <include.scad>;

use <extention.scad>;

module _plate(length=40, height=10) {
    hull() {
        translate([0,0,0]) cube([30,length,height/2]);
        translate([7.5,0,height/2]) cube([15,length,height/2]);
    }
}

module leg(plate_len=45) {
    
    module _leg() {
        intersection() {
            translate([0,30,-5]) extention_finished(units=3);
            cube([31,31,90]);
        }
    }
    difference() {
        union() {
            translate([0, 20, 0]) _plate(plate_len);
            translate([20, 30, 0]) rotate([0,0,-90]) _plate(plate_len);
            _leg();
        }
        translate([15,90,0]) rotate([90,0,0]) male_dovetail(90);
        translate([-5,15,0]) rotate([90,0,90]) male_dovetail(90);
    }
}

module foot() {
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
        
        for(i=[0:3]) {
            rotate([0,0,22.5+i*360/4]) translate([20,0,-1]) cylinder(d=5, h=3, $fn=20);
            rotate([0,0,22.5+i*360/4]) translate([20,0,2]) sphere(d=6, $fn=20);
            rotate([0,0,45+i*360/4]) translate([0,-15,0]) male_dovetail(30);
        }
        %translate([0,0,30]) rotate([90,0,45]) translate([-15,-15,-15]) extention(1);
    }
}

//leg();
foot();
