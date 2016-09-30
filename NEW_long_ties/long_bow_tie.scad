
length = 50;
tilt_level = 1.1;
scaling_x = .95;
scaling_y = 1;
scaling_z = 1;

include <include.scad>;
include <globals.scad>;

obj_leg = 12;

module bow_tie_master(lngth=length){
	union(){
		mirror([0,1,0])	male_dovetail(height=lngth);
		male_dovetail(height=lngth);
	}
}

module long_bow_tie (lngth=length, scale_x=scaling_x, scale_y=scaling_y, scale_z=scaling_z ) {
    translate([0,0,scale_z*5]) intersection(){
        scale([scale_x,scale_y,scale_z]) rotate([90,0,0]) bow_tie_master(lngth);
        rotate([90,0,0]) cylinder(r=5.7, h=200);
    }
}

long_bow_tie();
