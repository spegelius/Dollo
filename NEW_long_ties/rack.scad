include <include.scad>;
include <globals.scad>;
use <../snappy-reprap/xy_sled_parts.scad>
use <motor_mount_small.scad>;
use <motor_gear.scad>;
use <long_tie.scad>;
use <long_bow_tie.scad>;


////// VARIABLES //////
obj_height = 20;
units = 5; //only even numbers
unit_length = 30;
tail_depth = -4;
total_length = units * unit_length;

resolution = 10;

// for rounded cube
diameter = 2;

head_offset = 2;
dove_scale_x = 1;
dove_scale_y = 0.98;

////// VIEW //////
//debug_join();
debug_axis_assembly();
//debug_rack_gear();

//do_rack(fast_render=false);
//dove_pin();


////// MODULES //////

// height measurement cube
//translate([20,-20,-4])
//cube([20,40,12.5]);

module _herringbone_rack(length) {
    herringbone_rack(
        l=length, h=rack_h, w=10, 
        tooth_size=rack_tooth, CA=rack_teeth_angle);
}

module tie_taken(){
    translate(
        [-(total_length + 20)/2, 0, tail_depth - 0.01])
    rotate([90, 0, 90])
    male_dovetail(height=total_length + 20, bridge_extra=0.2);

    translate([-(total_length + 20)/2, -9, 10.3])
    rotate([90, 180, 90])
    male_dovetail(height=total_length + 20);
}

//herring bone style rack made from inkscape and OpenScad
module rack_main(units=units, fast_render=false) {
    union() {
        // rack
        if (!fast_render) {
            intersection() {
                translate([0, 6, 6])
                rotate([90, 0, 0])
                _herringbone_rack(total_length + 10);

                translate([0, 5.9, 3])
                rotate([0, 90, 0])
                scale([1.4, 1, 1])
                cylinder(
                    d=11.9, h=total_length + 10,
                    center=true, $fn=60);
            }
        }

        // main body
        difference(){
            union() {
                translate([0, 0, -0.5])
                cube([total_length + 20, 36, 7], center=true);

                translate([0, -9, 4])
                rounded_cube(
                    total_length + 20, 18, 7.25,
                    diameter, center=true,$fn=20);
            }
            // side grooves
            translate([0, -25.8, 0])
            rotate([45, 0, 0])
            cube([total_length + 25, 15, 15], center=true);

            translate([0, 25.8, 0])
            rotate([45, 0, 0])
            cube([total_length + 25, 15, 15], center=true);
        }
    }
}

// pin for locking the male dovetail
module dove_pin(length=5, width=3) {
    cylinder(d=2.5, h=length, $fn=30);
    translate([0, 0, length/2])
    cube([1.5, width, length], center=true);
}

module scaled_dove(h) {
    difference() {
        scale([dove_scale_x, dove_scale_y, 1])
        male_dovetail(h);

        translate([0, 3, 0])
        dove_pin(h, width=4);
    }
}

module do_rack(units=units, fast_render=false) {

    difference() {
        union(){
            intersection(){
                rack_main(units=units, fast_render=fast_render);

                difference(){
                    union(){
                        translate([0, 0, 6])
                        rounded_cube(
                            total_length - slop,
                            40, 20, diameter,
                            center=true, $fn=20);

                        translate([
                            -total_length/2 - head_offset + slop,
                            6, -15])
                        rotate([0, 0, -rack_teeth_angle])
                        cube([10, 10, 30]);

                        translate([
                            -total_length/2 - head_offset + slop,
                            6, -15])
                        mirror([0, 1, 0])
                        rotate([0, 0, -rack_teeth_angle])
                        cube([10, 10, 30]);

                        // couplers
                        translate([-total_length/2 + slop, 9, -4])
                        rotate([0, 0, 90])
                        scaled_dove(5.2);

                        translate([-total_length/2 + slop, 9, -4])
                        rotate([0, 0, -90])
                        scaled_dove(1);
                        
                        translate([-total_length/2 + slop, -9, -4])
                        rotate([0, 0, 90])
                        scaled_dove(8.5);

                        translate([-total_length/2 + slop, -9, -4])
                        rotate([0, 0, -90])
                        scaled_dove(1);
                    }

                    // back chamfer
                    union(){
                        translate([
                            total_length/2 - head_offset-slop/2,
                            6, -15])
                        rotate([0, 0, -rack_teeth_angle])
                        cube([10, 10, 30]);

                        mirror([0, 1, 0])
                        translate([
                            total_length/2 - head_offset-slop/2,
                            -6, -15])
                        rotate([0, 0, -rack_teeth_angle])
                        cube([10, 10, 30]);
                    }

                    // coupler holes
                    translate([total_length/2+slop, 9, -4])
                    rotate([0, 0, 90])
                    male_dovetail(6);

                    translate([total_length/2+slop, -9, -4])
                    rotate([0, 0, 90])
                    male_dovetail(8.4);
                }
            //intersection
            }
        //union
        }
        tie_taken();
    //difference
    }
}

// slim tie, for the rack top groove
module do_tie() {
    translate ([0, 0, 5])
    difference() {
        rotate([0, 180, 0])
        long_tie();

        cube([10, 101, 5], center=true);
    }
}

module debug_join() {
    do_rack(2);

    translate([2*unit_length, 0, 0])
    do_rack(2);

    translate([unit_length, 6, 6])
    rotate([-90, 0, 0])
    _herringbone_rack(35);
}

module debug_axis_assembly() {
    do_rack();

    %translate([0, -24.1, 13.1])
    rotate([-90, 0, 0])
    motor_mount(bridges=false, motor_side=false);

    %mirror([0, 1, 0])
    translate([0, -24.1, 13.1])
    rotate([-90, 0, 0])
    motor_mount(bridges=false);

    %translate([0, 21, 12.7])
    rotate([90, -8, 0])
    motor_gear();

    translate([20, -9, 5.1])
    rotate([0, 0, 90])
    do_tie();
}

module debug_rack_gear() {
    intersection() {
        union() {
            do_rack(1);

            translate([0, 21, 12.4])
            rotate([90, -7.8, 0])
            motor_gear();
        }
        translate([0, 60/2, 20/2 + 4.5])
        cube([60, 60, 20], center=true);
    }
}
