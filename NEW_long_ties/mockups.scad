
include <globals.scad>;
use <include.scad>;


////// VARIABLES //////
prox_sensor_dia = 18;
prox_sensor_washer_dia = 30;


////// VIEW //////
//mock_stepper_motor(geared=false);
//mock_stepper_motor(geared=true);

//mechanical_endstop();

//proximity_sensor();

//e3dv6();
//e3d_Volcano();
//prometheus();
//frame_mockup(0, 3, 2, 4, x_pos=10);
//bed_mk2();
//mks_sbase_mockup();
//mock_PSU_240W();
//mock_PSU_360W();
//mock_PSU_600W();

//mock_SSR_75_DD();
//mock_titan();
//mock_5015_fan();


////// MODULES //////
// LJ18A3-8-Z/BX
module proximity_sensor(nut_position=30, nut_gap=10) {
    
    module mount_nut() {
        color("Silver")
        difference() {
            cylinder(d=23.7, h=3.5, $fn=6);
            cylinder(d=17.9, h=3.6, $fn=50);
        }
    }
    
    color("Orange")
    cylinder(d=16.32, h=8.9, $fn=50);

    translate([0,0,8.9])
    color("Silver")
    cylinder(d=prox_sensor_dia, h=47.1, $fn=50);

    translate([0,0,8.9+47.1])
    color("LightGrey")
    cylinder(d=17, h=13.8, $fn=50);

    translate([0,0,nut_position])
    mount_nut();

    color("LightGrey")
    translate([0,0,nut_position+3])
    cylinder(d=prox_sensor_washer_dia,h=1.5);

    translate([0,0,nut_position+3+1.5+1.5+nut_gap])
    mount_nut();

    color("LightGrey")
    translate([0,0,nut_position+3+1.5+nut_gap])
    cylinder(d=prox_sensor_washer_dia,h=1.5);
}

module _e3d_nozzle() {
    cylinder(d1=1, d2=3.5, h=2, $fn=30);

    translate([0,0,2])
    cylinder(d=7,h=2.5, $fn=6);

    translate([0,0,4.5])
    cylinder(d=4,h=2, $fn=30);
}

module _e3dv6_heater_block() {
    color("LightGrey") {
        translate([-8, -8, 0])
        chamfered_cube(16,23,11.5,0.5);

        cylinder(d=5,h=15, $fn=30);
    }
}

module _e3dvolcano_heater_block() {
    color("LightGrey")
    difference() {
        union() {
            translate([-4.5, -(24-15.5), 0])
            chamfered_cube(2*5.75,24,20,0.5);

            cylinder(d=5,h=23.5, $fn=30);
        }
        translate([0,10/2+15.5-8,-10/2+1])
        rounded_cube(20,10,10,1,center=true,$fn=20);
    }
}

e3d_heatsink_step = 2.5;
e3d_heatsink_h = 12*e3d_heatsink_step;
echo("E3D heatsink h:", e3d_heatsink_h);

module _e3d_heatsink() {
    color("LightGrey") {
        cylinder(d1=12, d2=10, h=e3d_heatsink_h, $fn=50);

        for (i = [0:10]) {
            translate([0, 0, i*e3d_heatsink_step])
            cylinder(d=22.3, h=1, $fn=50);
        }
        translate([0, 0, 11*e3d_heatsink_step])
        cylinder(d=16, h=1, $fn=50);
    }
}

module _e3d_neck(threaded=false) {
    $fn=50;

    color("LightGrey")
    union() {
        cylinder(d=16, h=3);

        cylinder(d=12, h=9);

        if (threaded) {
            translate([0, 0, 9])
            cylinder(d=16, h=3.7);
        } else {
            translate([0, 0, 9])
            cylinder(d=16, h=4.3);
        }
    }
}

module e3dv6() {
    _e3d_nozzle();

    translate([0,0,5])
    _e3dv6_heater_block();

    translate([0,0,19.6])
    _e3d_heatsink();

    translate([0,0,19.6+e3d_heatsink_h])
    _e3d_neck();
}

