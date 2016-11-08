include <include.scad>;
include <globals.scad>;
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
    translate([-3,-2,switch_depth+2]) #cube([4,9,1]);
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
}

//endstop_v1();
endstop_v2();