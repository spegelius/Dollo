// using code from Snappy reprap
use <../snappy-reprap/cable_chain.scad>;

include <globals.scad>;
use <include.scad>;
use <motor_mount_small.scad>;
use <long_tie.scad>;
use <mockups.scad>;
use <cable_clip.scad>;


//debug();
//debug_x();
//debug_chain_link_mount_4();
//debug_chain_link_2_clip();

//cable_chain_link_2();
cable_chain_link_2(holes=true);
//cable_chain_link_2(holes=true, studs=true);
//chain_link_2_clip();

//chain_link_plate(x=6, y=6);
//chain_link_plate(x=2, y=2);
//chain_motor_mount_y_right();
//chain_motor_mount_y_left();
//chain_motor_mount_x();
//chain_frame_mount_right();
//chain_frame_mount_left();
//chain_link_mount_1();
//chain_link_mount_2();
//chain_link_mount_4();


module _chain_barrel(infill=true) {
    difference() {
        union() {
            translate([0, 1, 12.5])
            hull() {
                cube([25, 6, 1], center=true);

                translate([0, 0, 1])
                cube([25, 8, 1], center=true);

                translate([0, 0, 2])
                cube([25, 6, 2], center=true);
            }
            
            cable_chain_barrel();
        }
        if (infill) {
            // infill
            translate([0, 3, 13.5])
            cube([30, 0.1, 2], center=true);

            translate([0, 1, 13.5])
            cube([30, 0.1, 2], center=true);

            translate([0, -1, 13.5])
            cube([30, 0.1, 2], center=true);
        }

        // rounding
        translate([1.3, -3, 1])
        cube([2, 3, 3], center=true);

        translate([-1.3, 3, 1])
        cube([2, 3, 3], center=true);

    }
}

module cable_chain_link(
    brim=true, infill=true, holes=false, studs=false) {
    difference() {
        union () {
        
            cable_chain_mount1();
            _chain_barrel(infill=infill);
            cable_chain_mount2();

            if (studs) {
                translate([25/2 - 4.5, 8.65, 6.5])
                rotate([0, 90, 0])
                cylinder(d=4, h=2, center=true, $fn=50);

                translate([-25/2 + 4.5, 8.65, 6.5])
                rotate([0, 90, 0])
                cylinder(d=4, h=2, center=true, $fn=50);    
            }

            if (brim) {
                translate(
                    [25/2 - 6/2 + 1, 25/2 + 2,
                     0.2/2])
                cube([6, 6, 0.2], center=true);

                translate(
                    [-25/2 + 6/2 - 1, 25/2 + 2,
                     0.2/2])
                cube([6, 6, 0.2], center=true);

                translate(
                    [25/2 - 6/2 + 1, -25/2 + 2,
                     0.2/2])
                cube([6, 6, 0.2], center=true);

                translate(
                    [-25/2 + 6/2 - 1, -25/2 + 2,
                     0.2/2])
                cube([6, 6, 0.2],center=true);
            }
        }
        if (holes) {
            translate([0, -7.9, 6.5])
            rotate([0, 90, 0])
            cylinder(d=4.1, h=25, center=true, $fn=40);
        }
	}
}

module cable_chain_link_2(brim=true, holes=false, studs=false) {

    difference() {
        cable_chain_link(
            brim=brim, infill=false, holes=holes, studs=studs);

        cube([13, 30, 10], center=true);

        cube([15, 3, 6], center=true);

        translate([25/2, 0, 15])
        rotate([0, -10, 0])
        cube([5, 11, 4.2], center=true);

        translate([-25/2, 0, 15])
        rotate([0, 10, 0])
        cube([5, 11, 4.2], center=true);

    }
}

module chain_link_2_clip() {
    union() {
        difference() {
            translate([0, 1, 0])
            cube([29.2, 19, 6], center=true);

            difference() {
                translate([0, 0.3/2, 0])
                cube([25.2, 13.3, 7], center=true);

                hull() {
                    translate([0, 13/2 + 1/2 + 0.2, 0])
                    cube([25.2, 1.1, 8], center=true);

                    translate([0, 13/2 + 1/2 - 1.9, 0])
                    cube([10, 1, 8], center=true);
                }
            }

            hull() {
                translate([0, 14, 0])
                cube([29, 1, 7], center=true);

                translate([0, 5, 0])
                cube([17, 1, 7], center=true);
            }

            translate([0, 13/2, 0])
            cube([21, 20, 7], center=true);
        }

        difference() {
            hull() {
                translate([0, -17/2 + 3/2, 0])
                cube([14.8, 3, 1], center=true);

                translate([0, -17/2 + 2/2, 0])
                cube([14.8, 2, 2.8], center=true);
            }
            translate([0, 6, 0])
            cylinder(d=25, h=10, center=true, $fn=80);
        }
    }
}

module chain_link_plate(x=6, y=6) {
    for(i=[0:x-1]) {
        for(j=[0:y-1]) {
            translate([i*27, j*26.5,0])
            cable_chain_link();
        }
    }
}

