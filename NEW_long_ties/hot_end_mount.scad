include <globals.scad>;
include <include.scad>;

use <long_tie.scad>;
use <long_bow_tie_experimental.scad>;
use <long_bow_tie.scad>;

hotend_depth = 75;
mounting_diamiter = 12+slop;
top_diamiter = 17;
arm_thickness = 5;
snap_location = 47;
natch_height = 6;

$fn=60;

module motor_mount_small(height=15){
	//scale([.9,.9,.9]) translate([-8.75,1,snap_location]) male_dovetail(35);
    translate([-8+slop,0.95,snap_location-4.5]) rotate([-90,0,0]) scale([.98,1,0.99]) long_tie(.9*35);
}

module y_mount_added(){
	motor_mount_small();
	translate([1,-4+((10-arm_thickness)/2),hotend_depth/2]) cube([25,arm_thickness,hotend_depth], center=true);
    translate([1,-15,hotend_depth-(natch_height)]) cube([25,30,natch_height*2],center=true);
	translate([-4,-15,hotend_depth-17]) rotate([-45,0,0]) cube([15,33.2,natch_height*2],center=true);
    translate([-4,-5,hotend_depth-27]) cube([15,5,natch_height*2],center=true);
	translate([1,1,0]) cube([25,8,5],center=true);
}

module y_mount_taken(){
        translate([0,-13,hotend_depth/2]) cylinder(h=70, d=mounting_diamiter);
	    translate([0,-13,0]) cylinder(h=70, d=top_diamiter);
		translate([0,-26,hotend_depth-natch_height]) rotate([0,-90,0]) cylinder(h=30, d=bolt_hole_dia, $fn=20);
		translate([0,-2,hotend_depth-natch_height+3]) rotate([0,-90,0]) cylinder(h=30, d=bolt_hole_dia, $fn=20);
        translate([-8+slop,1,-1]) male_dovetail(20);
        translate([-8+slop,1,-1]) rotate([0,0,180]) male_dovetail(20);
        translate([-12,-8,-1]) cube([5,15,20]);
}
module mount(){
	difference(){
		rotate([0,-90,0]){
			intersection(){
				translate([-15,-30,0]) cube([15,100,100]);
				difference(){
						y_mount_added();
						y_mount_taken();
				}
			}
			translate([-11.5,.7,37.5+(hotend_depth-80)]) cube([7,.3,42.5]);
		}
		translate([-hotend_depth/2,0,(-hotend_depth/2)-23/2]) cube([hotend_depth,hotend_depth,hotend_depth], center=true);
	}
}

module clamp() {
    
    module cable_hole() {
        difference() {
            union() {
                hull() {
                    cylinder(d=11, h=3);
                    translate([0,5,0]) cylinder(d=11, h=3);
                }
                translate([-5.5,-5.5,0]) cube([11,6,3]);
            }
            rotate([-40,0,0]) translate([0,0,-3]) hull() {
                cylinder(d=7, h=19);
                translate([0,2,0]) cylinder(d=7, h=19);
            }
            rotate([20,0,0]) translate([2,2,-5]) cube([4,4,10]);
        }
    }
    
    union(){
        translate([-8,0,5]) long_bow_tie_split(15);
        translate([8,0,5]) long_bow_tie_split(15);
        translate([-11.75,-15,-3]) cube([23.5,15,3]);
        translate([-11.75,-15,0]) cube([7.5,15,0.6]);
        translate([4.25,-15,0]) cube([7.5,15,0.6]);
        translate([0,4,-3]) cable_hole();
    }
}


translate([0,0,25/2-1]) mount();
translate([0,-65,25/2-1]) mirror([0,1,0]) mount();

translate([-20,-25,3]) clamp();
