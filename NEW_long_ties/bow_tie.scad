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
module bow_tie_master(){
	union(){
		intersection(){
            union() {
                intersection(){
                    rotate([0,-45,0]) cube([obj_leg,obj_leg,obj_leg]);
                    translate([-obj_leg/2,(obj_leg/2)-tilt_level,-5]) rotate([45,0,0]) cube([obj_leg,obj_leg,obj_leg*2]);
                }
                mirror([0,1,0]) intersection(){
                    rotate([0,-45,0]) cube([obj_leg,obj_leg,obj_leg]);
                    translate([-obj_leg/2,(obj_leg/2)-tilt_level,-5]) rotate([45,0,0]) cube([obj_leg,obj_leg,obj_leg*2]);
                }
            }
			rotate([-90,0,0]) translate([0,0,-scale_z*male_dove_depth]) long_bow_tie_split(length, scale_x=scale_x, scale_z=scale_z);
		}
	}
}
module bow_holes() {
	translate([-10,-2.5,-2.5]) rotate([0,90,0]) #cylinder(h=50, d=1.5);
	translate([-10,2.5,-2.5]) rotate([0,90,0]) #cylinder(h=50, d=1.5);
}

module bow_tie(brim=false){
	translate([0,0,13]) rotate([0,45*0,0]){
		difference(){
			rotate([0,180,0]) bow_tie_master();
			//bow_holes();
            translate([0,5,-4]) rotate([90,0,0]) cylinder(d=2.5, h=50);
		}
	}
    if (brim) {
        translate([-5,-6,0]) cube([10,12,.2]);
    }
}

//bow_tie();
bow_tie(brim=true);
