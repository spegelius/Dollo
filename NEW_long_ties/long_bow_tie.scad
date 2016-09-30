
length = 50;
tilt_level = 1.1;
scaling_x = .95;
scaling_y = 1;
scaling_z = 1;

include <include.scad>;
include <globals.scad>;

obj_leg = 12;

module bow_tie_master(length=length){
	union(){
		mirror([0,1,0]){
			male_dovetail(height=length);
		}
			male_dovetail(height=length);		
	}
}

module long_bow_tie (length=length, scaling_x=scaling_x, scaling_y=scaling_y, scaling_z=scaling_z ) {
    translate([0,0,scaling_z*5)]) intersection(){
        scale([scaling_x,scaling_y,scaling_z])	rotate([90,0,0]) bow_tie_master(length);
        rotate([90,0,0]) cylinder(r=5.7, h=200);
    }
}

long_bow_tie();