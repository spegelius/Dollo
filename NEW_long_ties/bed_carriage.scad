
include <globals.scad>;
include <include.scad>;

use <extention.scad>;
use <rail.scad>;
use <z_screw.scad>;
use <long_tie.scad>;
use <endstop.scad>;

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
    rail(rail_width, 120);
}

module bed_rail_short() {
    // 60 mm = 2x30mm from corners
    // 2 mm = rail coupler thickness
    intersection() {
        translate([0,0,-60-2]) bed_rail();
        cylinder(d=rail_width*1.5, h=120);
    }
}

module bed_rail_center() {
    rail_center(length=120, width=rail_width/2);
}

module bed_rail_center_short() {
    intersection() {
        translate([0,0,-1]) bed_rail_center();
        cylinder(d=rail_width,h=120);
    }
}

module debug_bed_rail() {
    intersection() {
        union() {
            bed_rail_short();
            translate([0,0,60-2]) bed_rail();
            translate([0,0,120+60-2]) bed_rail();
            bed_rail_center_short();
            translate([0,0,120-1]) bed_rail_center();
        }
        translate([0,15,0]) cube([30,30,400], center=true); 
    }
}

module bed_rail_frame_mount(bridge_extra=0) {
    
    h = 139;
    hx_w = rail_width+slop;
    
    module rail_hole() {
        difference() {
            hull() {
                hexagon(hx_w+9,0.01);
                hexagon(hx_w+6,2);
            }
            hexagon(hx_w,2);
        }
    }
    
    module hook() {
        difference() {
            hull() {
                translate([0,0,27/2]) cube([14,1,27], center=true);
                translate([-14/2,0-19/2,16+3]) rotate([0,90,0]) cylinder(d=16,h=14);
            }
            translate([-10,-15/2-2,19]) rotate([0,90,0]) cylinder(d=10,h=20, $fn=40);
        }
    }

    union() {
        difference() {
            union() {
                translate([0,3.5,0]) cube([30+7*2, 25+slop, h], center=true);
                translate([0,-8.5,h/2-27]) hook();
                translate([0,-8.5,-h/2+27]) mirror([0,0,1]) hook();
                translate([0,-(15+2)/2-1,0]) cube([14,2,90], center=true);
            }
            translate([0,6,0]) cube([30+slop, 25+slop, h+1], center=true);
            translate([0,-6.5-slop/2,h/2-30]) rotate([0,0,180]) male_dovetail(30,bridge_extra=bridge_extra);
            translate([0,-6.5-slop/2,-h/2]) rotate([0,0,180]) male_dovetail(30,bridge_extra=bridge_extra);

            hull() {
                translate([0,19,18]) rotate([45,0,0]) cube([45,30,30], center=true);
                translate([0,19,-18]) rotate([45,0,0]) cube([45,30,30], center=true);
            }
            translate([34/2+25/2-1,10,0]) rotate([90,0,0]) cylinder(d=z_screw_d+slop, h=20, $fn=50);
            translate([-34/2-25/2+1,10,0]) rotate([90,0,0]) cylinder(d=z_screw_d+slop, h=20, $fn=50);
            translate([-16,-8,0]) cube([1,5,0.4], center=true);
            translate([16,-8,0]) cube([1,5,0.4], center=true);

            translate([0,-(15+slop)/2,30]) rotate([90,0,0]) hexagon(hx_w);
            translate([0,-(15+slop)/2,-30]) rotate([90,0,0]) hexagon(hx_w);

            difference() {
                union() {
                    translate([15,8.5+slop/2,-h/2]) rotate([0,0,-90]) male_dovetail(h);
                    translate([-15,8.5+slop/2,-h/2]) rotate([0,0,90]) male_dovetail(h);
                }
                hull() {
                    translate([0,19,18.5]) rotate([45,0,0]) cube([45,30,30], center=true);
                    translate([0,19,-18]) rotate([45,0,0]) cube([45,30,30], center=true);
                }

            }
            
        }
        translate([0,-(15+2)/2,30]) rotate([90,0,0]) rail_hole();
        translate([0,-(15+2)/2,-30]) rotate([90,180,0]) rail_hole();

    }
    
    %translate([-15,-6.5,30]) rotate([-90,0,0]) extention();
}

module bed_rail_frame_mount_top() {
    translate([0,0,-(25+slop)/2+3.5+2.5]) rotate([-90,0,0]) intersection() {
        bed_rail_frame_mount(bridge_extra=0.2);
        cube([30,26,150], center=true);
    }
}

module _slide_hull(width=rail_width, height=20) {
    hull() {
        translate([0,0,2.1]) rail_slide(width=width, height=height-4.2, wiggles=1);
        rail_slide(width=width-2.4, height=height, wiggles=1);
    }
}

