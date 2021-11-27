include <globals.scad>;
include <include.scad>;
use <long_tie.scad>;
use <motor_mount_small.scad>;
use <extention.scad>;
use <rack.scad>;


////// VARIABLES //////
tail_depth = 55;
tail_depth_2 = -10;
thickness = 21;


////// VIEW //////
//debug();

x_spacer();
//x_spacer(supports=false);


////// MODULES //////
module y_mount_added(){
    union() {
        translate([0, -43/2 + 15, thickness/2])
        cube([30, 43, thickness], center=true);

        translate([-8, 15/2, thickness])
        long_tie(15);

        translate([8, 15/2, thickness])
        long_tie(15);
    }
}

module y_mount_taken(supports){
    function bridge_extra() = supports ? 0.2 : 0;

    rotate([90, 0, 45])
    tie_end(40, bridge_extra=bridge_extra());

	translate([-8, -43, thickness])
    rotate([-90, 0, 0])
    male_dovetail(height=30);

	translate([8, -43, thickness])
    rotate([-90, 0, 0])
    male_dovetail(height=30);

    translate([-15, -15, 26])
    rotate([-90, 0, 0])
    difference() {
        wrap(1);

        translate([0, -25, 0])
        chamfered_cube(30, 30, 30, 5);
    }

    translate([0, -30/2 - 14.99, -30/2 + 21 - 6])
    cube([40, 30, 30], center=true);

    cylinder(d=15, h=9);
}


module x_spacer(supports=true) {
    union() {

        if (supports) {
            rotate([90, 0, 0])
            bow_support();

            translate([-30/2 + 0.4/2, -22, 14.8/2])
            cube([0.4, 12, 14.8], center=true);

            translate([30/2 - 0.4/2, -22, 14.8/2])
            cube([0.4, 12, 14.8], center=true);

            translate([-30/2 + 10, -22, 14.8/2])
            cube([0.4, 12, 14.8], center=true);

            translate([30/2 - 10, -22, 14.8/2])
            cube([0.4, 12, 14.8], center=true);

            translate([0, -28 + 0.4/2, 14.8/2])
            cube([30, 0.4, 14.8], center=true);

            translate([0, -16 + 0.4/2, 1.8/2 + 13])
            cube([30, 0.4, 1.8], center=true);

            translate([0, -18 + 0.4/2, 1.8/2 + 13])
            cube([30, 0.4, 1.8], center=true);

            translate([0, -20 + 0.4/2, 1.8/2 + 13])
            cube([30, 0.4, 1.8], center=true);

            translate([0, -22 + 0.4/2, 1.8/2 + 13])
            cube([30, 0.4, 1.8], center=true);

            translate([0, -24 + 0.4/2, 1.8/2 + 13])
            cube([30, 0.4, 1.8], center=true);

            translate([0, -26 + 0.4/2, 1.8/2 + 13])
            cube([30, 0.4, 1.8], center=true);
        }

        difference(){
            y_mount_added();
            y_mount_taken(supports);
        }
    }
}

module debug() {
    intersection() {
        x_spacer();
        translate([8, -90/2, 0])
        cube([30, 90, 30]);
    }
    %translate([0, -11, thickness])
    rotate([0, 0, 180])
    motor_mount(motor_side=false);

    %translate([0, -24.5, thickness  +24.1])
    rotate([-90, 0, 0])
    do_rack(1, fast_render=true);

    %translate([0, -43.5, 45.1])
    rotate([0, 90, 0])
    extention(2, support=false);

    %translate([0, 0, -30])
    extention(2, support=false);
}
