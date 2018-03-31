
include <globals.scad>;
include <include.scad>;

use <extention.scad>;
use <rail.scad>;
use <z_screw.scad>;
use <long_tie.scad>;

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
    rotate([90,0,0]) rail(120, rail_width);
}

module bed_rail_frame_mount() {
    
    h = 137;
    hx_w = rail_width+slop;
    
    module rail_hole() {
        difference() {
            hull() {
                hexagon(hx_w+9,0.01);
                hexagon(hx_w+6,2);
            }
            hexagon(hx_w,2);
        }
        translate([0,hx_w/2+5/2+1,2/2]) cube([12,5,2], center=true);
    }
    
    module half_tie() {
        difference() {
            translate([0,0,30]) rotate([90,0,0]) long_tie_half(30);
            rotate([0,-45,0]) translate([-10,-5,0]) cube([10,10,10]);
        }
    }
    
    module hook() {
        difference() {
            translate([0,-15/2,27/2]) cube([12,18,27], center=true);
            rotate([45,0,0]) translate([0,-15/2,10]) cube([13,15,40], center=true);
            translate([-10,-15/2-2,20]) rotate([0,90,0]) cylinder(d=10,h=20, $fn=40);
        }
    }

    union() {
        difference() {
            union() {
                cube([34, 15+2+slop, h], center=true);
                translate([0,-8.5,h/2-27]) hook();
                translate([0,-8.5,-h/2+27]) mirror([0,0,1]) hook();
            }
            translate([0,2,0]) cube([30, 15+2+slop, h+1], center=true);
            translate([0,-6.5-slop/2,h/2-23]) rotate([0,0,180]) male_dovetail(23);
            translate([0,-6.5-slop/2,-h/2]) rotate([0,0,180]) male_dovetail(23);

            hull() {
                translate([0,11,20]) rotate([45,0,0]) cube([35,22,22], center=true);
                translate([0,11,-20]) rotate([45,0,0]) cube([35,22,22], center=true);
            }
            translate([34/2+25/2-1,10,0]) rotate([90,0,0]) cylinder(d=25, h=20, $fn=50);
            translate([-34/2-25/2+1,10,0]) rotate([90,0,0]) cylinder(d=25, h=20, $fn=50);

            translate([0,-(15+slop)/2,30]) rotate([90,0,0]) hexagon(hx_w);
            translate([0,-(15+slop)/2,-30]) rotate([90,0,0]) hexagon(hx_w);

        }
        translate([0,-(15+2)/2,30]) rotate([90,0,0]) rail_hole();
        translate([0,-(15+2)/2,-30]) rotate([90,180,0]) rail_hole();

        translate([15,8.5+slop/2,h/2-30]) half_tie();
        translate([-15,8.5+slop/2,h/2-30]) mirror([1,0,0]) half_tie();

        translate([15,8.5+slop/2,-h/2+30]) mirror([0,0,1]) half_tie();
        translate([-15,8.5+slop/2,-h/2+30]) mirror([0,0,1]) mirror([1,0,0]) half_tie();
    }
    
    %translate([-15,-6.5,30]) rotate([-90,0,0]) extention();
}

module bed_rail_center() {
    l = (30-male_dove_depth-2)*2;
    rail_center(length=l, width=rail_width/2-slop);
}

module bed_rail_bottom() {
    difference() {
        union() {
            rail(30, rail_width);
            rotate([-90,0,0]) cylinder(d=rail_width-2, h=male_dove_depth+1);
        }
        translate([0,0,-rail_width]) male_dovetail(rail_width*2);
    }
}

module bed_rail_top() {
    mirror([1,0,0]) bed_rail_bottom();
}

module _slide_hull(width=rail_width, height=20) {
    hull() {
        translate([0,0,2.1]) rail_slide(width=width, height=height-4.2, wiggles=1);
        rail_slide(width=width-2.4, height=height, wiggles=1);
    }
}

