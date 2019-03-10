
include <globals.scad>;
use <include.scad>;

prox_sensor_dia = 18;
prox_sensor_washer_dia = 30;

// LJ18A3-8-Z/BX
module proximity_sensor(nut_position=30, nut_gap=10) {
    
    module mount_nut() {
        color("Silver") difference() {
            cylinder(d=23.7, h=3.5, $fn=6);
            cylinder(d=17.9, h=3.6, $fn=50);
        }
    }
    
    color("Orange") cylinder(d=16.32, h=8.9, $fn=50);
    translate([0,0,8.9]) color("Silver") cylinder(d=prox_sensor_dia, h=47.1, $fn=50);
    translate([0,0,8.9+47.1]) color("LightGrey") cylinder(d=17, h=13.8, $fn=50);
    
    translate([0,0,nut_position]) mount_nut();
    color("LightGrey") translate([0,0,nut_position+3]) cylinder(d=prox_sensor_washer_dia,h=1.5);
    
    translate([0,0,nut_position+3+1.5+1.5+nut_gap]) mount_nut();
    color("LightGrey") translate([0,0,nut_position+3+1.5+nut_gap]) cylinder(d=prox_sensor_washer_dia,h=1.5);
    
    
}

module e3dv6() {
    
    module nozzle() {
        hull() {
            cylinder(d=1, h=1, $fn=30);
            translate([0,0,2]) cylinder(d=3, h=1, $fn=30);
        }
        translate([0,0,2]) cylinder(d=7,h=2.5, $fn=6);
        translate([0,0,4.5]) cylinder(d=4,h=2, $fn=30);
    }
    
    module heater_block() {
        color("LightGrey") {
            translate([-8, -8, 0]) cube([16,23,11.5]);
            cylinder(d=5,h=15, $fn=30);
        }
    }
    
    heatsink_step = 2.5;
    heatsink_h = 12*heatsink_step;
    
    module heatsink() {
        color("LightGrey") {
            cylinder(d1=12,d2=10,h=heatsink_h, $fn=50);
            for (i = [0:10]) {
                translate([0,0,i*heatsink_step]) cylinder(r=11.2, h=1, $fn=50);
            }
            translate([0,0,11*heatsink_step]) cylinder(d=16,h=1, $fn=50);
        }
    }
    
    module neck() {
        color("LightGrey") {
            $fn=50;
            cylinder(d=16, h=3);
            translate([0,0,3]) cylinder(d=12, h=6);
            translate([0,0,9]) cylinder(d=16, h=3.7);
        }
    }
    nozzle();
    translate([0,0,5]) heater_block(); 
    translate([0,0,19.6]) heatsink();
    translate([0,0,19.6+heatsink_h]) neck();
}

module prometheus() {

    module nozzle() {
        hull() {
            cylinder(d=1, h=1, $fn=30);
            translate([0,0,2]) cylinder(d=3, h=1, $fn=30);
        }
        translate([0,0,2]) cylinder(d=7,h=2.5, $fn=6);
        translate([0,0,4.5]) cylinder(d=4,h=2, $fn=30);
    }

    module heater_block() {
        color("LightGrey") {
            translate([-8, -8, 0]) cube([16,23,11.5]);
            cylinder(d=5,h=15, $fn=30);
        }
    }
    
    module heatsink() {
        intersection() {
            color("LightGrey") {
                cylinder(d=10,h=28, $fn=50);
                for (i = [0:9]) {
                    translate([0,0,i*2.5]) cylinder(r=15, h=1, $fn=50);
                }
                translate([0,0,25]) cylinder(d=16,h=1, $fn=50);
            }
            translate([0,0,40/2]) cube([30,20,40], center=true);
        }
    }
    
    module neck() {
        color("LightGrey") {
            $fn=50;
            cylinder(d=16, h=3);
            translate([0,0,3]) cylinder(d=12, h=6);
            translate([0,0,9]) cylinder(d=16, h=3.7);
        }
    }
    nozzle();
    translate([0,0,5]) heater_block();
    translate([0,0,18]) heatsink();
    translate([0,0,62.3-16.7]) neck();
}