module e3d_Volcano() {
    _e3d_nozzle();

    translate([0, 0, 5])
    _e3dvolcano_heater_block();

    translate([0, 0, 19.6 + 8.5])
    _e3d_heatsink();

    translate([0, 0, 19.6 + 8.5 + e3d_heatsink_h])
    _e3d_neck();
}

module prometheus() {

    module nozzle() {
        hull() {
            cylinder(d=1, h=1, $fn=30);

            translate([0,0,2])
            cylinder(d=3, h=1, $fn=30);
        }
        translate([0,0,2])
        cylinder(d=7,h=2.5, $fn=6);

        translate([0,0,4.5])
        cylinder(d=4,h=2, $fn=30);
    }

    module heater_block() {
        color("LightGrey") {
            translate([-8, -8, 0])
            cube([16,23,11.5]);

            cylinder(d=5,h=15, $fn=30);
        }
    }
    
    module heatsink() {
        intersection() {
            color("LightGrey") {
                cylinder(d=10,h=28, $fn=50);
                for (i = [0:9]) {
                    translate([0,0,i*2.5])
                    cylinder(r=15, h=1, $fn=50);
                }
                translate([0,0,25])
                cylinder(d=16,h=1, $fn=50);
            }
            translate([0,0,40/2])
            cube([30,20,40], center=true);
        }
    }
    
    module neck() {
        color("LightGrey") {
            $fn=50;
            cylinder(d=16, h=3);

            translate([0,0,3])
            cylinder(d=12, h=6);

            translate([0,0,9])
            cylinder(d=16, h=3.7);
        }
    }
    nozzle();

    translate([0,0,5])
    heater_block();

    translate([0,0,18])
    heatsink();

    translate([0,0,62.3-16.7])
    neck();
}

// SS-5GL13
module mechanical_endstop() {
    difference() {
        color("black")
        cube([20, 11, 6]);

        translate([5, 3, -0.1])
        cylinder(d=2, h=7, $fn=20);

        translate([20-5, 3, -0.1])
        cylinder(d=2, h=7, $fn=20);
    }
    translate([0,11,1])
    rotate([0,0,15])
    color("grey")
    cube([19,0.5,4]);

    translate([1.5,-4,1])
    color("grey")
    cube([0.5, 4, 4]);

    translate([10.5,-4,1])
    color("grey")
    cube([0.5, 4, 4]);

    translate([20-1.5,-4,1])
    color("grey")
    cube([0.5, 4, 4]);
}

module mock_stepper_motor(geared=false, center=false) {
    module _stepper_motor() {
        difference() {
            union() {
                intersection() {
                    translate([0, 0, motor_side_length/2])
                    cube([
                        motor_side_length,
                        motor_height, motor_side_length
                    ], center=true);

                    translate([0, 0, motor_side_length/2])
                    rotate([0, 45, 0])
                    cube([54, 40, 54], center=true);
                }

                if (geared) {
                    translate([
                        0, 40/2, motor_side_length/2
                    ])
                    rotate([-90, 0, 0])
                    cylinder(d=36, h=27.5);

                    translate([
                        0, 40/2  + 27.5,
                        motor_side_length/2
                    ])
                    rotate([-90, 0, 0])
                    cylinder(d=22, h=2.2);

                    translate([
                        0, 40/2 + 27.5,
                        motor_side_length/2
                    ])
                    rotate([-90, 0, 0])
                    motor_shaft(d=8, h=20, flat=1, $fn=40);
                } else {
                    translate([
                        0, 40/2, motor_side_length/2
                    ])
                    rotate([-90, 0, 0])
                    cylinder(d=22, h=2);

                    translate([
                        0, 40/2 + 2,motor_side_length/2
                    ])
                    rotate([-90, 0, 0])
                    motor_shaft(h=22, $fn=40);
                }

                // connector
                translate([
                    0, -motor_height/2 + 5/2 + 0.5, 0
                ])
                cube([16, 5, 14], center=true);
            }

            translate([0, 40/2, motor_side_length/2])
            rotate([90, 0, 0])
            for (i=[0:3]) {
                rotate([0, 0, i*(360/4)])
                translate([
                    motor_bolt_hole_distance/2,
                    motor_bolt_hole_distance/2, -1
                ])
                cylinder(d=bolt_hole_dia, 7, $fn=20);
            }

            if (geared) {
                translate([
                    0, 40/2 + 27.5,
                    motor_side_length/2
                ])
                rotate([90, 0, 0])
                for (i=[0:3]) {
                    rotate([0, 0, i*(360/4)])
                    translate([
                        20/2,
                        20/2, -1
                    ])
                    cylinder(d=bolt_hole_dia, 7, $fn=20);
                }
            }
        }
    }

