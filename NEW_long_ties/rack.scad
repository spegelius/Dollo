include <include.scad>;
include <globals.scad>;
use <../snappy-reprap/xy_sled_parts.scad>
use <motor_mount_small.scad>;
use <motor_gear.scad>;
use <long_tie.scad>;
use <long_bow_tie.scad>;

//globals

obj_height = 20;
units = 5; //only even numbers
unit_length = 30;
tail_depth = -4;

resolution = 10;

teeth_angle = 30;

// for rounded cube
diameter = 2;

module tie_taken(){
    translate([-(unit_length*units+20)/2,0,tail_depth-0.01]) rotate([90,0,90]) male_dovetail(height=units*unit_length+20, bridge_extra=0.2);

    translate([-(unit_length*units+20)/2,-9,9.4]) rotate([90,180,90]) male_dovetail(height=units*unit_length+20);
}

//herring bone style rack made from inkscape and OpenScad
module rackObject(units=units, fast_render=false) {
    union() {
        if (!fast_render) {
            intersection() {
                translate([0,6,6]) rotate([90,0,0]) herringbone_rack(l=units*unit_length+10, h=12, w=10, tooth_size=5, CA=teeth_angle);
                translate([0,5.9,3]) rotate([0,90,0]) scale([1.4,1,1]) cylinder(d=11.9, h=units*unit_length+10, center=true,$fn=30);
            }
        }
        
        difference(){
            union() {
                translate([0,0,-0.5]) cube([unit_length*units+20,36,7], center=true);

                translate([0,-9,4]) rounded_cube(unit_length*units+15,18,6,diameter,center=true,$fn=20);
            }
            // side indents
            translate([2,-25.8,0]) rotate([45,0,0]) cube([unit_length*units+5,15,15], center=true);
            translate([2,25.8,0]) rotate([45,0,0]) cube([unit_length*units+5,15,15], center=true);

        }
    }
}

//translate([0,30,0]) rackHalf();

// height measurement cube
//translate([20,-20,-4]) cube([20,40,12.5]);

head_offset = 2;
dove_scale_x = 1;
dove_scale_y = 0.98;

// pin for locking the male dovetail
module dove_pin(length=5, width=3) {
    cylinder(d=2.5,h=length, $fn=30);
    translate([0,0,length/2]) cube([1.5,width,length],center=true);
}

module scaled_dove(h) {
    difference() {
        scale([dove_scale_x, dove_scale_y, 1]) male_dovetail(h);
        translate([0,3,0]) dove_pin(h, width=4);
    }
}

module do_rack(units=units, fast_render=false) {

    difference() {
        union(){
            intersection(){
                rackObject(units=units, fast_render=fast_render);

                difference(){
                    union(){
                        translate([0,0,6]) rounded_cube(unit_length*units-slop,40,20,diameter,center=true,$fn=20);
                        translate([-units*unit_length/2-head_offset+slop,6,-15]) rotate([0,0,-teeth_angle]) cube([10,10,30]);
                        translate([-units*unit_length/2-head_offset+slop,6,-15]) mirror([0,1,0]) rotate([0,0,-teeth_angle]) cube([10,10,30]);

                        // couplers
                        translate([-units*unit_length/2+slop, 9, -4]) rotate([0,0,90]) scaled_dove(5.2);
                        translate([-units*unit_length/2+slop, 9, -4]) rotate([0,0,-90]) scaled_dove(1);
                        
                        translate([-units*unit_length/2+slop, -9, -4]) rotate([0,0,90]) scaled_dove(8.5);
                        translate([-units*unit_length/2+slop, -9, -4]) rotate([0,0,-90]) scaled_dove(1);
                    }
                    union(){
                        translate([units*unit_length/2-head_offset-slop/2,6,-15]) rotate([0,0,-teeth_angle]) cube([10,10,30]);
                        mirror([0,1,0]) translate([units*unit_length/2-head_offset-slop/2,-6,-15]) rotate([0,0,-teeth_angle]) cube([10,10,30]);
                    }

                    // coupler holes
                    translate([units*unit_length/2+slop, 9, -4]) rotate([0,0,90]) male_dovetail(6);
                    translate([units*unit_length/2+slop, -9, -4]) rotate([0,0,90]) male_dovetail(8.4);
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
    translate ([0,0,5]) difference() {
        rotate([0,180,0]) long_tie();
        cube([10,101,5],center=true);
    }
}

do_rack(fast_render=false);
//dove_pin();
//translate([units*unit_length,0,0]) do_rack();
//do_tie();
//translate([units*unit_length,0,0]) do_rack();
//translate([0,0,0]) rotate([90,0,0]) herringbone_rack(l=35, h=12, w=6, tooth_size=5, CA=teeth_angle);

//%translate([0,-24.1,13.5]) rotate([-90,0,0]) do_motor_mount();
//%mirror([0,1,0]) translate([0,-24.1,13.5]) rotate([-90,0,0]) do_motor_mount();
//%translate([0,20,13.5]) rotate([90,-8,0]) gear_v3();
//translate([20,-9,9.4]) rotate([0,0,90]) do_tie();