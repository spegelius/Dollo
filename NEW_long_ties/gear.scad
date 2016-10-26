include <globals.scad>;
include <include.scad>;

//globals
$fn=50;
obj_round = 50;
twist_ratio = 1.62; // based on obj_height = 50 / twist=81
//obj_height = 20;

shaft = motor_shaft_hole_dia;

shaft_len = 22;
shaft_has_flat = true;
shaft_flat_len = 15;

module gear_master(obj_height){

	module rightGear(twist, obj_height) {
		rotate([0, 0, -25]) {
			translate([0, 0, obj_height/4])
			linear_extrude(height = obj_height/2, center = true, twist = twist, convexity = 10)
			    import (file = "small_gear.dxf", layer = "Layer_1");
			circle(r = 1);
		}
	}

    module gearObject(obj_height) {

        module gear(twist, obj_height) {

            union() {
                rightGear(twist, obj_height);
                mirror([0,0,1]) rightGear(twist, obj_height);
            }

        }

        module bone(obj_height) {
            twist=obj_height * twist_ratio;
            difference() {
                gear(twist, obj_height);
                hole(obj_height);
            }
        }
        bone(obj_height);
    }
    
    gearObject(obj_height);
}

module hole(obj_height) {
    cylinder(d=shaft, h=obj_height*2.1, center=true);
}

module bolt_hole(obj_height) {
    hole_pos = shaft_len - shaft_flat_len + shaft_flat_len/2;
    translate([0, 0, obj_height/2-hole_pos]) rotate([0,90,0]) cylinder(d=2.5, h=10);
}

module flat_of_shaft(obj_height) {
    if (shaft_has_flat) {
        translate([5.6/2-0.7,-2.5,-obj_height/2]) cube([1.5,5,obj_height-(shaft_len-shaft_flat_len)], center=false);
    }
}

// original style gear. tune height if so inclined; longer gear seems to cause uneven movement, though...
module gear_v1() {
    difference() {
        union() {
            flat_of_shaft(22);
            gear_master(22);
        }
        #bolt_hole(22);
    }
}

// flat body
module nogear(height) {
    difference() {
        cylinder(d=10, h=height);
        hole(height);
    }
}

// v2 is to be used with the new style rack
module gear_v2() {
    
    mirror([0,1,0]) difference() {
        union() {
            translate([0,0,12/2+(12-20)/2]) nogear(8);
            translate([0,0,6]) flat_of_shaft(22);
            translate([0,0,(12-20)/2]) gear_master(12);
        }
        translate([0,0,9]) #bolt_hole(20);
    }
}
//gear_v1();
gear_v2();