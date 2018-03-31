
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
    
    module heatsink() {
        color("LightGrey") {
            cylinder(d=10,h=28, $fn=50);
            for (i = [0:9]) {
                translate([0,0,i*2.5]) cylinder(r=11.2, h=1, $fn=50);
            }
            translate([0,0,25]) cylinder(d=16,h=1, $fn=50);
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
            rotate([0,0,i*(360/4)]) translate([motor_bolt_hole_distance/2,motor_bolt_hole_distance/2,0]) cylinder(d=bolt_hole_dia, 6, $fn=20);
        }
    }
}

//mock_stepper_motor(false);
//mock_stepper_motor(true);

//mechanic_endstop();

//proximity_sensor();

//e3dv6();
//prometheus();