// SS-5GL13
module mechanical_endstop() {
    difference() {
        color("black") cube([20, 11, 6]);
        translate([5, 3, -0.1]) cylinder(d=2, h=7, $fn=20);
        translate([20-5, 3, -0.1]) cylinder(d=2, h=7, $fn=20);
    }
    translate([0,11,1]) rotate([0,0,15]) color("grey") cube([19,0.5,4]);
    translate([1.5,-4,1]) color("grey") cube([0.5, 4, 4]);
    translate([10.5,-4,1]) color("grey") cube([0.5, 4, 4]);
    translate([20-1.5,-4,1]) color("grey") cube([0.5, 4, 4]);
    
}

module mock_stepper_motor(geared=false) {
    difference() {
        union() {
            intersection() {
                translate([0,0,42/2]) cube([42,40,42], center=true);
                translate([0,0,42/2]) rotate([0,45,0]) cube([54,40,54], center=true);
            }
            if (geared) {
                translate([0,40/2,42/2]) rotate([-90,0,0]) cylinder(d=37.2, h=26.5);
                translate([0,40/2+26.5,42/2]) rotate([-90,0,0]) motor_shaft(22, $fn=40);
            } else {
                translate([0,40/2,42/2]) rotate([-90,0,0]) cylinder(d=22, h=2);
                translate([0,40/2+2,42/2]) rotate([-90,0,0]) motor_shaft(22, $fn=40);
            }
        }
        translate([0,40/2,42/2]) rotate([90,0,0]) for (i=[0:3]) {
            rotate([0,0,i*(360/4)]) translate([motor_bolt_hole_distance/2,motor_bolt_hole_distance/2,-1]) cylinder(d=bolt_hole_dia, 7, $fn=20);
        }
    }
}

module frame_mockup(bed_angle=45, units_x=1, units_y=1, units_z=1) {
    corner_side = 60;
    unit = 120;
    unit_len_x = units_x*unit;
    unit_len_y = units_y*unit;
    unit_len_z = units_z*unit;
    z = 2*corner_side + unit_len_z - 30;
    
    module corner() {
        difference() {
            union() {
                cube([30,30,corner_side]);
                cube([30,corner_side,30]);
                cube([corner_side,30,30]);
            }
            translate([15,-0.01,0]) male_dovetail(corner_side+1);
            translate([-0.01,15,0]) rotate([0,0,-90]) male_dovetail(corner_side+1);
            translate([15,30.01,0]) rotate([0,0,180]) male_dovetail(corner_side+1);
            translate([30.01,15,0]) rotate([0,0,90]) male_dovetail(corner_side+1);
        }
    }
    
    module side(length) {
        difference() {
            cube([30,30,length]);
            translate([15,-0.01,0]) male_dovetail(corner_side+1);
            translate([-0.01,15,0]) rotate([0,0,-90]) male_dovetail(length+1);
            translate([15,30.01,0]) rotate([0,0,180]) male_dovetail(length+1);
            translate([30.01,15,0]) rotate([0,0,90]) male_dovetail(length+1);
        }
    }
    
    // corners
    %translate([-corner_side-unit_len_x/2, -corner_side-unit_len_y/2, 0]) corner();
    %mirror([1,0,0]) translate([-corner_side-unit_len_x/2, -corner_side-unit_len_y/2, 0]) corner();
    %mirror([0,1,0]) translate([-corner_side-unit_len_x/2, -corner_side-unit_len_y/2, 0]) corner();
    %mirror([0,1,0]) mirror([1,0,0]) translate([-corner_side-unit_len_x/2, -corner_side-unit_len_y/2, 0]) corner();
    
