
tilt_level = 1.1;

include <include.scad>;
include <globals.scad>;

obj_leg = 12;

function scale_x() = 1;
function scale_z() = (male_dove_depth-0.2)/male_dove_depth;

length = 50;

module bow_tie_master(length){
	union(){
		mirror([0,1,0])	dovetail_3d(male_dove_max_width, male_dove_min_width, male_dove_depth, length);
		dovetail_3d(male_dove_max_width, male_dove_min_width, male_dove_depth, length);
	}
}

module long_bow_tie_unscaled(length) {

    module endcyl() {
        translate([0,0,-3]) cylinder(d=24, h=6, $fn=60);
    }

    module endtub() {
        rotate([0,90,0]) translate([0,0,-15/2]) difference() {
            cylinder(d=20, h=15, $fn=60);
            cylinder(d=12, h=16, $fn=60);
            translate([-20,0,-0.1]) cube([40,20,16]);
        }
    }

    translate([0,0,male_dove_depth]) difference() {
        intersection(){
            rotate([90,0,0]) bow_tie_master(length);
            rotate([90,0,0]) cylinder(r=5.8, h=200);
        }
        translate([13,5,0]) rotate([90,0,25]) endcyl();
        translate([-13,5,0]) rotate([90,0,-25]) endcyl();
        translate([13,-length-5,0]) rotate([90,0,-25]) endcyl();
        translate([-13,-length-5,0]) rotate([90,0,25]) endcyl();

        translate([0,-length+4.5,0]) endtub();
        translate([0,-4.5,0]) rotate([180,0,0]) endtub();
    }
}

module long_bow_tie(length=length, scale_x=scale_x(), scale_z=scale_z()) {
    scale([scale_x, 1, scale_z]) long_bow_tie_unscaled(length);
}

module split(length) {
    translate([0,0,-1]) linear_extrude(height=length+2) polygon(points=[[0,-1], [1,-1], [2.1,-5], [-2.1,-5], [-1,-1]]);
}

module long_bow_tie_split(length=length, scale_x=scale_x(), scale_z=scale_z()) {
    translate([0,0,scale_z*male_dove_depth]) rotate([90,0,0]) difference() {
        translate([0,-(scale_z*male_dove_depth),0]) rotate([-90,0,0]) long_bow_tie(length);
        split(length);
        rotate([0,0,180]) split();
    }
}

module long_bow_tie_half(length=length, scale_x=scale_x(), scale_z=scale_z()) {
    rotate([0,-90,0]) intersection() {
        long_bow_tie(length);
        translate([0,-length,-1]) cube([6, length, 12]);
    }
}

long_bow_tie();
//long_bow_tie(25);
//long_bow_tie_half(length);
//long_bow_tie_split(length);