module chain_motor_mount_y_right() {
    module tie_mount() {
        union() {
            translate([0, (motor_side_length + 8)/2 - 0.01])
            intersection() {
                rotate([0, 0, 45])
                cube([13, 13, h], center=true);

                translate([0, 20/2, 0])
                cube([20, 20, h], center=true);
            }

            translate([0, (motor_side_length + 8)/2 - 0.01, 0])
            rotate([0, 0, -45])
            translate([0, 13/2 -0.01, 0])
            rotate([-90, 0, 0])
            long_tie(h);
        }
    }
    
    h = 17.5;
    union() {
        _cable_shroud_motor_clip_body(h=h);
        tie_mount();

        rotate([0, 0, -90])
        mirror([1, 0, 0])
        tie_mount();
    }
}

module chain_motor_mount_y_left() {


    module _y_to_x_arm() {
        // y to x axis
        difference() {
            union() {
                translate([0, 13 - 3, 3])
                rotate([90, 0, 0]) {
                    _chain_barrel();
                    cable_chain_mount2();
                }
                
                translate([25/2 - 4.5, 3.5, 11.65])
                rotate([0, 90, 0])
                cylinder(d=4, h=2, center=true, $fn=50);

                translate([-25/2 + 4.5, 3.5, 11.65])
                rotate([0, 90, 0])
                cylinder(d=4, h=2, center=true, $fn=50);                

                hull() {
                    translate([25/2 - 1/2 + 0.4, 14/2 - 4, 15/2])
                    cube([1, 14, 15], center=true);

                    translate([25/2 + 43.5 + 4 - 1/2, -3 - 40, 15/2])
                    cube([1, 13, 15],center=true);
                }

                translate([25/2 + 43.5 + 4 - 10/2, -3 -40, h/2])
                hull() {
                    translate([5.5, -8, 0])
                    rotate([0, 0, -45])
                    cube([1, 20, h], center=true);

                    translate([0, 4.4, 0])
                    rotate([0, 0, -45])
                    cube([1, 10, h], center=true);
                }
            }
            // indents
            translate([33.5, -17.5, 15])
            rotate([0, 0, 46])
            cube([3, 56, 6], center=true);

            translate([33.5, -17.5, 0])
            rotate([0, 0, 46])
            cube([3, 56, 6], center=true);

            // chamfer
            translate([25/2 + 43.5 + 4 - 10/2, -37.5, h])
            rotate([0, 45, -45])
            cube([3.5, 20, 3.5], center=true);
        }
    }

    module tie_mount() {
        union() {
            translate([0, (motor_side_length + 8)/2 - 0.01])
            intersection() {
                rotate([0, 0, 45])
                cube([13, 13, h], center=true);

                translate([0, 20/2, 0])
                cube([20, 20, h], center=true);
            }

            translate(
                [0,
                 (motor_side_length + 8)/2 - 0.01,
                 0])
            rotate([0, 0, -45])
            translate([0, 13/2 -0.01, 0])
            rotate([-90, 0, 0])
            long_tie(h);
        }
    }
    
    h = 17.5;

    rotate([0, 0, 45])
    union() {
        _cable_shroud_motor_clip_body(h=h);
        tie_mount();

        rotate([0, 0, -90])
        mirror([1, 0, 0])
        tie_mount();

        translate([102.5, 16.55, -h/2])
        rotate([0, 0, -135])
        _y_to_x_arm();
    }
}

module chain_motor_mount_x() {
    
    h = 17.5;

    difference() {
        union() {
            rotate([0, 0, 90])
            _cable_shroud_motor_clip_body(h=h);

            union() {
                translate([-43.5, 13.75, -h/2])
                rotate([0, 0, -45]) {
                    _chain_barrel();
                    cable_chain_mount1();
                }

                hull() {
                    translate([-43.5, 13.75, -h/2])
                    rotate([0, 0, -45])
                    translate([25/2 - 6/2, 0, 14/2])
                    cube([6, 6, 14], center=true);

                    translate(
                        [-(motor_side_length + 7)/2 + 1,
                         24/2 - 2, -h/2 + 16/2])
                    cube([1, 24, 16], center=true);
                }
                hull() {
                    translate([-43.5, 13.75, -h/2])
                    rotate([0, 0, -45])
                    translate([0, 0, 13 + 3.5/2])
                    cube([25, 6, 3.5], center=true);

                    translate(
                        [-(motor_side_length + 8)/2 + 1,
                         24/2 - 1.8, -h/2 + 13 + 3.5/2])
                    cube([1, 24, 3.5], center=true);
                }
            }
        }
        // chain link hole
        translate([-43.5, 13.75, 0])
        rotate([0, 0, -45])
        translate([0, -7.9, -2.25])
        rotate([0, 90, 0])
        cylinder(d=4.1, h=40, center=true, $fn=40);

        // chamfer
        translate([-55, 20, 16.5/2])
        rotate([0, 45, -45])
        cube([5, 20, 5], center=true);

        // infill
        translate([-43.5, 12.25, 5.5])
        rotate([0, 0, -45])
        cube([40, 0.1, 2], center=true);

        translate([-43.5, 15, 5.5])
        rotate([0, 0, -45])
        cube([40, 0.1, 2], center=true);
    }
}