    if (center) {
        translate([0, 0, -motor_side_length/2])
        _stepper_motor();
    } else {
        _stepper_motor();
    }
}

module frame_mockup(
    bed_angle=45, units_x=1,
    units_y=1, units_z=1, x_pos=0
) {
    corner_side = 60;
    unit = 120;
    unit_len_x = units_x*unit;
    unit_len_y = units_y*unit;
    unit_len_z = units_z*unit;
    z = 2*corner_side + unit_len_z - 30;
    echo(z);
    
    module corner() {
        render()
        difference() {
            union() {
                cube([30, 30, corner_side]);
                cube([30, corner_side, 30]);
                cube([corner_side, 30, 30]);
            }
            translate([15, -0.01, 0])
            male_dovetail(corner_side + 1);

            translate([-0.01, 15, 0])
            rotate([0, 0, -90])
            male_dovetail(corner_side + 1);

            translate([15, 30.01, 0])
            rotate([0, 0, 180])
            male_dovetail(corner_side + 1);

            translate([30.01, 15, 0])
            rotate([0, 0, 90])
            male_dovetail(corner_side + 1);
        }
    }
    
    module side(length) {
        render()
        difference() {
            cube([30, 30, length]);
            translate([15, -0.01, 0])
            male_dovetail(corner_side + 1);

            translate([-0.01, 15, 0])
            rotate([0, 0, -90])
            male_dovetail(length + 1);

            translate([15, 30.01, 0])
            rotate([0, 0, 180])
            male_dovetail(length + 1);

            translate([30.01, 15, 0])
            rotate([0, 0, 90])
            male_dovetail(length + 1);
        }
    }

    %render()
    translate([-unit_len_x/2, x_pos, z + 30 + 43.5])
    rotate([0, 90, 0])
    side(unit_len_x);

    // corners
    %translate([
        -corner_side - unit_len_x/2,
        -corner_side - unit_len_y/2, 0
    ])
    corner();

    %mirror([1, 0, 0])
    translate([
        -corner_side - unit_len_x/2,
        -corner_side - unit_len_y/2, 0
    ])
    corner();

    %mirror([0, 1, 0])
    translate([
        -corner_side - unit_len_x/2,
        -corner_side - unit_len_y/2, 0
    ])
    corner();

    %mirror([0, 1, 0])
    mirror([1, 0, 0])
    translate([
        -corner_side - unit_len_x/2,
        -corner_side - unit_len_y/2, 0
    ])
    corner();

    // corners
    translate([0, 0, 2*corner_side + unit_len_z])
    mirror([0, 0, 1]) {
        %translate([
            -corner_side - unit_len_x/2,
            -corner_side - unit_len_y/2, 0
        ])
        corner();

        %mirror([1, 0, 0])
        translate([
            -corner_side - unit_len_x/2,
            -corner_side - unit_len_y/2, 0
        ])
        corner();

        %mirror([0, 1, 0])
        translate([
            -corner_side - unit_len_x/2,
            -corner_side - unit_len_y/2, 0
        ])
        corner();

        %mirror([0, 1, 0])
        mirror([1, 0, 0])
        translate([
            -corner_side - unit_len_x/2,
            -corner_side - unit_len_y/2, 0
        ])
        corner();
    }

    // sides
    %translate([
        -corner_side - unit_len_x/2,
        unit_len_y/2, 0
    ])
    rotate([90, 0, 0])
    side(unit_len_y);

    %mirror([1, 0, 0])
    translate([
        -corner_side - unit_len_x/2,
        unit_len_y/2, 0
    ])
    rotate([90, 0, 0])
    side(unit_len_y);

    %rotate([0, 0, 90])
    translate([
        -corner_side - unit_len_y/2,
        unit_len_x/2, 0
    ])
    rotate([90, 0, 0])
    side(unit_len_x);

    %mirror([0, 1, 0])
    %rotate([0, 0, 90])
    translate([
        -corner_side - unit_len_y/2,
        unit_len_x/2, 0
    ])
    rotate([90, 0, 0])
    side(unit_len_x);

    // sides
    %translate([
        -corner_side - unit_len_x/2,
        unit_len_y/2, z
    ])
    rotate([90, 0, 0])
    side(unit_len_y);

    %mirror([1, 0, 0])
    translate([
        -corner_side - unit_len_x/2,
        unit_len_y/2, z
    ])
    rotate([90, 0, 0])
    side(unit_len_y);

    %rotate([0, 0, 90])
    translate([
        -corner_side - unit_len_y/2,
        unit_len_x/2, z
    ])
    rotate([90, 0, 0])
    side(unit_len_x);

    %mirror([0, 1, 0])
    %rotate([0, 0, 90])
    translate([
        -corner_side - unit_len_y/2,
        unit_len_x/2, z
    ])
    rotate([90, 0, 0])
    side(unit_len_x);

    %translate([
        -corner_side - unit_len_x/2,
        -corner_side - unit_len_y/2,
        corner_side
    ])
    side(unit_len_z);

    %mirror([1, 0, 0])
    translate([
        -corner_side - unit_len_x/2,
        -corner_side - unit_len_y/2,
        corner_side
    ])
    side(unit_len_z);

    %mirror([0, 1, 0])
    translate([
        -corner_side-unit_len_x/2,
        -corner_side-unit_len_y/2,
        corner_side
    ])
    side(unit_len_z);

    %mirror([0, 1, 0])
    mirror([1, 0, 0])
    translate([
        -corner_side-unit_len_x/2,
        -corner_side-unit_len_y/2,
        corner_side
    ])
    side(unit_len_z);
}

