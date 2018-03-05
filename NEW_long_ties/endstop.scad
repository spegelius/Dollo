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

module xy_endstop_racktop() {
    l = 10;
    rotate([270,0,0]) translate([0,-12,0]) union() {
        difference() {
            rounded_cube(25,12,l,3);
            translate([2.5,-1.5,2]) cube([20+slop,12,6+2*slop]);
            translate([3.5,-4,2.5]) cube([18+slop,18,8+3*slop]);

            translate([2.8,5,2+slop]) cube([4, 11, 5.9]);
            translate([2.5+8.8,5,2]) cube([4, 11, 8]);
            translate([2.5+17,5,2+slop]) cube([3, 11, 5.9]);
            translate([14,3.98,-7.15]) rotate([0,0,-90]) do_rack(1);
        }
        intersection() {
            translate ([5,15,2.25]) rotate([0,180,0]) long_tie_split();
            translate([-3,0,-4.5]) cube([switch_length+6,12,6]);
        }
        %translate([2.5+slop/2,12.9-3+slop/2,8.2]) rotate([180,0,0]) mechanical_endstop();
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

module xy_endstop_rackend() {
    l = 21;
    difference() {
        rounded_cube(30,l,12,3);
        translate([5,l-8.2,1.5]) cube([20+slop,6+3*slop, 12]);
        translate([6,l-7.2,0]) cube([18+slop,6+8*slop, 12]);
        
        translate([5.15,l-8,-0.1]) cube([3, 6, 11]);
        translate([5+9.2,l-8,-0.1]) cube([3, 6, 11]);
        translate([5+20-2.5,l-8,-0.1]) cube([2.5, 6, 11]);
        
        translate([10+slop/2, l+.1, 4]) rotate([90,0,0]) cylinder(d=2.2, h=15, $fn=30);
        translate([20+slop/2, l+.1, 4]) rotate([90,0,0]) cylinder(d=2.2, h=15, $fn=30);
        
        translate([5.8,0,12.2]) rotate([-90,0,0]) scale([1.03,1,1]) male_dovetail(8.8);
        translate([23.8,0,12.2]) rotate([-90,0,0]) scale([1.03,1,1]) male_dovetail(6.6);
        translate([15.8,11.9,12.5]) rotate([90,0,0]) linear_extrude(13) polygon(points=[[0,2], [10,2], [10,0], [5,-2.9], [0,0]]);
    }
    
    %translate([5+slop/2,l-2+slop/2,2]) rotate([90,0,0]) mechanical_endstop();
    %translate([14.8,3.98,27]) rotate([0,-90,-90]) do_rack(1);
}

//endstop_v1();
//endstop_v2();
//z_endstop();
xy_endstop_racktop();
//xy_endstop_rackend();