module bed_rail_slide(beweled=false, slop=0) {
    h = 40;
    intersection() {
        rail_slide(width=rail_width, height=h, wiggles=18,slop=slop);
        if (beweled) {
            _slide_hull(height=h);
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

            translate([29,30,-5]) _slide_hull(width=rail_width, height=40);
            translate([29,-30,-5]) _slide_hull(width=rail_width, height=40);

            translate([-41,0,30/2-5]) cube([30,61,30],center=true);
            translate([-19,30,-0.01]) rotate([0,0,180]) male_dovetail(25-2);
            
            translate([65/2+4.5,0,-0.01]) rotate([0,0,90]) male_dovetail(25-2);

            translate([-19,-30,-0.01]) rotate([0,0,0]) male_dovetail(25-2);

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
        rotate([0,0,-12+1/3*360]) screw_housing_top(frame_width=27.5);
        difference() {
            translate([3,1,0]) cube([25+25.5, 25+22.5, 100],center=true);
            for (i = [0:2]) {
                rotate([0,0,-12+i*1/3*360]) translate([27.5,0,0]) cylinder(d=10,h=40, $fn=30);
            }
        }
    }
}

module bed_housing_coupler() {
    union() {
        difference() {
            union() {
                cube([10,40,30]);
                translate([10,0,0]) cube([25,10,60]);
            }
            translate([10,25,0]) rotate([0,0,90]) male_dovetail(31);
            translate([25,10,0]) rotate([0,0,180]) male_dovetail(61);
        }
        translate([3,40,30]) scale([0.95,1,1]) long_tie(23);
    }
}

module endstop_screw_mount() {
    difference() {
        union() {
            translate([-5,-0.01,0]) cube([10,3,23]);
            translate([-5,0,0]) cube([10,14,8]);
            translate([0,14.5,0]) cylinder(d=12,h=8, $fn=40);
            rotate([-90,0,180]) long_tie(23);
        }
        translate([0,14.5,0]) _threads(h=15);
    }
}

module _screw_knob(h=10) {
    h1 = h/5;
    h2 = h-2*h1;
    difference() {
            union() {
                cylinder(d1=15-2*h1, d2=15,h=h1, $fn=40);
                translate([0,0,h1]) cylinder(d=15,h=h2, $fn=40);
                translate([0,0,h-h1]) cylinder(d2=15-2*h1, d1=15,h=h1, $fn=40);
            }
            for (i=[0:11]) {
                rotate([0,0,i*360/12]) translate([15/2,0,0]) cylinder(d=2,h=10,$fn=20);
            }
    }
}

module endstop_screw() {
    
    union() {
        translate([0,0,10]) _threads(8-3*slop, 28);
        _screw_knob();
    }
}

module endstop_screw_nut() {
    difference() {
        _screw_knob(h=7);
        _threads(h=15);
    }
}

module _bed_attach_body() {
    difference() {
        union() {
            cube([70,30,15]);
            translate([40,20,0]) cube([30,10,50]);
        }
        translate([70-15,30,0]) rotate([0,0,180]) male_dovetail(50);
        translate([0,15,15]) rotate([-90,0,-90]) male_dovetail(30);

        translate([70-30,0,15]) rotate([0,-45,0]) cube([50,50,50]);
        translate([70/2,0,0]) rotate([45,0,0]) cube([70,10,10],center=true);
        translate([70/2,30,0]) rotate([45,0,0]) cube([70,10,10],center=true);
    }
}

module _spring() {
    module spring_half() {
        intersection() {
            translate([-100/2+6,0,0]) difference() {
                cylinder(d=100,h=15,$fn=100);
                cylinder(d=100-3,h=15.1,$fn=100);
            }
            translate([0,-100,0]) cube([200,200,200]);
        }
    }

    spring_half();
    mirror([1,0,0]) spring_half();
}

//_spring();

module bed_attachment_spring() {
    %translate([0,0,3]) cube([200,213,3], center=true);
    %view_bed_frame();

    module triangle(h=15) {
        intersection() {
            linear_extrude(h) polygon(points=[[0,0],[0,4],[4,0]]);
            cube([3,3,h]);
        }
    }

