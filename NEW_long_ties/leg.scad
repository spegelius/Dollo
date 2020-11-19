include <globals.scad>;
include <include.scad>;

use <cable_clip.scad>;
use <extention.scad>;
use <mockups.scad>;
use <z_coupler.scad>;
use <z_screw.scad>;


////// VARIABLES //////

// core settings
pitch = 3;
dia_adjustable_inner = sqrt(30*30*2) + pitch+0.5;
dia_adjustable_outer = dia_adjustable_inner + slop;
screw_steps = 100;


////// VIEW //////
debug_leg_z();

//leg();
//leg_z();
//foot();
//foot_small();
//foot_adjustable_core();
//foot_adjustable();
//foot_dampener();


////// MODULES //////
module _plate(length=40, height=10) {
    hull() {
        translate([0,0,0])
        cube([30,length,height/2]);

        translate([7.5,0,height/2])
        cube([15,length,height/2]);
    }
}

module _leg(units) {
    
    intersection() {
        translate([30/2,-30/2+30,units*30/2])
        extention(units=units+1);

        cube([31,31,30*(units+1)]);
    }
}

module leg(plate_len=50, units=3) {
    difference() {
        union() {
            translate([0, 20, 0])
            _plate(plate_len);

            translate([20, 30, 0])
            rotate([0,0,-90])
            _plate(plate_len);

            _leg(units);

            // hole bridge
            translate([10,10,male_dove_depth+0.2])
            cube([10,10,0.2]);
        }
        dove_len = plate_len+30;

        translate([15,plate_len+20,-0.01])
        rotate([90,0,0])
        male_dovetail(dove_len, bridge_extra=0.2);

        translate([0,15,-0.01])
        rotate([90,0,90])
        male_dovetail(dove_len, bridge_extra=0.2);
    }
}

module leg_z() {

    module _z_leg() {
        difference() {
            union() {
                translate([0,0,30])
                extention(2);

                translate([0,0,38])
                hull() {
                    cube([30,30,1],center=true);

                    translate([0,0,15/2+10])
                    cube([motor_side_length+8,
                          motor_side_length+8,
                          13],center=true);
                }
            }
            translate([0,0,50+1/2])
            hull() {
                cube([motor_side_length,motor_side_length,1],center=true);

                translate([0,0,30])
                cube([motor_side_length-2,motor_side_length-2,1],center=true);
            }

            translate([0,0,50+30/2])
            hull() {
                cube([motor_side_length-8,motor_side_length-8,30],center=true);
                cylinder(d=9,h=60,center=true);
            }

            translate([0,motor_side_length/2,50+15/2])
            cube([17,10,15],center=true);

            translate([-motor_side_length/2,30/2+15/2,50+15/2])
            cube([10,30,15],center=true);

            translate([-20/2-15/2,-30/2-15/2,50+15/2])
            cube([20,30,15],center=true);

            translate([motor_side_length/2,30/2+15/2,50+15/2])
            cube([10,30,15],center=true);

            translate([20/2+15/2,-30/2-15/2,50+15/2])
            cube([20,30,15],center=true);

            translate([0,0,50+20/2+7.5])
            chamfered_cube(motor_side_length+2,
                           motor_side_length+2,
                           20,5,center=true);

            // extra infill
            #translate([motor_side_length/2+8/4,5,48])
            cylinder(d=0.1,h=15);

            #translate([motor_side_length/2+8/4,2,48])
            cylinder(d=0.1,h=15);

            #translate([motor_side_length/2+8/4,-2,48])
            cylinder(d=0.1,h=15);

            #translate([motor_side_length/2+8/4,-5,48])
            cylinder(d=0.1,h=15);

            #translate([-motor_side_length/2-8/4,5,48])
            cylinder(d=0.1,h=15);

            #translate([-motor_side_length/2-8/4,2,48])
            cylinder(d=0.1,h=15);

            #translate([-motor_side_length/2-8/4,-2,48])
            cylinder(d=0.1,h=15);

            #translate([-motor_side_length/2-8/4,-5,48])
            cylinder(d=0.1,h=15);

            #translate([5,-motor_side_length/2-8/4,48])
            cylinder(d=0.1,h=15);

            #translate([2,-motor_side_length/2-8/4,48])
            cylinder(d=0.1,h=15);

            #translate([-2,-motor_side_length/2-8/4,48])
            cylinder(d=0.1,h=15);

            #translate([-5,-motor_side_length/2-8/4,48])
            cylinder(d=0.1,h=15);

            #translate([14,motor_side_length/2+8/4,48])
            cylinder(d=0.1,h=15);

            #translate([11,motor_side_length/2+8/4,48])
            cylinder(d=0.1,h=15);

            #translate([-14,motor_side_length/2+8/4,48])
            cylinder(d=0.1,h=15);

            #translate([-11,motor_side_length/2+8/4,48])
            cylinder(d=0.1,h=15);
        }
    }

