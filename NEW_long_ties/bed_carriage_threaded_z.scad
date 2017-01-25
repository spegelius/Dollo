include <../snappy-reprap/config.scad>
use <../snappy-reprap/GDMUtils.scad>
//use <../snappy-reprap/joiners.scad>
use <../snappy-reprap/acme_screw.scad>

include <globals.scad>;
include <include.scad>;

use <extention.scad>;
use <corner_stabilizer.scad>;
use <rail.scad>;

$fn=60;

//// tunables
units = 2;


lifter_block_size = 30;
offcenter = 0;

z_lifter_hole = 10 + 2*slop;
z_lifter_arm = 10;

//jointed_nut_height = sqrt((12*12)/2)*2;
jointed_nut_height = 10;

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

module lifter_threading(extra_slop=0) {
    // Lifter threading
    
        yspread(printer_slop*1.5) {
            xrot(90) zrot(90) {
                acme_threaded_rod(
                    d=lifter_rod_diam+2*printer_slop+extra_slop,
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
        up(offcenter+groove_height/2+2) {
            lifter_threading();
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

module rail_holder() {
    
    module clamp() {
        union() {
            difference() {
                translate([0,0,7]) cube([35,10,25]);
                translate([17.5, 0, motor_side_length/2+1]) rail(20, 20+slop, false);
                translate([17.5, 0, motor_side_length/1.5]) cube([13,25,7],center=true);
            }
            translate([24,0,32]) difference() {
                cube([6,10,10]);
                translate([0,5,5]) rotate([0,90,0]) cylinder(d=bolt_hole_dia, h=10);
                translate([3.8,5,5]) rotate([0,90,0]) nut();
            }
            translate([5,0,32]) difference() {
                cube([6,10,10]);
                translate([0,5,5]) rotate([0,90,0]) cylinder(d=bolt_hole_dia, h=10);
            }
        }
    }
    
    union() {
        difference() {
            stabilizer(false);
            translate([28.4+motor_side_length/2+5,0,motor_side_length/2]) rotate([-90,0,0]) cylinder(d=40, h=35);
            translate([30,30,0]) cube([100,100,10]);
            translate([-1,80,0]) cube([35,70,10]);
        }
        translate([0,5,0]) clamp();
        translate([110,5,0]) mirror([1,0,0]) clamp();
    }
    %translate([17.5, 3, motor_side_length/2+1]) rotate([0,0,0]) rail(150, 20);
    %translate([92.5, 3, motor_side_length/2+1]) rotate([0,0,0]) rail(150, 20);
}

// not used, too much slack
module jointed_nut() {
    
    width = 35;
    length = 28;
    $fn=80;
    
    module slit() {
        translate([-10,4,0]) rotate([90,0,0]) difference() {
            cube([20, 20,8]);
            translate([0,10,0]) cylinder(d=15,h=11);
            translate([20,10,0]) cylinder(d=15,h=11);
        }
        
    }

    module slits() {
        for (i = [1:4]) {
            rotate([0,0,i*90+45]) translate([0,8.5,-10]) slit();
        }

    }
    
    module center() {
        intersection() {
            cube([40,40,jointed_nut_height], center=true);
            sphere(d=20-slop*3);
        }
        intersection() {
            union() {
                for (i = [1:4]) {
                    rotate([0,0,i*90+45]) translate([0,9.5,0]) cube([5-slop,7,jointed_nut_height],center=true);
                }
            }
            sphere(d=25-slop*2);
        }
        
    }
    
    difference() {
        cube([width,length,jointed_nut_height], center=true);
        sphere(d=20);
        slits();
    }
    difference() {
        center();
        rotate([-90,0,0]) lifter_threading();

    }
}

module rail_slide() {
    difference() {
        union() {
            difference() {
                intersection() {
                    translate([8,-15.5,0]) cube([60,45.5,jointed_nut_height]);
                    union() {
                        translate([6,-20,0]) rotate([0,0,-30]) cube([35,95,jointed_nut_height]);
                        translate([40,-40,0]) rotate([0,0,30]) cube([35,95,jointed_nut_height]);
                    }
                }
            }
            slide(40, 14);
            translate([75,0,0]) slide(40, 14);
            //translate([37.5, 1, jointed_nut_height/2]) jointed_nut();

        }
        translate([-29,motor_side_length/2-6.5,0]) cube([43.5,30,50]);
        translate([0,20,jointed_nut_height/2]) cube([80,30,jointed_nut_height]);
        difference() {
            for(i=[0:5]) {
                translate([19+i*9,25,0]) {
                    cylinder(d=bolt_hole_dia, h=jointed_nut_height);
                    nut();
                }
            }
        }
        translate([37.5, 1, jointed_nut_height/2]) rotate([-90,0,0]) lifter_threading(0.3);
        translate([37.5, 1, 5]) cylinder(d=15, h=10);
    }
    
}

module slide_bed_adapter() {
    difference() {
        cube([53.5,50,10]);
        translate([-1,-1,5]) cube([61,11,10]);

        //bolt holes
        translate([4.5,5,0]) cylinder(d=bolt_hole_dia, h=11);
        translate([4.5+5*9,5,0]) cylinder(d=bolt_hole_dia, h=11);
        translate([4.5,5,-1]) cylinder(d=bolt_head_hole_dia, h=3.5);
        translate([4.5+5*9,5,-1]) cylinder(d=bolt_head_hole_dia, h=3.5);

        translate([0,12.5,-1]) rotate([0,0,40]) cube([70,50,8]);
        translate([0,28,-1]) rotate([0,0,40]) cube([70,50,15]);
        
        //bolt holes
        rotate([0,0,40]) {
            translate([17,15,0]) cylinder(d=bolt_hole_dia, h=11);
            translate([52,15,0]) cylinder(d=bolt_hole_dia, h=11);
            translate([17,15,9]) cylinder(d=bolt_head_hole_dia, h=2.5);
            translate([52,15,9]) cylinder(d=bolt_head_hole_dia, h=2.5);
        }

    }
}

module threads(d=8, multiple=10) {
    z_step = 1.8;
    for (i = [0:multiple-1]) {
        translate([0,0,i*z_step]) linear_extrude(height=z_step, center=true, convexity = 10, twist = -360, $fn = 30) translate([0.5, 0, 0]) circle(d=d-0.5);
    }
}

module _nut(d=8, d2=18, h=7, indents=20) {
    $fn=60;
    sphere_dia=d2+h/1.8;
    intersection() {
        difference() {
            cylinder(d=d2,h=h);
            threads(d=d+4*slop, multiple=h);
            for (i = [0:indents-1]) {
                rotate([0,20,i*360/indents]) translate([-2,d2/2+2,0]) rotate([0,0,45]) cube([4,4,35], center=true);
            }
        }
        translate([0,0,h-sphere_dia/3]) sphere(d=sphere_dia);
        translate([0,0,sphere_dia/3]) sphere(d=sphere_dia);
    }
}

module slide_bed_adapter2(nuts=true) {
    difference() {
        rotate([0,0,54.3]) translate([0,-30,0]) difference() {
            cube([250,60,10]);
            for (j=[0:4]) {
                //for(i=[0:15-j]) {
                //    translate([j*2+102+i*7,5+j*7,0]) cylinder(d=bolt_hole_dia, h=11);
                //}
                translate([102,8+j*11,0]) hull(){ 
                    cylinder(d=bolt_hole_dia, h=11);
                    translate([105-j*8,0,0]) cylinder(d=bolt_hole_dia, h=11);
                }
                
            }
            
            translate([88,10,0]) cylinder(d=8,h=6);
            translate([88,50,0]) cylinder(d=8,h=6);
        }
        
        translate([80,182.5,-1]) cube([200,200,20]);
        translate([148,140,-1]) cube([200,200,20]);
        translate([80,172.5,-1]) cube([200,200,6]);
        
        translate([-50,-50,5]) cube([200,210,6]);
        
        rotate([0,0,54.3]) translate([-50,-50,-1]) cube([130,90,10]);
        
        //bolt holes
        translate([143.5,177.5,0]) cylinder(d=bolt_hole_dia, h=11);
        translate([143.5-5*9,177.5,0]) cylinder(d=bolt_hole_dia, h=11);
        translate([143.5,177.5,8]) cylinder(d=bolt_head_hole_dia, h=3.5);
        translate([143.5-5*9,177.5,8]) cylinder(d=bolt_head_hole_dia, h=3.5);
       
    }
    
    module triangle() {
        linear_extrude(6) polygon(points=[[0,0], [0,20], [20,20]]);
    }
    
    module holes() {
        for(i=[0:4]) {
            translate([-80+i*33,4,0]) triangle();
        }
        for(i=[0:4]) {
            translate([-52.5+i*33,24,0]) rotate([0,0,180]) triangle();
        }
    }
    
    rotate([0,0,54.3]) translate([120,65,0]) difference() {
        translate([0,0,2.5]) cube([190,60,5],center=true);
        translate([88,20,0]) cylinder(d=8,h=6);
        translate([88,-20,0]) cylinder(d=8,h=6);
        
        translate([-88,20,0]) cylinder(d=8,h=6);
        translate([-88,-20,0]) cylinder(d=8,h=6);



        holes();
        mirror([0,1,0]) holes();
    }
    diameter=1;
    union() {
        intersection() {
            rotate([-90,0,0]) threads(d=7, multiple=10);
            cube([7,20,6.5], center=true);
        }
        translate([0,-2.5,0]) rounded_cube(20,5,6.5,diameter=2);
    }
    
    //translate([20,0,0]) _nut(d=7, d2=15, h=5, indents=22);
}

//// VIEW
module view_proper() {
    frame_mockup(0, 2);
    //translate([-180, -180, 0]) rotate([180,0,90]) leg_with_motor();
    //translate([180, 180, 0]) rotate([180,0,-90]) leg_with_motor();

    //translate([180, -180, 0])rotate([180,0,180]) leg();
    //translate([-180, 180, 0])rotate([180,0,0]) leg();
    ////translate([90,120-(28.4+motor_side_length/2+5)+9,-100]) rotate([180,0,0]) rod_guide_top();
    //%translate([-180+(28.4+motor_side_length/2+5),-180-motor_side_length/2,0]) cylinder(d=lifter_rod_diam, h=450);
    //%translate([-180+(28.4+motor_side_length/2+5),-180-motor_side_length/2,1]) cylinder(d=35, h=29);
    
    
    ////z_x_pos = 90+motor_side_length/2+30 + groove_height/2+3.5;
    ////translate([z_x_pos,120-(28.4+motor_side_length/2+5),80]) rotate([180,0,90]) z_lifter();
    ////translate([z_x_pos,88-(28.4+motor_side_length/2+5),75]) rotate([180,0,270])z_lifter_arm();
    ////translate([z_x_pos,109-(28.4+motor_side_length/2+5),75]) rotate([180,0,270])z_lifter_arm2();
    
    ////translate([120,120,-10]) rotate([0,0,180]) rod_guide_side();
    ////translate([120,120,110]) rotate([0,180,0]) mirror([0,1,0]) rod_guide_side();
    //translate([-180,-180,0]) rotate([90,0,0]) rail_holder();
    //translate([-180,-180,360]) rotate([90,0,0]) mirror([0,1,0]) rail_holder();

    translate([-162.5,-181-motor_side_length/2,34]) rail_slide();
    //translate([-94.5,-161-motor_side_length/2,44]) rotate([0,180,0]) slide_bed_adapter();
    
    translate([0,0,34]) rotate([0,0,180]) slide_bed_adapter2();
    
    
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
    } else if (part == 8) {
        rail_holder();
    } else if (part == 9) {
        jointed_nut();
    } else if (part == 10) {
        rail_slide();
    } else if (part == 11) {
        slide_bed_adapter();
    } else if (part == 12) {
        slide_bed_adapter2();
    }
}

view_parts(12);
//view_proper();

//z_lifter_arm();
//z_lifter();
//translate([37.5-side/2,-side/2,10]) 
side=31;

// temp, do not use
module qnd_fix() {
    difference() {

        cube([side,side,5]);
        translate([side/2,side/2,0]) rotate([90,0,0]) lifter_threading(extra_slop=0.3);
        translate([5,5,0]) cylinder(d=bolt_hole_dia, h=6);
        translate([5,5,3]) cylinder(d=bolt_head_hole_dia, h=6);

        translate([5,side-5,0]) cylinder(d=bolt_hole_dia, h=6);
        translate([5,side-5,3]) cylinder(d=bolt_head_hole_dia, h=6);

        translate([side-5,5,0]) cylinder(d=bolt_hole_dia, h=6);
        translate([side-5,5,3]) cylinder(d=bolt_head_hole_dia, h=6);

        translate([side-5,side-5,0]) cylinder(d=bolt_hole_dia, h=6);
        translate([side-5,side-5,3]) cylinder(d=bolt_head_hole_dia, h=6);

    }
}

module qnd_fix2() {
    difference() {
        union() {
            rotate([90,0,0]) difference() {
                _rail(17, 20*1.75);
                _rail(18, 20*1.54);
                translate([0,10,0]) _rail(18, 20*1.57);
            }
            slide(10, 3);
        }
        translate([0,19,0]) cube([50,10,50], center=true);
        translate([20,9.40,15]) cube([50,50,10], center=true);
    }
    

    translate([45,0,0]) {
        difference() {
            union() {
                rotate([90,0,0]) difference() {
                    _rail(17, 20*1.75);
                    _rail(18, 20*1.54);
                    translate([0,10,0]) _rail(18, 20*1.57);
                }
                slide(10, 3);
            }
            translate([0,19,0]) cube([50,10,50], center=true);
        }
    }
}

//qnd_fix2();
