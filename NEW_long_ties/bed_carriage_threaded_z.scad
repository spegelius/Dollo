include <../snappy-reprap/config.scad>
use <../snappy-reprap/GDMUtils.scad>
//use <../snappy-reprap/joiners.scad>
use <../snappy-reprap/acme_screw.scad>

include <globals.scad>;
include <include.scad>;

use <extention.scad>;

units = 2;

lifter_block_size = 30;
offcenter = 0;

z_lifter_hole = 10 + 2*slop;
z_lifter_arm = 10;

$fn=60;

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
        mheight = 8;
        motor_plate(mheight);
                // nut indentations
        translate([motor_bolt_hole_distance/2,motor_bolt_hole_distance/2,mheight-2]) cylinder(d=bolt_head_hole_dia, h=3, $fn=20);
        translate([-motor_bolt_hole_distance/2,motor_bolt_hole_distance/2,mheight-2]) cylinder(d=bolt_head_hole_dia, h=3, $fn=20);
        translate([-motor_bolt_hole_distance/2,-motor_bolt_hole_distance/2,mheight-2]) cylinder(d=bolt_head_hole_dia, h=3, $fn=20);
        translate([motor_bolt_hole_distance/2,-motor_bolt_hole_distance/2,mheight-2]) cylinder(d=bolt_head_hole_dia, h=3, $fn=20);
    }
}

module plate(length=40, height=10) {
    hull() {
        translate([0,0,0]) cube([30,length,height/2]);
        translate([7.5,0,height/2]) cube([15,length,height/2]);
    }
}

module leg() {
    
    module _leg() {
        translate([0,0,-19.5]) difference() {
            extention_finished(units=3);
            translate([-0.5,-30.5,-0.5]) cube([31,31,20]);
        }
    }
    difference() {
        union() {
            translate([0, 20, 0]) plate(40+motor_side_length/2);
            translate([20, 30, 0]) rotate([0,0,-90]) plate(40+motor_side_length/2);

            translate([0,30]) _leg();
        }
        #translate([15,90,0]) rotate([90,0,0]) male_dovetail(90);
        #translate([-5,15,0]) rotate([90,0,90]) male_dovetail(90);
    }
}

module leg_with_motor() {
    module support() {
        linear_extrude(height=5, convexity=2)
        polygon(points=[[0,0],[45,0],[45,30],[40,30], [20,20]]);
    }
    
    union() {
        leg();
        translate([-motor_side_length/2, 28.4+motor_side_length/2+5, 8]) rotate([180,0,0]) motor_mount();
        translate([-40,33.4,0]) rotate([90,0,0]) support();
        translate([-40,38.4+motor_side_length,0]) rotate([90,0,0]) support();
        translate([0,33.4,0]) cube([5,motor_side_length,30]);
        translate([45,33.4+motor_side_length,0]) rotate([90,0,180])  difference() {
            support();
            translate([25,0,0]) cube([10,10,5]);
            translate([0,0,0]) cube([15,20,5]);
        }
        
    }
}
//leg_with_motor();


module rod_guide_top() {
    difference() {
        cube([30,50,10]);
        #translate([15,50,0]) rotate([90,0,0]) male_dovetail(50);
    
    }
    difference() {
        hull() {
            translate([motor_side_length/2+30,9,0]) cylinder(d=18,h=10, $fn=30);
            translate([30,0,0]) cube([10,18,10]);
        }
        translate([motor_side_length/2+30,9,-0.5]) cylinder(d=hole_threaded_rod,h=11);
    }
}

module rod_guide_side() {
    difference() {
        union() {
            // side
            translate([-20,-8,0]) cube([20,28.4+motor_side_length/2+6,10]);
            // hole
            difference() {
                hull() {
                    translate([-(motor_side_length/2),28.4+motor_side_length/2+5,0]) cylinder(d=18,h=10);
                    translate([-10,28.4+motor_side_length/2-4,0]) cube([10,18,10]);
                }
                translate([-(motor_side_length/2-slop),28.4+motor_side_length/2+5+slop,0]) cylinder(d=hole_threaded_rod,h=10, $fn=30);
            }
            
            // hull
            rotate([90,0,0]) plate(30, 8);
            translate([0,30,0]) rotate([90,0,-90]) plate(30, 8);
            translate([30,30,0]) rotate([90,0,-180]) plate(30, 8);
            linear_extrude(height=30) polygon(points=[[0,0], [7.5,0], [7.5,-8], [-8,-8], [-8,7.5], [0,7.5]]);
            linear_extrude(height=30) polygon(points=[[0,22.5], [-8,22.5], [-8,38], [7.5,38], [7.5,30], [0,30]]);

        }
        #translate([15,0,40]) rotate([180,0,0]) male_dovetail(50);
        #translate([0,15,40]) rotate([180,0,-90]) male_dovetail(50);
        #translate([15,29.999,40]) rotate([180,0,-180]) male_dovetail(50);
        #translate([15,25,0]) rotate([90,0,-180]) male_dovetail(20);
    }


}
//rod_guide_side();

module z_threads() {
    
