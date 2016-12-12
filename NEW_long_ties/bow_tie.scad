smoothing = 100;
length = 13;
tilt_level = 1.1;
include <include.scad>;
include <globals.scad>;
use <long_bow_tie_experimental.scad>;

obj_leg= 12;
$fn = smoothing;
module bow_tie_master(){
	union(){
		intersection(){
            union() {
                intersection(){
                    rotate([0,-45,0]) cube([obj_leg,obj_leg,obj_leg]);
                    translate([-obj_leg/2,(obj_leg/2)-tilt_level,-5]) rotate([45,0,0]) cube([obj_leg,obj_leg,obj_leg*2]);
                    translate([0,length/4,length*.5]) rotate([45,0,0]) sphere(d=length*tilt_level);
                }
                mirror([0,1,0]) intersection(){
                    rotate([0,-45,0]) cube([obj_leg,obj_leg,obj_leg]);
                    translate([-obj_leg/2,(obj_leg/2)-tilt_level,-5]) rotate([45,0,0]) cube([obj_leg,obj_leg,obj_leg*2]);
                    translate([0,length/4,length*.5]) rotate([45,0,0]) sphere(d=length*tilt_level);
                }
            }
			rotate([-90,0,0]) long_bow_tie_split(length);
		}
	}
}
module bow_holes() {
	translate([-10,-2.5,-2.5]) rotate([0,90,0]) #cylinder(h=50, d=1.5);
	translate([-10,2.5,-2.5]) rotate([0,90,0]) #cylinder(h=50, d=1.5);
}

module finished(){
	rotate([0,45*0,0]){
		difference(){
			rotate([0,180,0]) bow_tie_master();
			//bow_holes();
            #translate([0,5,-4]) rotate([90,0,0]) cylinder(d=2.5, h=50);
		}
	}
}

finished();