module bed_mk2(bed_angle=0) {
    // bed mk2
    bed_w = 214;
    hole_distance = 209;

    difference() {
        rotate([0,0,bed_angle])
        cube([bed_w,bed_w,1], center=true);

        translate([-hole_distance/2,-hole_distance/2,0])
        cylinder(d=3,h=2,center=true,$fn=20);

        translate([hole_distance/2,-hole_distance/2,0])
        cylinder(d=3,h=2,center=true,$fn=20);

        translate([hole_distance/2,hole_distance/2,0])
        cylinder(d=3,h=2,center=true,$fn=20);

        translate([-hole_distance/2,hole_distance/2,0])
        cylinder(d=3,h=2,center=true,$fn=20);
    }
}

module bed_mk3_300(bed_angle=0) {
    // bed mk2
    bed_w = 330;
    hole_distance = 325;

    difference() {
        rotate([0,0,bed_angle])
        cube([bed_w,bed_w,1], center=true);

        translate([-hole_distance/2,-hole_distance/2,0])
        cylinder(d=3,h=2,center=true,$fn=20);

        translate([hole_distance/2,-hole_distance/2,0])
        cylinder(d=3,h=2,center=true,$fn=20);

        translate([hole_distance/2,hole_distance/2,0])
        cylinder(d=3,h=2,center=true,$fn=20);

        translate([-hole_distance/2,hole_distance/2,0])
        cylinder(d=3,h=2,center=true,$fn=20);
    }
}

module bed_340(bed_angle=0) {
    // bed mk2
    bed_w = 340;
    hole_distance = 335;