    // corners
    translate([0,0,2*corner_side + unit_len_z]) mirror([0,0,1]) {
        %translate([-corner_side-unit_len_x/2, -corner_side-unit_len_y/2, 0]) corner();
        %mirror([1,0,0]) translate([-corner_side-unit_len_x/2, -corner_side-unit_len_y/2, 0]) corner();
        %mirror([0,1,0]) translate([-corner_side-unit_len_x/2, -corner_side-unit_len_y/2, 0]) corner();
        %mirror([0,1,0]) mirror([1,0,0]) translate([-corner_side-unit_len_x/2, -corner_side-unit_len_y/2, 0]) corner();
    }

    // sides
    %translate([-corner_side-unit_len_x/2, unit_len_y/2, 0]) rotate([90,0,0]) side(unit_len_y);
    %mirror([1,0,0]) translate([-corner_side-unit_len_x/2, unit_len_y/2, 0]) rotate([90,0,0]) side(unit_len_y);
    %rotate([0,0,90]) translate([-corner_side-unit_len_y/2, unit_len_x/2, 0]) rotate([90,0,0]) side(unit_len_x);
    %mirror([0,1,0]) %rotate([0,0,90]) translate([-corner_side-unit_len_y/2, unit_len_x/2, 0]) rotate([90,0,0]) side(unit_len_x);
    
    // sides
    %translate([-corner_side-unit_len_x/2, unit_len_y/2, z]) rotate([90,0,0]) side(unit_len_y);
    %mirror([1,0,0]) translate([-corner_side-unit_len_x/2, unit_len_y/2, z]) rotate([90,0,0]) side(unit_len_y);
    %rotate([0,0,90]) translate([-corner_side-unit_len_y/2, unit_len_x/2, z]) rotate([90,0,0]) side(unit_len_x);
    %mirror([0,1,0]) %rotate([0,0,90]) translate([-corner_side-unit_len_y/2, unit_len_x/2, z]) rotate([90,0,0]) side(unit_len_x);

    %translate([-corner_side-unit_len_x/2, -corner_side-unit_len_y/2, corner_side]) side(unit_len_z);
    %mirror([1,0,0]) translate([-corner_side-unit_len_x/2, -corner_side-unit_len_y/2, corner_side]) side(unit_len_z);
    %mirror([0,1,0]) translate([-corner_side-unit_len_x/2, -corner_side-unit_len_y/2, corner_side]) side(unit_len_z);
    %mirror([0,1,0]) mirror([1,0,0]) translate([-corner_side-unit_len_x/2, -corner_side-unit_len_y/2, corner_side]) side(unit_len_z);
}

module bed_mk2(bed_angle=0) {
    // bed mk2
    bed_w = 214;
    hole_distance = 209;
    difference() {
        rotate([0,0,bed_angle]) cube([bed_w,bed_w,1], center=true);
        translate([-hole_distance/2,-hole_distance/2,0]) cylinder(d=3,h=2,center=true,$fn=20);
        translate([hole_distance/2,-hole_distance/2,0]) cylinder(d=3,h=2,center=true,$fn=20);
        translate([hole_distance/2,hole_distance/2,0]) cylinder(d=3,h=2,center=true,$fn=20);
        translate([-hole_distance/2,hole_distance/2,0]) cylinder(d=3,h=2,center=true,$fn=20);
    }
}

module mks_sbase_mockup() {
    w = 95;
    l = 146.5;
    h = 1.6;
    difference() {
        union() {
            rounded_cube_side(w, l, h, 2);
        }
        translate([4,4,0]) cylinder(d=3.6,h=5,center=true,$fn=20);
        translate([w-4,4,0]) cylinder(d=3.6,h=5,center=true,$fn=20);
        translate([w-4,l-4,0]) cylinder(d=3.6,h=5,center=true,$fn=20);
        translate([4,l-4,0]) cylinder(d=3.6,h=5,center=true,$fn=20);
    }
}

//mock_stepper_motor(false);
//mock_stepper_motor(true);

//mechanic_endstop();

//proximity_sensor();

//e3dv6();
//prometheus();
//frame_mockup(0, 2, 3, 4);
//bed_mk2();
//mks_sbase_mockup();