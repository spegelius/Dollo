
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

    translate([0,length/2,0]) difference() {
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

module long_bow_tie(length=length, scale_x=scale_x(), scale_z=scale_z(),middle=false) {
    scale([scale_x, 1, scale_z]) {
        if(middle)
            long_bow_tie_unscaled(length);
        else
            translate([0,0,male_dove_depth]) long_bow_tie_unscaled(length);
    }
}

module split(length) {
    translate([0,0,-length/2-1]) linear_extrude(height=length+2) polygon(points=[[0,-1], [1,-1], [2.1,-5], [-2.1,-5], [-1,-1]]);
}

module long_bow_tie_split(length=length, scale_x=scale_x(), scale_z=scale_z(),middle=false) {
    module _do_split() {
        rotate([90,0,0]) difference() {
            rotate([-90,0,0]) long_bow_tie(length,scale_x=scale_x,scale_z=scale_z,middle=true);
            split(length);
            rotate([0,0,180]) split(length);
        }
    }
        
    if (!middle) 
        translate([0,0,scale_z*male_dove_depth]) _do_split();
    else
        _do_split();
}

module long_bow_tie_half(length=length, scale_x=scale_x(), scale_z=scale_z(),middle=true) {
    rotate([0,-90,0]) intersection() {
        long_bow_tie(length,middle=middle);
        translate([0,-length/2,-24/2]) cube([8, length, 24]);
    }
}

module long_bow_tie_half_split(length=length, scale_x=scale_x(), scale_z=scale_z()) {
    union() {
        intersection() {
            long_bow_tie_split(length,scale_x=scale_x,scale_z=scale_z,middle=true);
            translate([0,0,-6/2]) cube([10,length,6],center=true);
        }
        cube([scale_x*male_dove_min_width,length,1.6],center=true);
        translate([((scale_x*male_dove_min_width)/2)/2,0,4/2]) cube([(scale_x*male_dove_min_width)/2,length,4],center=true);
        translate([0,0,4]) intersection() {
            long_bow_tie(length,scale_x=scale_x,scale_z=scale_z,middle=true);
            translate([5/2,0,5/2]) cube([5,length,5],center=true);
        }
    }
}

//long_bow_tie();
//long_bow_tie(25);
//long_bow_tie_half(length);
//long_bow_tie_half(30);
//long_bow_tie_split(length);
long_bow_tie_half_split(length);