    intersection() {
        _z_leg();

        rotate([0,0,45])
        chamfered_cube(56,56,200,10,center=true);
    }
}

function bottom_hole_x_pos(dia) = dia/2-(dia/2/3);

module _bottom_holes(dia=60, sphere_d=6) {

    x_pos = bottom_hole_x_pos(dia);
    union() {
        for(i=[0:3]) {
            rotate([0,0,i*360/4])
            translate([x_pos,0,-1])
            cylinder(d=sphere_d-1, h=3, $fn=20);

            rotate([0,0,i*360/4])
            translate([x_pos,0,2])
            sphere(d=sphere_d, $fn=20);
        }
        difference() {
            cylinder(d=x_pos*2+1,h=1.5,$fn=40);
            cylinder(d=x_pos*2-1,h=1.6,$fn=40);
        }
    }
}

module foot(dia=60) {

    z = 20 - dia/2;
    difference() {
        intersection() {
            translate([0,0,z])
            sphere(d=dia, $fn=90);

            translate([0,0,6])
            cube([80,80,12], center=true);
        }
        cylinder(d=metal_rod_size,h=40, $fn=40);
        translate([0,0,12])
        rotate([-90,0,0])
        tie_end(30);

        for(i=[0:3]) {
            rotate([0,0,45+i*360/4])
            translate([0,-15,0]) male_dovetail(30);
        }
        _bottom_holes(dia);
        %translate([0,0,30])

        rotate([0,0,45])
        translate([0,0,-3])
        extention(1,support=false);
    }
}

module foot_small() {
    foot(dia=45);
}


module foot_adjustable_core() {

    difference() {
        v_screw(h=15,
                screw_d=dia_adjustable_inner,
                pitch=pitch,
                direction=0,
                steps=screw_steps);
        cylinder(d=metal_rod_size,h=40, $fn=40);
        translate([0,0,15])
        rotate([-90,0,0])
        tie_end(30);

        for(i=[0:3]) {
            rotate([0,0,45+i*360/4])
            translate([0,-15,0])
            male_dovetail(30);
        }
    }
    %translate([0,0,30])
    rotate([0,0,45])
    translate([0,0,0])
    extention(1,support=false);
}

module foot_adjustable() {
    difference() {
        intersection() {
            translate([0,0,6])
            sphere(d=dia_adjustable_outer+12,$fn=60);

            translate([0,0,22/2])
            cube([100,100,22],center=true);
        }
        translate([0,0,5])
        v_screw(h=20,
                screw_d=dia_adjustable_outer,
                pitch=pitch,
                direction=0,
                steps=screw_steps);
        cylinder(d=(dia_adjustable_outer+10)/2, h=10, $fn=60);

        x_offset = (dia_adjustable_outer+10)/2 + 5;
        _bottom_holes();
    }
}

module foot_dampener(dia=60) {
    x_pos = bottom_hole_x_pos(dia);

    difference() {
        union() {
            _bottom_holes(dia, sphere_d=5.5);
            translate([0,0,-1])
            cylinder(d=dia*0.9,h=1,$fn=50);
        }
        translate([0,0,-1])
        cylinder(d=x_pos*2-6,h=1,$fn=40);

        for(i = [0:3]) {
            rotate([0,0,i*360/4])
            translate([x_pos,0,0])
            cylinder(d=2, h=10, $fn=10);
        }
    }
}

module debug_leg_z() {
    intersection() {
        union() {
            leg_z();

            %translate([0,0,3*30-motor_height/2])
            rotate([90,0,0])
            mock_stepper_motor(geared=false, center=true);
        }
//        translate([-50/2,0,0])
//        cube([50,50,200],center=true);
    }
}
