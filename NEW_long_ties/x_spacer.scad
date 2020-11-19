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


////// MODULES //////
module y_mount_added(){
    union() {
        translate([0,-51/2+15,thickness/2])
        cube([30,51,thickness],center=true);

        translate([-8,15/2,thickness])
        long_tie(15);

        translate([8,15/2,thickness])
        long_tie(15);
    }
}

module y_mount_taken(){
	translate([0,0,0])
    rotate([90,0,45])
    tie_end();

	translate([-8,-53,thickness])
    rotate([-90,0,0])
    male_dovetail(height=30);

	translate([8,-53,thickness])
    rotate([-90,0,0])
    male_dovetail(height=30);

    translate([-15,15,-8.99])
    rotate([90,0,0])
    wrap(1);

    translate([0,-30/2-14.99,-30/2+21-6])
    cube([40,30,30],center=true);

    cylinder(d=15,h=9);
}


module x_spacer() {
    union() {
        rotate([90,0,0])
        bow_support();

        difference(){
            y_mount_added();
            y_mount_taken();
        }
    }
}

module debug() {
    intersection() {
        x_spacer();
        translate([8,-90/2,0])
        cube([30,90,30]);
    }
    %translate([0,-11,thickness])
    rotate([0,0,180])
    do_motor_mount();

    %translate([0,-24.5,thickness+24.1])
    rotate([-90,0,0])
    do_rack(1, fast_render=true);

    %translate([0,-43.5,45.1])
    rotate([0,90,0])
    extention(2, support=false);

    %translate([0,0,-30])
    rotate([0,0,0])
    extention(2, support=false);
}
