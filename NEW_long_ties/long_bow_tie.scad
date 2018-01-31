
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

module split() {
    translate([0,0,-1]) linear_extrude(height=length+2) polygon(points=[[0,-1], [1,-1], [2.1,-5], [-2.1,-5], [-1,-1]]);
}

module long_bow_tie_split(length) {
    translate([0,0,male_dove_depth-slop]) rotate([90,0,0]) difference() {
        translate([0,-(male_dove_depth-slop),0]) rotate([-90,0,0]) long_bow_tie(length);
        split();
        rotate([0,0,180]) split();
    }
}

//long_bow_tie(length);
long_bow_tie_split(length);