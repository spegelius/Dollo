include <include.scad>;
include <globals.scad>;
use <../snappy-reprap/xy_sled_parts.scad>

//globals

obj_height = 20;
units = 3; //only even numbers
unit_length = 30;
tail_depth = -4;
tie_scale_x = 1;
tie_scale_y = 1;
tie_scale_z = 1;

resolution = 10;

teeth_angle = 30;

// for rounded cube
diameter = 3;

module tie_taken(){
    difference(){
        translate([-unit_length*units/2,0,tail_depth]) rotate([90,0,90]) scale([tie_scale_x,tie_scale_z,tie_scale_y])  male_dovetail(height=units*unit_length+20);
	}
}

//herring bone style rack made from inkscape and OpenScad
module rackObject() {

    intersection() {
        translate([0,7.5,6]) rotate([90,0,0]) herringbone_rack(l=units*unit_length+10, h=12, w=10, tooth_size=5, CA=teeth_angle);
        translate([0,7.5,3]) rotate([0,90,0]) cylinder(d=13, h=units*unit_length+10, center=true);
    }
    
    difference(){
        union() {
            translate([0,0,0]) cube([unit_length*units+20,40,8], center=true);
            // slides
            //translate([-units*(unit_length/2)+51,1,-17]) rounded_cube(unit_length*units+5,5,6,$fn=40);
            //translate([-units*(unit_length/2)+51,1,-2]) rounded_cube(unit_length*units+5,5,6,$fn=40);
        }
        // side indents
        translate([2,-23,0]) rounded_cube(unit_length*units+5,7,4,$fn=40);
        translate([2,23,0]) rounded_cube(unit_length*units+5,7,4,$fn=40);
    }
    translate([0,-6.7,4]) rounded_cube(unit_length*units+15,16.5,5,$fn=40);
    //translate([-units*(unit_length)+41,1.1,.9]) cube([unit_length*units+10,0.9,0.8]);
}

//translate([0,30,0]) rackHalf();

// height measurement cube
//translate([20,-20,-4]) cube([20,40,12.5]);

head_offset = 2.8;

module do_rack() {
    intersection(){
    //translate([0,0,-10]) cube([20,20,20]);
        intersection(){
            translate([-slop-head_offset,0,0]) rounded_cube(unit_length*units+2*head_offset,40,20,$fn=40);
            union(){
                intersection(){
                    difference(){
                        rackObject();
                        translate([0,0,0]) tie_taken();
                    }

                    difference(){
                        union(){
                            translate([0,0,6]) rounded_cube(unit_length*units-slop,40,20,$fn=50);
                            translate([-units*unit_length/2-head_offset+slop,7.5,-15]) rotate([0,0,-teeth_angle]) cube([10,10,30]);
                            translate([-units*unit_length/2-head_offset+slop,7.5,-15]) mirror([0,1,0]) rotate([0,0,-teeth_angle]) cube([10,10,30]);
                            
                            // couplers
                            translate([-units*unit_length/2+slop, 13.5, -4]) rotate([0,0,90]) scale([0.95,0.95,0.95]) male_dovetail(5);
                            
                            translate([-units*unit_length/2+slop, -9, -4]) rotate([0,0,90]) scale([0.95,0.95,0.95]) male_dovetail(12);
                        }
                        union(){
                            translate([units*unit_length/2-head_offset-slop/2,7.5,-15]) rotate([0,0,-teeth_angle]) cube([10,10,30]);
                            mirror([0,1,0]) translate([units*unit_length/2-head_offset-slop/2,-7.5,-15]) rotate([0,0,-teeth_angle]) cube([10,10,30]);
                        }
                        
                        // coupler holes
                        translate([units*unit_length/2, 13.5, -4]) rotate([0,0,90]) male_dovetail(5.5);
                        translate([units*unit_length/2, -9, -4]) rotate([0,0,90]) male_dovetail(12);
                    }
                //intersection
                }
            //union
            }
        //intersection
        }
    //intersection
    }
}

do_rack();
//translate([units*unit_length,0,0]) do_rack();
//translate([0,0,0]) rotate([90,0,0]) herringbone_rack(l=35, h=12, w=6, tooth_size=5, CA=teeth_angle);