    difference() {
        rotate([0,0,bed_angle])
        cube([bed_w,bed_w,1], center=true);

        translate([-hole_distance/2,-hole_distance/2,0])
        cylinder(d=3,h=2,center=true,$fn=20);

        translate([hole_distance/2,-hole_distance/2,0])
        cylinder(d=3,h=2,center=true,$fn=20);

        translate([hole_distance/2,hole_distance/2,0])
        cylinder(d=3,h=2,center=true,$fn=20);

        translate([-hole_distance/2,hole_distance/2,0])
        cylinder(d=3,h=2,center=true,$fn=20);
    }
}

module bed_340_300() {
    // bed mk2
    bed_w = 340;
    bed_l = 300;

    difference() {
        cube([bed_w,bed_l,3], center=true);

        translate([-bed_w/2+8/2,-bed_l/2+8/2,0])
        cylinder(d=3,h=8,center=true,$fn=20);

        translate([bed_w/2-8/2,-bed_l/2+8/2,0])
        cylinder(d=3,h=8,center=true,$fn=20);

        translate([-bed_w/2+8/2,bed_l/2-8/2,0])
        cylinder(d=3,h=8,center=true,$fn=20);

        translate([bed_w/2-8/2,bed_l/2-8/2,0])
        cylinder(d=3,h=8,center=true,$fn=20);
        
        translate([-bed_w/2+8/2,0,0])
        cylinder(d=3,h=8,center=true,$fn=20);
        
        translate([bed_w/2-8/2,0,0])
        cylinder(d=3,h=8,center=true,$fn=20);
        
        translate([0,-bed_l/2+5/2,0])
        cylinder(d=3,h=8,center=true,$fn=20);
        
        translate([0,bed_l/2-5/2,0])
        cylinder(d=3,h=8,center=true,$fn=20);
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

        translate([4,4,0])
        cylinder(d=3.6,h=5,center=true,$fn=20);

        translate([w-4,4,0])
        cylinder(d=3.6,h=5,center=true,$fn=20);

        translate([w-4,l-4,0])
        cylinder(d=3.6,h=5,center=true,$fn=20);

        translate([4,l-4,0])
        cylinder(d=3.6,h=5,center=true,$fn=20);
    }
}

//S-240-12
module mock_PSU_240W() {
    w = 110.2;
    h = 199;
    d = 50;
    
    color("silver")
    difference() {
        cube([w, h, d]);

        translate([-1.4, -1, 24])
        cube([w, 12, d]);

        translate([-1, -1, 8.3])
        cube([13, 12, d]);

        translate([w - 1.4 - 9.3, -1, 1.4])
        cube([9.3, 12, d]);

        translate([7, 5])
        cylinder(d=3.2, h=10, $fn=30);

        translate([w - 6, 5])
        cylinder(d=4.2, h=10, $fn=30);

        translate([w + 1, 19.5, d/2])
        rotate([0, -90, 0])
        cylinder(d=3, h=10, $fn=20);

        translate([w + 1, 19.5 + 150.7, 12])
        rotate([0, -90, 0])
        cylinder(d=3, h=10, $fn=20);

        translate([w + 1, 19.5 + 150.7, d - 13])
        rotate([0, -90, 0])
        cylinder(d=3, h=10, $fn=20);

        translate([10, 61, -0.1])
        cylinder(d=3, h=10, $fn=20);

        translate([w - 15, 61, -0.1])
        cylinder(d=3, h=10, $fn=20);
        
        translate([10, 61 + 126, -0.1])
        cylinder(d=3, h=10, $fn=20);

        translate([w - 15, 61 + 126, -0.1])
        cylinder(d=3, h=10, $fn=20);
        
        translate([w, 6, d - 6.5])
        rotate([0, 90, 0])
        cylinder(d=4, h=5, center=true, $fn=30);

        translate([w, 6, d - 16.5])
        rotate([0, 90, 0])
        cylinder(d=4, h=5, center=true, $fn=30);

        // cover grill holes side
        for (j = [0:3]) {
            for (i = [0:15]) {
                translate([0, 21 + i*10.65, 26 + j*6])
                rotate([0, 90, 0])
                cylinder(d=4, h=20, center=true, $fn=30);
            }
        }

        for (j = [0:4]) {
            for (i = [0:15]) {
                translate([0, 26.325 + i*10.65, 23 + j*6])
                rotate([0, 90, 0])
                cylinder(d=4, h=20, center=true, $fn=30);
            }
        }

        // cover grill holes top
        for (j = [0:17] ) {
            for (i = [0:15]) {
                translate([1 + j*6, 21 + i*10.65, d + 9])
                cylinder(d=4, h=20, center=true, $fn=30);
            }
        }

        for (j = [0:17] ) {
            for (i = [0:15]) {
                translate([4 + j*6, 26.325 + i*10.65, d + 9])
                cylinder(d=4, h=20, center=true, $fn=30);
            }
        }
    }
}