    module clip() {
        difference() {
            union() {
                _spring();
                translate([6-1.5,-15/2,0]) cube([2, 15, 30]);
                translate([6+.5,-15/2,0]) cube([3, 22, 30]);
                translate([6+3.5,-2,18.5]) rotate([-90,0,0]) triangle();
                translate([6+3.5,10,18.5]) rotate([0,0,0]) triangle(11.5);

                translate([-22+6,-17/2,0]) cube([22-6-6+1.5,17, 15]);
                translate([8,-50,0]) rotate([0,0,90])difference() {
                    _bed_attach_body();
                    translate([25,0,0]) cube([50,15,15]);
                }
            }
            translate([-22+8,0,15/2]) rotate([0,90,0]) cylinder(d=8,h=40,$fn=40);

            translate([-22+8,-12/2,0]) cube([7,12,16]);
            translate([6-1.5,-15/2,15]) rotate([45,0,0]) cube([6,30,20]);
        }
    }

    clip();
    //translate([90,-125,-8]) rotate([0,-90,-90]) clip();
    //translate([90,-125+15/2,5]) rotate([180,0,0]) bed_attachment_spring_screw(true);
}

module bed_attachment_spring_screw(render_threads=true) {
    h = 21;
    union() {
        difference() {
            _screw_knob(3);
            cube([1.3, 5, 3], center=true);
        }
        translate([0,0,3]) {
            if (render_threads) {
                _threads(8-3*slop, h);
            } else {
                cylinder(d=8,h=h, $fn=40);
            }
        }
    }
}

module bed_attachment_spring_nut() {
    difference() {
        translate([0,0,6.8/2]) chamfered_cube(14.5,11.5,6.5,1, center=true);
        _threads(h=15);
    }
}

module view_bed_frame() {
    translate([-95,95,0]) rotate([90,0,45]) bed_carriage_corner();
    translate([-95,-95,0]) rotate([90,0,135]) bed_carriage_corner();
    translate([95,95,0]) rotate([90,0,-45]) bed_carriage_corner();
    translate([95,-95,0]) rotate([90,0,225]) bed_carriage_corner();
    translate([-110,-60,-30]) rotate([-90,0,0]) extention_finished();
}

module view_proper() {
    
    bed_position = 160;
    
    frame_mockup(bed_angle=0, units_x=2, units_y=2, units_z=1);
    
    translate([0,0,bed_position+40]) view_bed_frame();

    translate([-120-45,0,30-6.5]) rotate([-90,0,0]) bed_rail_frame_mount();
    translate([-120-45,0,210]) rotate([180,0,0]) bed_rail_frame_mount_top()

    translate([-120-45,-30,32]) bed_rail_short();
    translate([-120-45,30,32]) bed_rail_short();
    translate([-120-45,-30,88]) bed_rail();
    translate([-120-45,30,88]) bed_rail();

    translate([-120-16,0,-5]) cylinder(d=25,h=120+89);
    translate([-120-16,0,bed_position+40]) rotate([180,0,180]) bed_screw_housing(render_threads=false);

    translate([-120,60,bed_position]) rotate([90,0,0]) bed_housing_coupler();
    translate([-120,-60,bed_position]) mirror([0,1,0]) rotate([90,0,0]) bed_housing_coupler();

    translate([-120-45,30,bed_position+15]) bed_rail_slide(true);

    //translate([-130-45,15,130]) rotate([0,90,-90]) bed_rail_slide_arm_1();
    //translate([-130-45,-15,130]) rotate([0,-90,-90]) bed_rail_slide_arm_2();
    
    translate([-120-60,15,225]) rotate([0,180,90]) z_endstop();
    translate([-120-53.1,0,bed_position+40]) rotate([180,0,-90]) endstop_screw_mount();
    translate([-120-53.1-14.5,0,bed_position+40-25]) endstop_screw();
}

module slide_test_parts() {
    intersection() {
        bed_rail_slide(true);
        cube([40,40,20], center=true);
    }
    translate([30,0,0]) intersection() {
        bed_rail_slide(true, slop=0.1);
        cube([40,40,20], center=true);
    }
    translate([0,30,0]) intersection() {
        bed_rail_slide(true, slop=0.2);
        cube([40,40,20], center=true);
    }
}

//debug_bed_rail();
//intersection() {
//    bed_screw_housing(render_threads=false);
//    translate([10.5,-22,0])cube([50,50,50]);
//}

//view_proper();

//slide_test_parts();

//bed_carriage_corner();
//bed_rail();
//bed_rail_short();
//bed_rail_center();
//bed_rail_frame_mount();
//bed_rail_frame_mount_top();
bed_rail_slide(true);
//bed_screw_housing(render_threads=false);
//bed_screw_housing(render_threads=true);
//bed_screw_housing_top();
//translate([5,0,0])bed_housing_coupler();
//mirror([1,0,0]) bed_housing_coupler();
//endstop_screw_mount();
//endstop_screw();
//endstop_screw_nut();
//bed_attachment_spring();
//mirror([1,0,0]) bed_attachment_spring();
//bed_attachment_spring_screw();
//bed_attachment_spring_nut();