module chain_frame_mount_right() {
    union() {
        rotate([90, 0, 0])
        long_tie_half(25);

        hull() {
            translate([2/2 - 0.01, -4/2, 0])
            cube([2, 4, 25], center=true);

            translate([2/2 - 0.01, -15/2, -5/2])
            cube([2, 4, 20], center=true);

            translate(
                [20 + 1/2, -30 + 15/2,
                 -25/2 + 10/2])
            cube([1, 15, 10], center=true);
        }

        translate([20 + 25/2, -30, -25/2 + 6/2])
        rotate([90, 0, 180]) {
            _chain_barrel();
            cable_chain_mount2();
        }

        translate([20 + 25 - 4.5, -30 + 6.5, -0.9])
        rotate([0, 90, 0])
        cylinder(d=4, h=2, center=true, $fn=50);

        translate([20 + 4.5, -30 + 6.5, -0.9])
        rotate([0, 90, 0])
        cylinder(d=4, h=2, center=true, $fn=50);
    }
}

module chain_frame_mount_left() {
    mirror([1,0,0])
    chain_frame_mount_right();
}

module _chain_link_mount() {
    difference() {
        union() {
            children();
            cable_chain_barrel();
            
            hull() {
                translate([0,3.5,12+7/2])
                cube([25,13,7],center=true);
            }
            translate([25/2-6/2,0,0])
            hull() {
                translate([0,0,1/2])
                cube([6,6,1],center=true);

                translate([0,6,12.5])
                cube([6,8,1],center=true);
            }

            translate([-25/2+6/2,0,0])
            hull() {
                translate([0,0,1/2])
                cube([6,6,1],center=true);

                translate([0,6,12.5])
                cube([6,8,1],center=true);
            }
        }
        translate([26/2,3.5,19.01])
        rotate([-90,0,90])
        male_dovetail(26);
    }
}

module chain_link_mount_1() {
    difference() {
        _chain_link_mount()
        cable_chain_mount1();

        translate([0,2,7])
        rotate([0,90,0])
        cylinder(d=3,h=30,center=true,$fn=20);
    }
}

module chain_link_mount_2() {
    difference() {
        _chain_link_mount()
        translate([0,0,13])
        rotate([0,180,180])
        cable_chain_mount2();

        translate([0,2,7])
        rotate([0,90,0])
        cylinder(d=3,h=30,center=true,$fn=20);
    }
}

module chain_link_mount_4() {
    difference() {
        union() {
            translate([0,0,])
            rotate([0,0,0]) {
                _chain_barrel();
                cable_chain_mount1();
            }
            hull() {
                translate([25/2+10/2-6,1/2-3,17/2])
                cube([10,1,17],center=true);

                translate([25/2+8/2-4,13-1/2-3,17/2])
                cube([8,1,17],center=true);
            }
            hull() {
                translate([-25/2+1/2,3/2,13])
                cube([1,3,2],center=true);

                translate([25/2+2,10/2,13])
                cube([1,10,2],center=true);
            }
        }
        translate([25/2+4,3.5,-1])
        rotate([0,0,90])
        male_dovetail(26);
    }
}

module debug() {
    translate([0,-24,0])
    rotate([-90,0,0])
    do_motor_mount(bridges=false);

    translate([0,-40/2-24,-0.5])
    rotate([0,45,0])
    mock_stepper_motor(false, true);

    translate([0, -45, 0])
    rotate([90, -45, 180]) {
        rotate([0, 0, -45])
        chain_motor_mount_y_left();

        %translate([7.5+8,(motor_side_length+7)/2+7.5+13])
        rotate([0,90,225])
        chain_link_mount_1();

        %translate([43,-5,-7])
        rotate([0,0,-45])
        chain_link_mount_3();

        %rotate([0,0,45])
        cube([30,30,30],center=true);
    }
}

module debug_x() {
    translate([0,-24,0])
    rotate([-90,0,0])
    do_motor_mount(bridges=false);

    translate([0,-40/2-24,-0.5])
    rotate([0,-45,0])
    mock_stepper_motor(false, true);

    translate([0, -45, 0])
    rotate([90, 45, 0]) {
        chain_motor_mount_x();
        
    }
}

module debug_chain_link_mount_4() {
    chain_motor_mount();
        
    translate([43.5,13.75,0])
    rotate([0,180,45])
    chain_link_mount_4();
}

module debug_chain_link_2_clip() {
    cable_chain_link_2();

    translate([0, 0, 6.5])
    rotate([90, 0, 0])
    chain_link_2_clip();
}