module mock_PSU_360W() {
    w = 114;
    h = 215;
    d = 50;
    
    color("silver")
    difference() {
        cube([w,h,d]);

        translate([1.4,-1,19])
        cube([w-2*1.4,20,d]);

        translate([1.4,-1,5])
        cube([12,20,d]);

        translate([w+1,32,11])
        rotate([0,-90,0])
        cylinder(d=3,h=10,$fn=20);

        translate([w+1,32,11+25])
        rotate([0,-90,0])
        cylinder(d=3,h=10,$fn=20);

        translate([w+1,32+150,11])
        rotate([0,-90,0])
        cylinder(d=3,h=10,$fn=20);

        translate([w+1,32+150,11+25])
        rotate([0,-90,0])
        cylinder(d=3,h=10,$fn=20);

        translate([9,32,11])
        rotate([0,-90,0])
        cylinder(d=3,h=10,$fn=20);

        translate([9,32+150,11])
        rotate([0,-90,0])
        cylinder(d=3,h=10,$fn=20);

        translate([31.5,32,-0.1])
        cylinder(d=3,h=10,$fn=20);

        translate([w-31.5,32,-0.1])
        cylinder(d=3,h=10,$fn=20);

        translate([31.5,32+150,-0.1])
        cylinder(d=3,h=10,$fn=20);

        translate([w-31.5,32+150,-0.1])
        cylinder(d=3,h=10,$fn=20);
    }
}

// S-600-24
module mock_PSU_600W() {
    w = 114;
    h = 215;
    d = 50;
    
    color("silver")
    difference() {
        cube([w,h,d]);

        translate([1.4,-1,24])
        cube([w-2*1.4,21,d]);

        translate([1.4,-1,7.5])
        cube([18,21,d]);

        translate([w-1.4-5,-1,7.5])
        cube([5,21,d]);

        translate([w+1,32.5,11])
        rotate([0,-90,0])
        cylinder(d=3,h=10,$fn=20);

        translate([w+1,32.5,11+25])
        rotate([0,-90,0])
        cylinder(d=3,h=10,$fn=20);

        translate([w+1,32.5+150,11])
        rotate([0,-90,0])
        cylinder(d=3,h=10,$fn=20);

        translate([w+1,32.5+150,11+25])
        rotate([0,-90,0])
        cylinder(d=3,h=10,$fn=20);

        translate([9,32.5,11])
        rotate([0,-90,0])
        cylinder(d=3,h=10,$fn=20);

        translate([9,32.5+150,11])
        rotate([0,-90,0])
        cylinder(d=3,h=10,$fn=20);

        translate([32,32.5,-0.1])
        cylinder(d=3,h=10,$fn=20);

        translate([w-32,32.5,-0.1])
        cylinder(d=3,h=10,$fn=20);

        translate([32,32.5+150,-0.1])
        cylinder(d=3,h=10,$fn=20);

        translate([w-32,32.5+150,-0.1])
        cylinder(d=3,h=10,$fn=20);
    }
}

