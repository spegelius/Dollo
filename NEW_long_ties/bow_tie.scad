smoothing = 50;
tilt_level = 1.1;
include <include.scad>;
include <globals.scad>;
use <long_bow_tie.scad>;

// alter these the get properly fitting parts
scale_x = scale_x();
scale_z = scale_z();
length = 13;

obj_leg= 12;
$fn = smoothing;

module bow_tie_master() {
    side = sqrt(13*13*2);
	union(){
		intersection(){
            translate([0,0,0]) rotate([0,45,0]) cube([side,side,side],center=true);
            union() {
                rotate([-90,0,0]) translate([0,-length/2,0]) long_bow_tie_split(length, scale_x=scale_x, scale_z=scale_z,middle=true);
                translate([0,0,13-3.8]) rotate([90,0,90]) cylinder(d=4.5, h=4, center=true);
            }
            cube([20,20,22.5],center=true);
		}
	}
}

module bow_tie(brim=false){
    difference(){
        bow_tie_master();
        translate([0,0,13-3.8]) rotate([90,0,90]) cylinder(d=2.5, h=50, center=true);
	}
    if (brim) {
        translate([-5,-6,0]) cube([10,12,.2]);
    }
}

bow_tie();
//bow_tie(brim=true);
