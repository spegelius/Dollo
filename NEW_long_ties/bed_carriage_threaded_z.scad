
include <globals.scad>;
include <include.scad>;

use <extention.scad>;

units = 2;

module corner() {
    cube([30,30,100]);
}

// corners
%translate([90, -120, -100]) corner();
%translate([90, 90, -100]) corner();
%translate([-120, -120, -100]) corner();
%translate([-120, 90, -100]) corner();

// bed
translate([0,0,-50]) %difference() {
    rotate([0,0,45]) cube([210,210,1], center=true);
    rotate([0,0,45]) cube([190,190,2], center=true);
}

// motor
module motor_mount() {
    difference() {
        translate([0,0,2.5]) cube([motor_side_length,motor_side_length,5], center=true);
        
        translate([0,0,-.5]) cylinder(d=motor_center_hole, h=7);
        
        translate([motor_bolt_hole_distance/2,motor_bolt_hole_distance/2,0]) cylinder(d=bolt_hole_dia, h=6, $fn=20);
        translate([-motor_bolt_hole_distance/2,motor_bolt_hole_distance/2,0]) cylinder(d=bolt_hole_dia, h=6, $fn=20);
        translate([motor_bolt_hole_distance/2,-motor_bolt_hole_distance/2,0]) cylinder(d=bolt_hole_dia, h=6, $fn=20);
        translate([-motor_bolt_hole_distance/2,-motor_bolt_hole_distance/2,0]) cylinder(d=bolt_hole_dia, h=6, $fn=20);
        
                // nut indentations
        translate([motor_bolt_hole_distance/2,motor_bolt_hole_distance/2,3]) cylinder(d=bolt_head_hole_dia, h=3, $fn=20);
        translate([-motor_bolt_hole_distance/2,motor_bolt_hole_distance/2,3]) cylinder(d=bolt_head_hole_dia, h=3, $fn=20);
        translate([-motor_bolt_hole_distance/2,-motor_bolt_hole_distance/2,3]) cylinder(d=bolt_head_hole_dia, h=3, $fn=20);
        translate([motor_bolt_hole_distance/2,-motor_bolt_hole_distance/2,3]) cylinder(d=bolt_head_hole_dia, h=3, $fn=20);
    }
}


module leg() {
    
    module plate() {
        hull() {
            translate([0,20,0]) cube([30,40+motor_side_length/2,5]);
            translate([7.5,20,5]) cube([15,40+motor_side_length/2,5]);
        }
    }
    
    module _leg() {
        translate([0,0,-19.5]) difference() {
            extention_finished(units=3);
            translate([-0.5,-30.5,-0.5]) cube([31,31,20]);
        }
    }
    difference() {
        union() {
            plate();
            translate([0, 30, 0]) rotate([0,0,-90]) plate();

            translate([0,30]) _leg();
        }
        #translate([15,90,0]) rotate([90,0,0]) male_dovetail(90);
        #translate([-5,15,0]) rotate([90,0,90]) male_dovetail(90);
    }
}

module leg_with_motor() {
    module support() {
        linear_extrude(height=5, convexity=2)
        polygon(points=[[0,0],[30,0],[30,10],[20,10]]);
    }
    
    union() {
        leg();
        translate([-motor_side_length/2, 28.4+motor_side_length/2+5, 5]) rotate([180,0,0]) motor_mount();
        translate([-20,33.4,0]) rotate([90,0,0]) support();
        translate([-20,38.4+motor_side_length,0]) rotate([90,0,0]) support();
    }
}


module top_guide() {
    difference() {
        cube([30,50,10]);
        #translate([15,50,0]) rotate([90,0,0]) male_dovetail(50);
    
    }
    difference() {
        hull() {
            translate([motor_side_length/2+30,9,0]) cylinder(d=18,h=10, $fn=30);
            translate([30,0,0]) cube([10,18,10]);
        }
        translate([motor_side_length/2+30,9,-0.5]) cylinder(d=10,h=11, $fn=30);
    }
}


module view_proper() {
    translate([-120, -120, 0]) leg_with_motor();
    translate([120, 120, 0]) rotate([0,0,180]) leg_with_motor();
    translate([120, -120, 0])rotate([0,0,90]) leg();
    translate([-120, 120, 0])rotate([0,0,270]) leg();
    translate([90,120-(28.4+motor_side_length/2+5)+9,-100]) rotate([180,0,0]) top_guide();
    translate([90+motor_side_length/2+30,120-(28.4+motor_side_length/2+5),-100]) %cylinder(d=10, h=150);
}

module view_parts() {
    translate([-50, -50, 0]) leg_with_motor();
    leg();
    translate([50,50]) top_guide();
}

//view_parts();
view_proper();

//top_guide();