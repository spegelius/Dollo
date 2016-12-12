
tilt_level = 1.1;

include <include.scad>;
include <globals.scad>;

obj_leg = 12;

max_width=scaled_male_dove_max_width();
min_width=scaled_male_dove_min_width();
depth=scaled_male_dove_depth();
length = 50;

module bow_tie_master(length){
	union(){
		mirror([0,1,0])	dovetail_3d(max_width, min_width, depth, length);
		dovetail_3d(max_width, min_width, depth, length);
	}
}

module long_bow_tie(length) {
    translate([0,0,depth]) intersection(){
        rotate([90,0,0]) bow_tie_master(length);
        rotate([90,0,0]) cylinder(r=5.8, h=200);
    }
}

long_bow_tie(length);
