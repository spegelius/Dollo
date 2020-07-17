include <globals.scad>;
include <include.scad>;
use <../snappy-reprap/publicDomainGearV1.1.scad>;
use <mockups.scad>;

////// VARIABLES //////
$fn=50;
obj_round = 50;
 // based on obj_height = 50 / twist=81
//obj_height = 20;

shaft = motor_shaft_hole_dia;

shaft_len = 22;
shaft_has_flat = true;
shaft_flat_len = 15;

// gear
twist = 25.9808;
twist_constant = rack_h/2/twist;
echo (6.4/twist_constant);

////// VIEW //////
//debug();

//motor_gear();
motor_gear(shaft_slop=0.1);


////// MODULES //////
function get_twist(obj_height, twist_ratio) = (twist_ratio == 1) ? 1 : obj_height * twist_ratio;

// deprecated
module gear_master(obj_height, twist_ratio){
	module rightGear(twist, obj_height) {
		rotate([0, 0, -25]) {
			translate([0, 0, obj_height/4])
			linear_extrude(height=obj_height/2,
                           center=true,
                           twist=twist,
                           convexity = 10)
			import(file="small_gear.dxf", layer="Layer_1");

			circle(r = 1);
		}
	}

    module gearObject(obj_height) {

        module gear(twist, obj_height) {
            union() {
                rightGear(twist, obj_height);

                mirror([0,0,1])
                rightGear(twist, obj_height);
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

// shaft hole
module hole(obj_height) {
    cylinder(d=shaft, h=obj_height*2.1, center=true);
}

module bolt_hole(bolt_size, obj_height) {

    rotate([0,90,0])
    cylinder(d=bolt_size, h=20, center=true);

    translate([18/2-2.3,0,0])
    rotate([0,90,0])
    cylinder(d1=3,d2=7.8,h=2.4,$fn=30);

    translate([-18/2+2.3,0,0])
    rotate([0,-90,0])
    cylinder(d1=3,d2=7.8,h=2.4,$fn=30);
}


module motor_gear(nut_size=m3_nut_side,
                  nut_height=m3_nut_height,
                  bolt_size=bolt_hole_dia,
                  shaft_slop=0) {

    difference() {
        difference() {
            union() {
                // bottom body
                hull() {
                    translate([0,0,1])
                    cylinder(d=18, h=6.61);

                    cylinder(d=16, h=8.61);
                }

                // lower gear half
                translate([0,0,11.8])
                rotate([0,0,1.8])
                gear (
                    mm_per_tooth    = rack_tooth,
                    number_of_teeth = 8,
                    thickness       = 6.4,
                    hole_diameter   = 2,
                    twist           = 6.4/twist_constant,
                    teeth_to_hide   = 0,
                    pressure_angle  = 19,
                    backlash        = 0
                );

                // upper gear half
                translate([0,0,17.99])
                mirror([0,1,0])
                rotate([0,0,25.9808])
                gear (
                    mm_per_tooth    = rack_tooth,
                    number_of_teeth = 8,
                    thickness       = 6,
                    hole_diameter   = 2,
                    twist           = twist,
                    teeth_to_hide   = 0,
                    pressure_angle  = 19,
                    backlash        = 0
                );

                // internal body
                translate([0,0,7])
                cylinder(d=motor_shaft_hole_dia+4.6, h=13.99);

                // smol internal body
                translate([0,0,7])
                cylinder(d=motor_shaft_hole_dia+3, h=14.99);
            }
            translate([0,0,-0.1])
            rotate([0,0,-90])
            motor_shaft(h=22, extra_slop=shaft_slop);

            cylinder(d1=5.6,d2=5,h=0.6,$fn=40);

            union() {
                difference() {
                    translate([0,0,21.5])
                    cylinder(h=3, d=20, center=true);

                    translate([0,0,20.5])
                    cylinder(h=2+0.05, d1=20, d2=8, center=true);
                }
            }
        }
        translate([0,0,5])
        bolt_hole(bolt_size-0.15, 21);

        translate([shaft/2+0.8,0,4/2+1])
        rotate([0,90,0])
        elongated_nut(4, cone=false);

        translate([-shaft/2-0.8-nut_height,0,4/2+1])
        rotate([0,90,0])
        elongated_nut(4, cone=false);
    }
}

module debug() {
    rotate([90,0,0])
    mock_stepper_motor(center=true);

    translate([0,0,22])
    intersection() {
        rotate([0,0,90])
        motor_gear(shaft_slop=0.1);

        translate([30/2,0,30/2])
        cube([30,30,30],center=true);
    }
}
