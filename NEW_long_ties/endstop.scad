include <include.scad>;
include <globals.scad>;

use <mockups.scad>;
use <long_tie.scad>;
use <rack.scad>;


////// VARIABLES //////
$fn=20;
switch_length = 20.5;
switch_depth = 6.5;
switch_width = 11;
radius = 1;


////// VIEW //////
//endstop_v1();
//endstop_v2();
//z_endstop();
//xy_endstop_racktop();
xy_endstop_rackend();


////// MODULES //////
module button(){
	difference(){
		hull(){
			translate([radius/2,radius/2,0])
            cylinder(h=switch_depth, d=radius);

			translate([switch_length-radius/2,radius/2,0])
            cylinder(h=switch_depth, d=radius);

			translate([radius/2,switch_width-radius/2,0])
            cylinder(h=switch_depth, d=radius);

			translate([switch_length-radius/2,switch_width-radius/2,0])
            cylinder(h=switch_depth, d=radius);
		}
		//union(){
		//	translate([radius/2,radius/2,0])
        //  cylinder(h=switch_depth, d=3);

		//	translate([switch_length-radius/2,switch_width-radius/2,0])
        //  cylinder(h=switch_depth, d=3);
		//}
	}
}

module button_plus(){
	button();
	hull(){
		translate([-5,10,3])
        sphere(r=3);

		translate([-5,10,10])
        sphere(r=3);

		translate([16,10,3])
        sphere(r=3);

		translate([16,10,10])
        sphere(r=3);
	}
	
	hull(){
		translate([25,0,3])
        sphere(r=3);

		translate([25,0,10])
        sphere(r=3);

		translate([5,0,3])
        sphere(r=3);

        translate([5,0,10])
        sphere(r=3);
	}
}

module endstop_v1() {
    translate([-3,-2,switch_depth+2])
    cube([4,9,1]);

    difference(){
        difference(){
            translate([-3,-2,-7])
            cube([switch_length+6,switch_width+3,switch_depth+9]);

            translate([0,0,2])
            button_plus();
        }
        rotate([90,0,0])
        translate([switch_width,-7,-13])
        male_dovetail(height=15);
    }
}

module endstop_v2() {
    difference() {
        union() {
            endstop_v1();
            translate([-3,-2,-9])
            cube([switch_length+6,switch_width+4,12]);
        }
        translate([switch_length-7,switch_width+2,-9])
        rotate([0,0,180])
        male_dovetail(height=11);

        translate([-3,switch_width-1,-9])
        rotate([0,0,25])
        cube([10,10,15]);
    }
    %translate([4.5,28,0])
    rotate([0,0,90])
    do_rack(1);
}

module _endstop_body(width, length, height, holes=true) {
    difference() {
        rounded_cube(width,length,height,3);
        translate([(width-20+slop)/2,0,height-10]) {
            translate([0,-1.5,2])
            cube([20+slop,12,6+2*slop]);

            translate([1,-4,4])
            cube([18+slop,length+5,8+3*slop]);

            translate([0.3,5,2+slop])
            cube([4, length-1, 5.9]);

            translate([8.8,5,2+slop])
            cube([4, length-1, 5.9]);

            translate([17,5,2+slop])
            cube([3, length-1, 5.9]);

            if (holes == true) {
                translate([5+slop/2, 7.4, -5])
                cylinder(d=2, h=15, $fn=30);

                translate([15+slop/2, 7.4, -5])
                cylinder(d=2, h=15, $fn=30);
            }
        }
    }
}

//translate([30,0,0])
//_endstop_body(25,10,10);

module xy_endstop_racktop() {
    l = 10;
    rotate([270,0,0])
    translate([0,-12,0])
    union() {
        difference() {
            _endstop_body(25,12,l,true);
            //rounded_cube(25,12,l,3);

            translate([14,3.98,-7.15])
            rotate([0,0,-90])
            do_rack(1);
        }
        intersection() {
            translate([5,15,2.25])
            rotate([0,180,0])
            long_tie_split();

            translate([-3,0,-4.5])
            cube([switch_length+6,12,6]);
        }
        %translate([2.5+slop/2,13.3-3+slop/2,8.2])
        rotate([180,0,0])
        mechanical_endstop();
    }
    %translate([14,-7,27])
    rotate([0,-90,-90])
    do_rack(1);
}

module z_endstop() {
    difference() {
        union() {
            translate([0,0,19])
            rotate([-90,0,0])
            _endstop_body(27,19,9.5,holes=true);

            rotate([0,0,90])
            translate([0,-27/2,0])
            long_tie_half(27);

            translate([0,-0.1,0])
            cube([27,2,2.5]);
        }
        translate([0,2,0])
        rotate([-40,0,0])
        cube([28,7,20]);
    }
    %translate([3.5+slop,7.5+slop,8.5])
    rotate([90,0,0])
    mechanical_endstop();
}

module xy_endstop_rackend() {
    l = 21;
    difference() {
        translate([0.5,0,12])
        rotate([-90,0,0])
        _endstop_body(29,12,l,true);

        translate([15.8,11.9,12.5])
        rotate([90,0,0])
        linear_extrude(13)
        polygon(points=[[0,2], [10,2], [10,0], [5,-2.9], [0,0]]);

        translate([5.8,0,12.2]) rotate([-90,0,0]) scale([1.03,1,1])
        male_dovetail(8.8);

        translate([23.8,0,12.2])
        rotate([-90,0,0])
        scale([1.03,1,1])
        male_dovetail(6.6);
    }
    
    %translate([5+slop,l-2+slop/2,1.6])
    rotate([90,0,0])
    mechanical_endstop();

    %translate([14.8,3.98,27])
    rotate([0,-90,-90])
    do_rack(1);
}