module mock_SSR_75_DD() {
    difference() {
        union() {
            translate([0,0,3/2])
            cube([45.5,63,3],center=true);

            translate([0,0,23/2])
            cube([45.5,60,23],center=true);

            translate([0,63/2-2/2,4.7/2])
            cube([10,2,4.7],center=true);

            translate([0,-63/2+2/2,4.7/2])
            cube([10,2,4.7],center=true);
        }

        translate([0,60/2,25/2+4.7])
        hull() {
            cube([10,1,25],center=true);

            translate([0,-6,0])
            cylinder(d=10,h=25,center=true,$fn=40);
        }

        translate([0,-60/2,25/2+4.7])
        hull() {
            cube([10,1,25],center=true);

            translate([0,6,0])
            cylinder(d=10,h=25,center=true,$fn=40);
        }

        translate([0,63/2-9,0])
        hull() {
            cylinder(d=4.2,h=10,center=true,$fn=40);

            translate([0,3,0])
            cylinder(d=4.2,h=10,center=true,$fn=40);
        }

        translate([0,-63/2+8,0])
        cylinder(d=4.2,h=10,center=true,$fn=40);

        translate([45.5/2-2.4-12.5/2,60/2-13/2,16+8/2])
        cube([12.5,13,8],center=true);

        translate([-45.5/2+2.4+12.5/2,60/2-13/2,16+8/2])
        cube([12.5,13,8],center=true);

        translate([-45.5/2+3.4+10.5/2,-60/2+12/2,16+8/2])
        cube([10.5,12,8],center=true);

        translate([45.5/2-3.4-10.5/2,-60/2+12/2,16+8/2])
        cube([10.5,12,8],center=true);
    }

    translate([45.5/2-8.65,60/2-6.5,0])
    cylinder(d=7,h=22,$fn=40);

    translate([-45.5/2+8.65,60/2-6.5,0])
    cylinder(d=7,h=22,$fn=40);
    
    translate([45.5/2-8.65,-60/2+6,0])
    cylinder(d=7,h=22,$fn=40);

    translate([-45.5/2+8.65,-60/2+6,0])
    cylinder(d=7,h=22,$fn=40);
}

module mock_titan() {

    difference() {
        union() {
            hull() {
                translate([-46.5/2+1/2,-4/2,30/2])
                cube([1,40,30],center=true);

                translate([-46.5/2+1/2+4,0,30/2])
                cube([1,44,30],center=true);

                translate([46.5/2-1/2,10/2,30/2])
                cube([1,34,30],center=true);

                translate([46.5/2-16/2,-44/2+16/2,0])
                cylinder(d=16,h=30,$fn=80);
            }
            translate([-46.5/2+7+27/2,44/2-7-27/2,0])
            translate([motor_bolt_hole_distance/2,
                       -motor_bolt_hole_distance/2,
                       30-5-4])
            cylinder(d=34,h=4,$fn=40);
        }
        translate([-46.5/2+7+27/2,44/2-7-27/2,0])
        cylinder(d=27,h=100,center=true,$fn=40);

        translate([-46.5/2+7+27/2,44/2-7-27/2,0])
        for(i=[0:3]) {
            rotate([0,0,360/4*i])
            translate([motor_bolt_hole_distance/2,
                   -motor_bolt_hole_distance/2,
                   0])
            cylinder(d=3,h=100,center=true,$fn=30);
        }
    }
}

module mock_pulley_GT2_16t() {
    difference() {
        union() {
            cylinder(d=13, h=6, $fn=30);
            cylinder(d=10, h=14, $fn=30);

            translate([0, 0, 13])
            cylinder(d=13, h=1, $fn=30);
        }
    }
}

module mock_5015_fan() {
    union() {
        import("../../_downloaded/50mm_Radial_fan/50mm_fan.stl");

        translate([
            -0.5, 1.5 + 11/2, 8.5 - 2.5 + 2.5/2
        ])
        cube([2, 11, 2.5], center=true);

        translate([26.5, 2, 8.5 - 2.5 + 2.5/2])
        cube([10, 2.5, 2.5], center=true);

        translate([36.5, 49.8, 8.5 - 2.5 + 2.5/2])
        rotate([0, 0, -22])
        cube([10, 2.5, 2.5], center=true);
    }
    
}
