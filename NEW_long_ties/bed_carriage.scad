
include <globals.scad>;
include <include.scad>;

use <extention.scad>;
use <rail.scad>;

// 1 unit = 30mm
z_units = 4; 

rail_width = 15;

module bed_carriage_corner() {
    
    module extention_rotated() {
        intersection() {
            rotate([0,45,0]) translate([-15,0,-25]) extention_finished(2);
            translate([0,-35,0]) cube([100,40,100]);
        }
    }
    extention_rotated();
    mirror([1,0,0]) extention_rotated();
}

module bed_rail() {
    rail(120, rail_width);
}

module bed_rail_end() {
    difference() {
        union() {
            rail(30, rail_width);
            rotate([-90,0,0]) cylinder(d=rail_width-2, h=male_dove_depth+1);
        }
        translate([0,0,-rail_width]) male_dovetail(rail_width*2);
    }
}

module _slide_hull(width=rail_width, height=20) {
    hull() {
        translate([0,0,2.1]) rail_slide(width=width, height=height-4.2, wiggles=1);
        rail_slide(width=width-2.4, height=height, wiggles=1);
    }
}

module bed_rail_slide() {
    intersection() {
        rail_slide(width=rail_width, height=20, wiggles=7);
        _slide_hull();
    }
}

module _bed_rail_slide_arm() {
    
    difference() {
        union() {
            cube([20,25,15]);
            translate([0,25,15]) intersection() {
                translate([0,0,15]) rotate([0,0,-25]) rotate([-90,0,0]) chamfered_cube_side(20,30,60,4);
                translate([0,-10,-15]) cube([50,60,15]);
            }
            intersection() {
                translate([20,53,0]) chamfered_cube(30,35,30,4);
                translate([20,53,0]) cube([30,35,15]);
            }
        }

        translate([0,10,15]) rotate([90,0,0]) rotate([0,90,0]) _slide_hull(width=rail_width+slop);
        translate([10,65,-0.1]) cube([30,40,20]);
        translate([25,65,-0.1]) rotate([0,0,180]) male_dovetail(20);
        translate([40,80,-0.1]) rotate([0,0,-90]) male_dovetail(20);
    }

}

module bed_rail_slide_arm_1() {
    difference() {
        _bed_rail_slide_arm();
        translate([13.4,30,-1]) _threads(d=8, h=20, z_step=1.8, depth=0.5, direction=0);
        translate([20,45,15]) rotate([0,0,-25]) rotate([0,45,0]) cube([5,20,5],center=true);
    }
}

module bed_rail_slide_arm_2() {
    rotate([0,180,0]) mirror([0,0,1]) union() {
        difference() {
            _bed_rail_slide_arm();
            translate([13.4,30,-1]) cylinder(d=8,h=17, $fn=30);
        }
        translate([20,45,15-slop]) rotate([0,0,-25]) rotate([0,45,0]) cube([5,20-slop,5],center=true);
    }
}


module view_proper() {
    frame_mockup(bed_angle=0, units_x=2, units_y=2, units_z=1);
    translate([-95,95,120]) rotate([90,0,45]) bed_carriage_corner();
    translate([-95,-95,120]) rotate([90,0,135]) bed_carriage_corner();
    translate([95,95,120]) rotate([90,0,-45]) bed_carriage_corner();
    translate([95,-95,120]) rotate([90,0,225]) bed_carriage_corner();
    
    %translate([-110,-60,90]) rotate([-90,0,0]) extention_finished();
    
    translate([-120-45,0,30]) rotate([90,0,0]) bed_rail_end();
    translate([-120-45,0,120+90]) rotate([-90,0,0]) bed_rail_end();
    translate([-120-45,0,60]) rotate([90,0,0]) bed_rail();
    
    translate([-120-45,0,110]) bed_rail_slide();
    
    translate([-130-45,15,130]) rotate([0,90,-90]) bed_rail_slide_arm_1();
    translate([-130-45,15,130]) rotate([0,90,-90]) bed_rail_slide_arm_2();
    
}

//view_proper();

bed_carriage_corner();
//bed_rail_end();
//bed_rail_slide();
//bed_rail_slide_arm();

//bed_rail_slide_arm_1();
//bed_rail_slide_arm_2();