    difference() {
        
        // Lifter block
		up((offcenter+lifter_rod_diam+4)/2) {
			chamfcube(chamfer=3, size=[lifter_rod_diam+9, lifter_block_size, offcenter+lifter_rod_diam+7], chamfaxes=[0, 1, 0], center=true);
		}

		// Split Lifter block
		up((15)/2) {
			up(5) cube(size=[lifter_rod_diam*0.65, lifter_block_size+1, offcenter+lifter_rod_diam+0.05], center=true);
		}

    	// Lifter threading
		up(offcenter+groove_height/2+2) {
            yspread(printer_slop*1.5) {
				xrot(90) zrot(90) {
					acme_threaded_rod(
						d=lifter_rod_diam+2*printer_slop,
						l=lifter_block_size+2*lifter_rod_pitch+0.5,
						pitch=lifter_rod_pitch,
						thread_depth=lifter_rod_pitch/3,
						$fn=32
					);
				}
			}
			fwd(lifter_block_size/2-2/2) {
				xrot(90) cylinder(h=2.05, d1=lifter_rod_diam-2*lifter_rod_pitch/3, d2=lifter_rod_diam+2, center=true);
			}
			back(lifter_block_size/2-2/2) {
				xrot(90) cylinder(h=2.05, d1=lifter_rod_diam+2, d2=lifter_rod_diam-2*lifter_rod_pitch/3, center=true);
			}
		}

    }
}

module z_lifter() {
    
    module frame(h) {
        rotate([90,0,0]) linear_extrude(height=h, convexity=2)
        polygon(points=[[0,0],[0,20],[35,lifter_block_size],[40,lifter_block_size], [40,0]]);
    }
    difference() {
        union() {
            translate([0,-1.5,15]) rotate([90,0,0]) z_threads();
            translate([-40-(lifter_rod_diam+2)/2,0,0]) frame(offcenter+lifter_rod_diam+7);
        }
        #translate([-42, -(lifter_rod_diam+7), 5] ) cube([z_lifter_hole,lifter_rod_diam+7, z_lifter_hole]);
        #translate([-21, -(lifter_rod_diam+7), 5] ) cube([z_lifter_hole,lifter_rod_diam+7, z_lifter_hole]);
    }
}

module z_lifter_arm() {
    
    difference() {
        cube([z_lifter_arm, 50, z_lifter_arm]);
        translate([z_lifter_arm/2-0.25,0,0]) cube([0.5, lifter_rod_diam+7, z_lifter_arm]);
        translate([z_lifter_arm/2,0,z_lifter_arm/2]) rotate([-90,0,0]) cylinder(d=2.5, h=lifter_rod_diam+7, $fn=30);
        translate([-10,42,5]) rotate([0,0,-45]) cube([30,30,20]);
        hull() {
            translate([z_lifter_arm/2,33,0]) cylinder(d=bolt_hole_dia, h=z_lifter_arm, $fn=30);
            translate([z_lifter_arm/2,43,0]) cylinder(d=bolt_hole_dia, h=z_lifter_arm, $fn=30);
        }
    }
    
}

module z_lifter_arm2() {
    
    difference() {
        cube([z_lifter_arm, 70, z_lifter_arm]);
        translate([z_lifter_arm/2-0.25,0,0]) cube([0.5, lifter_rod_diam+7, z_lifter_arm]);
        translate([z_lifter_arm/2,0,z_lifter_arm/2]) rotate([-90,0,0]) cylinder(d=2.5, h=lifter_rod_diam+7, $fn=30);
        translate([-10,63,5]) rotate([0,0,-45]) cube([30,30,20]);
        hull() {
            translate([z_lifter_arm/2,54,0]) cylinder(d=bolt_hole_dia, h=z_lifter_arm, $fn=30);
            translate([z_lifter_arm/2,64,0]) cylinder(d=bolt_hole_dia, h=z_lifter_arm, $fn=30);
        }
    }
    
}

//// VIEW
module view_proper() {
    translate([-120, -120, 0]) leg_with_motor();
    translate([120, 120, 0]) rotate([0,0,180]) leg_with_motor();
    translate([120, -120, 0])rotate([0,0,90]) leg();
    translate([-120, 120, 0])rotate([0,0,270]) leg();
    translate([90,120-(28.4+motor_side_length/2+5)+9,-100]) rotate([180,0,0]) rod_guide_top();
    translate([90+motor_side_length/2+30,120-(28.4+motor_side_length/2+5),-100]) %cylinder(d=lifter_rod_diam, h=150);
    
    z_x_pos = 90+motor_side_length/2+30 + groove_height/2+3.5;
    translate([z_x_pos,120-(28.4+motor_side_length/2+5),-40]) rotate([180,0,90]) z_lifter();
    translate([z_x_pos,88-(28.4+motor_side_length/2+5),-45]) rotate([180,0,270])z_lifter_arm();
    translate([z_x_pos,109-(28.4+motor_side_length/2+5),-45]) rotate([180,0,270])z_lifter_arm2();
    
    translate([120,120,-90]) rotate([0,0,180]) rod_guide_side();
    translate([120,120,-1]) rotate([0,180,0]) mirror([0,1,0]) rod_guide_side();
}


module view_parts(part=0) {
    
    if (part == 0) {
        translate([-50, -50, 0]) leg_with_motor();
        leg();
        translate([50,50]) rod_guide_top();
        translate([-20,40]) rotate([-90,0,0]) z_lifter();
        translate([-20,75]) z_lifter_arm();
        translate([-35,75]) z_lifter_arm2();
        translate([-75,85]) rod_guide_side();
        translate([-130,115]) mirror([0,1,0]) rod_guide_side();
    } else if (part == 1) {
        leg_with_motor();
    } else if (part == 2) {
        leg();
    } else if (part == 3) {
        rod_guide_top();
    } else if (part == 4) {
        rod_guide_side();
    } else if (part == 5) {
        z_lifter();
    } else if (part == 6) {
        z_lifter_arm();
    } else if (part == 7) {
        z_lifter_arm2();
    }
}

view_parts(0);
//view_proper();

//z_lifter_arm();
//z_lifter();