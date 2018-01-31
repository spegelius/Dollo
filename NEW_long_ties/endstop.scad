include <include.scad>;
include <globals.scad>;

use <mockups.scad>;
use <long_tie.scad>;
use <rack.scad>;

$fn=20;
switch_length = 20.5;
switch_depth = 6.5;
switch_width = 11;
radius = 1;

module button(){
	difference(){
		hull(){
			translate([radius/2,radius/2,0]) cylinder(h=switch_depth, d=radius);
			translate([switch_length-radius/2,radius/2,0]) cylinder(h=switch_depth, d=radius);
			translate([radius/2,switch_width-radius/2,0]) cylinder(h=switch_depth, d=radius);
			translate([switch_length-radius/2,switch_width-radius/2,0]) cylinder(h=switch_depth, d=radius);
		}
		//union(){
		//	translate([radius/2,radius/2,0]) cylinder(h=switch_depth, d=3);
		//	translate([switch_length-radius/2,switch_width-radius/2,0]) cylinder(h=switch_depth, d=3);
		//}
	}
}
module button_plus(){
	button();
	hull(){
		translate([-5,10,3]) sphere(r=3);
		translate([-5,10,10]) sphere(r=3);
		translate([16,10,3]) sphere(r=3);
		translate([16,10,10]) sphere(r=3);
	}
	
	hull(){
		translate([25,0,3]) sphere(r=3);
		translate([25,0,10]) sphere(r=3);
		translate([5,0,3]) sphere(r=3);
		translate([5,0,10]) sphere(r=3);
	}
}

module endstop_v1() {
    translate([-3,-2,switch_depth+2]) cube([4,9,1]);
    difference(){
        difference(){
            translate([-3,-2,-7]) cube([switch_length+6,switch_width+3,switch_depth+9]);
            translate([0,0,2]) button_plus();
        }
        rotate([90,0,0]) translate([switch_width,-7,-13]) male_dovetail(height=15);
    }
}

module endstop_v2() {
    difference() {
        union() {
            endstop_v1();
            translate([-3,-2,-9]) cube([switch_length+6,switch_width+4,12]);
        }
        translate([switch_length-7,switch_width+2,-9]) rotate([0,0,180]) male_dovetail(height=11);
        translate([-3,switch_width-1,-9]) rotate([0,0,25]) cube([10,10,15]);
    }
    %translate([4.5,28,0]) rotate([0,0,90]) do_rack(1);
}

module endstop_v3() {
    intersection() {
        endstop_v1();
        translate([0,0,10/2]) cube([50,50,10],center=true);
    }
    intersection() {
        translate ([8,50/2+9/2,2]) difference() {
            rotate([0,180,0]) long_tie();
            cube([10,101,4],center=true);
        }
        translate([-3,-2,-7]) cube([switch_length+6,switch_width+3,switch_depth+9]);
    }
}

module z_endstop() {
    difference() {
        union() {
            endstop_v1();
            translate([-3,-9,-9]) cube([switch_length+6,switch_width+11,12]);
        }
        #translate([-5,-2,-9]) rotate([90,0,90]) male_dovetail(height=41);
        translate([-3,switch_width-1,-9]) rotate([0,0,25]) cube([10,10,15]);
    }
    //translate([0,-2,-20]) %cube([30,30,30],center=true);
}

module xy_endstop() {
    l = 21;
    difference() {
        rounded_cube(30,l,12,3);
        translate([5,l-8,1]) cube([20+slop,6+slop, 12]);
        
        translate([5.15,l-8,-0.1]) cube([3, 6, 11]);
        translate([5+9.2,l-8,-0.1]) cube([3, 6, 11]);
        translate([5+20-2.5,l-8,-0.1]) cube([2.5, 6, 11]);
        
        translate([10+slop/2, l+.1, 4]) rotate([90,0,0]) cylinder(d=2.2, h=10, $fn=30);
        translate([20+slop/2, l+.1, 4]) rotate([90,0,0]) cylinder(d=2.2, h=10, $fn=30);
        
        translate([4.8,0,12.1]) rotate([-90,0,0]) male_dovetail(5);
        translate([25.3,0,12.1]) rotate([-90,0,0]) male_dovetail(5);
        translate([14.8,11.9,12]) rotate([90,0,0]) linear_extrude(13) polygon(points=[[0,2], [10,2], [10,0], [5,-2.9], [0,0]]);
    }
    
    %translate([5+slop/2,l-2+slop/2,1]) rotate([90,0,0]) mechanical_endstop();
    %translate([13.8,3.98,27]) rotate([0,-90,-90]) do_rack(1);
}

//endstop_v1();
//endstop_v2();
//endstop_v3();
//z_endstop();
xy_endstop();