module bed_rail_slide(beweled=false) {
    intersection() {
        rail_slide(width=rail_width, height=30, wiggles=8);
        if (beweled) {
            _slide_hull(height=30);
        }
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

module bed_screw_housing(render_threads=true) {
    union() {
        difference() {
            union() {
                translate([4.5,0,25/2]) cube([65,60,25], center=true);
                translate([29,30,0]) cylinder(d=37,h=25, $fn=50);
                translate([29,-30,0]) cylinder(d=37,h=25, $fn=50);
            }
            translate([0,0,1.2]) intersection() {
                difference() {
                    union() {
                        translate([0,0,13]) cylinder(d=25+28+2*slop, h=30, $fn=100);
                        cylinder(d=25+28-2, h=13.1, $fn=100);
                    }
                    rotate([0,0,12]) screw_housing_bottom(frame_width=28,render_threads=render_threads);
                }
                translate([3,-1,0]) cube([25+26, 25+23, 100],center=true);
            }
            translate([0,0,-30]) rotate([0,0,12]) cylinder(d=25+1,h=40, $fn=50);

            translate([29,30,0]) _slide_hull(width=rail_width, height=40);
            translate([29,-30,0]) _slide_hull(width=rail_width, height=40);

            translate([-41,0,30/2-5]) cube([30,61,30],center=true);
            translate([-19,30,2]) rotate([0,0,180]) male_dovetail(31);

            translate([-19,-30,2]) rotate([0,0,0]) male_dovetail(31);

            translate([37,-43.3,-1]) rotate([0,0,30]) cube([1,10,60],center=true);
            translate([37,43.3,-1]) rotate([0,0,-30]) cube([1,10,60],center=true);

            translate([28,48.3,-2]) rotate([-45,0,0]) cube([40,10,20],center=true);
            translate([28,-48.3,-2]) rotate([45,0,0]) cube([40,10,20],center=true);

            translate([28,48.3,27]) rotate([45,0,0]) cube([40,10,20],center=true);
            translate([28,-48.3,27]) rotate([-45,0,0]) cube([40,10,20],center=true);
        }
    }
}

module bed_screw_housing_top() {
    intersection() {
        rotate([0,0,-12+1/3*360]) screw_housing_top(frame_width=28);
        translate([3,1,0]) cube([25+26, 25+23, 100],center=true);
    }
}

module bed_housing_coupler() {
    difference() {
        union() {
            cube([10,40,30]);
            translate([10,0,0]) cube([25,10,50]);
        }
        translate([10,25,0]) rotate([0,0,90]) male_dovetail(31);
        translate([25,10,0]) rotate([0,0,180]) male_dovetail(51);
    }
    translate([3,40,30]) long_tie(23);
}

module view_proper() {
    frame_mockup(bed_angle=0, units_x=2, units_y=2, units_z=1);
    translate([-95,95,120]) rotate([90,0,45]) bed_carriage_corner();
    translate([-95,-95,120]) rotate([90,0,135]) bed_carriage_corner();
    translate([95,95,120]) rotate([90,0,-45]) bed_carriage_corner();
    translate([95,-95,120]) rotate([90,0,225]) bed_carriage_corner();
    
    %translate([-110,-60,90]) rotate([-90,0,0]) extention_finished();

    translate([-120-45,0,30-6.5]) rotate([-90,0,0]) bed_rail_frame_mount();
    translate([-120-45,-30,30]) bed_rail();

    translate([-120-45,30,30]) bed_rail();

    translate([-120-16,0,-5]) cylinder(d=25,h=120+89);
    translate([-120-16,0,95]) rotate([0,0,180]) bed_screw_housing(render_threads=false);

    translate([-120,60,80]) rotate([90,0,0]) bed_housing_coupler();

    translate([-120-45,30,95]) bed_rail_slide(true);

    //translate([-130-45,15,130]) rotate([0,90,-90]) bed_rail_slide_arm_1();
    //translate([-130-45,-15,130]) rotate([0,-90,-90]) bed_rail_slide_arm_2();
    
}

//view_proper();

//bed_carriage_corner();
//bed_rail();
bed_rail_frame_mount();
//bed_rail_center();
//bed_rail_bottom();
//bed_rail_top();
//bed_rail_slide(true);
//bed_rail_slide_arm();
//bed_screw_housing(render_threads=false);
//bed_screw_housing(render_threads=true);
//intersection() {
//    bed_screw_housing(render_threads=false);
//    translate([10.5,-22,0])cube([50,50,50]);
//}
//bed_screw_housing_top();
//bed_housing_coupler();
