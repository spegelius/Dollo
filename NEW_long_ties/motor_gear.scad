include <globals.scad>;
include <include.scad>;
use <../snappy-reprap/publicDomainGearV1.1.scad>;

//globals
$fn=50;
obj_round = 50;
 // based on obj_height = 50 / twist=81
//obj_height = 20;

shaft = motor_shaft_hole_dia;

shaft_len = 22;
shaft_has_flat = true;
shaft_flat_len = 15;

function get_twist(obj_height, twist_ratio) = (twist_ratio == 1) ? 1 : obj_height * twist_ratio;

module gear_master(obj_height, twist_ratio){

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
            twist = get_twist(obj_height, twist_ratio);
            echo(twist);
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

module bolt_hole(bolt_size, obj_height) {
    hole_pos = shaft_len - shaft_flat_len + shaft_flat_len/2;
    translate([0, 0, obj_height/2-hole_pos]) rotate([0,90,0]) cylinder(d=bolt_size, h=10);
}

module flat_of_shaft(obj_height) {
    if (shaft_has_flat) {
        translate([shaft/2-0.5,-2.5,-obj_height/2]) cube([1.5,5,obj_height-(shaft_len-shaft_flat_len)], center=false);
    }
}

// flat body
module nogear(height, diameter=10) {
    difference() {
        cylinder(d=diameter, h=height);
        hole(height);
    }
}

module motor_gear(nut_size=m3_nut_side, nut_height=m3_nut_height, bolt_size=bolt_hole_dia) {
    difference() {
        union() {
            difference() {
                union() {
                    nogear(8, 16);
                    translate([0,0,11]) gear (
                        mm_per_tooth    = 5,
                        number_of_teeth = 8,
                        thickness       = 6,
                        hole_diameter   = 2,
                        twist           = 25.9808,
                        teeth_to_hide   = 0,
                        pressure_angle  = 20,
                        backlash        = slop/2
                    );
                    translate([0,0,17]) mirror([0,1,0]) rotate([0,0,25.9808]) gear (
                        mm_per_tooth    = 5,
                        number_of_teeth = 8,
                        thickness       = 6,
                        hole_diameter   = 2,
                        twist           = 25.9808,
                        teeth_to_hide   = 0,
                        pressure_angle  = 20,
                        backlash        = slop/2
                    );
                    translate([0,0,8]) cylinder(d=motor_shaft_hole_dia+2, h=12);
                }
                translate([0,0,8]) hole(14);
                union() {
                    difference() {
                        translate([0,0,20.5]) cylinder(h=3, d=20, center=true);
                        translate([0,0,19.5]) cylinder(h=2+0.05, d1=20, d2=8, center=true);
                    }
                }
            }
            translate([0,0,15.56]) flat_of_shaft(23);
        }
        translate([0,0,8]) bolt_hole(bolt_size-0.15, 21);
        #translate([shaft/2+0.5,-(nut_size)/2,0]) cube([nut_height+slop, nut_size, 7.5]);
    }
}

motor_gear();