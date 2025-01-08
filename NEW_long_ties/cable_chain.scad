// using code from Snappy reprap
use <../snappy-reprap/cable_chain.scad>;

include <globals.scad>;
use <include.scad>;
use <motor_mount_small.scad>;
use <long_tie.scad>;
use <long_bow_tie.scad>;
use <mockups.scad>;
use <cable_clip.scad>;


//assembly_chainlink(10);
//debug();
//debug_link();
//debug_x();
//debug_chain_link_mount_1();
//debug_chain_link_mount_4();
//debug_chain_link_2_clip();

//_cable_chain_mount1();
//_cable_chain_mount2();
//_chain_barrel();

cable_chain_link();
//cable_chain_link_heavy();

//cable_chain_link_cliplock();
//cable_chain_link_cliplock(holes=true);
//cable_chain_link_cliplock(holes=true, studs=true);
//chain_link_cliplock_clip();

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

//cable_chain_support(200, arms=3);
//cable_chain_support(340, arms=3);
//cable_chain_support_arm();


module assembly_chainlink(links) {
    module _link() {
        translate([0, 7.9, 0])
        cable_chain_link(brim=false);
    }

    step = 7.9 + 8.65;
    
    for(i = [0:links - 1]) {
        translate([0, i*step, 0])
        _link();
    }
}

module debug() {
    translate([0, -24, 0])
    rotate([-90, 0, 0])
    do_motor_mount(bridges=false);

    translate([0, -40/2 - 24, -0.5])
    rotate([0, 45, 0])
    mock_stepper_motor(false, true);

    translate([0, -45, 0])
    rotate([90, -45, 180]) {
        rotate([0, 0, -45])
        chain_motor_mount_y_left();

        %translate([
            7.5 + 8,
            (motor_side_length + 7)/2 + 7.5 + 13
        ])
        rotate([0, 90, 225])
        chain_link_mount_1();

        %translate([43, -5, -7])
        rotate([0, 0, -45])
        chain_link_mount_3();

        %rotate([0, 0, 45])
        cube([30, 30, 30], center=true);
    }
}

module debug_link() {
    difference() {
        intersection() {
            union() {
                cable_chain_link(brim=false);

                translate([0, -7.9 - 8.65, 0])
                cable_chain_link(brim=false);
            }

            translate([20/2, 0, 0])
            cube([20, 20, 40], center=true);

//            translate([-20/2, 0, 0])
//            cube([20, 40, 40], center=true);
        }

//        translate([0, 8.65, 6.5])
//        rotate([0, 90, 0])
//        cylinder(d=5, h=30, center=true, $fn=30);
//
//        translate([0, -7.9, 6.5])
//        rotate([0, 90, 0])
//        cylinder(d=5, h=30, center=true, $fn=30);

    }
}

module debug_x() {
    translate([0, -24, 0])
    rotate([-90, 0, 0])
    do_motor_mount(bridges=false);

    translate([0, -40/2 - 24, -0.5])
    rotate([0, -45, 0])
    mock_stepper_motor(false, true);

    translate([0, -45, 0])
    rotate([90, 45, 0]) {
        chain_motor_mount_x();
        
    }
}

module debug_chain_link_mount_1() {
//    chain_motor_mount_y_right();
        
//    translate([43.5, 13.75, 0])
//    rotate([0, 180, 45])
    chain_link_mount_1();

    translate([0, -8.65 - 7.9, 0])
    cable_chain_link();
}

module debug_chain_link_mount_4() {
    chain_motor_mount();
        
    translate([43.5, 13.75, 0])
    rotate([0, 180, 45])
    chain_link_mount_4();
}

module debug_chain_link_2_clip() {
    cable_chain_link_2();

    translate([0, 0, 6.5])
    rotate([90, 0, 0])
    chain_link_2_clip();
}

module _cable_chain_mount1() {
    difference() {
        cable_chain_mount1();

        translate([9.5, -7.9, 6.5])
        rotate([0, -90, 0])
        cylinder(
            d1=7.5, d2=6.5, h=1.6, $fn=40
        );

        translate([-9.5, -7.9, 6.5])
        rotate([0, 90, 0])
        cylinder(
            d1=7.5, d2=6.5, h=1.6, $fn=40
        );

        // chamfers
        translate([10.2, 0, -2])
        rotate([0, 45, 0])
        cube([5, 20, 5], center=true);

        translate([-10.2, 0, -2])
        rotate([0, 45, 0])
        cube([5, 20, 5], center=true);
    }
}

module _cable_chain_mount2() {
    difference() {
        union() {
            cable_chain_mount2();

            translate([9.5, 8.65, 6.5])
            rotate([0, -90, 0])
            cylinder(
                d1=7.4, d2=6.4, h=1.6, $fn=40
            );

            translate([-9.5, 8.65, 6.5])
            rotate([0, 90, 0])
            cylinder(
                d1=7.4, d2=6.4, h=1.6, $fn=40
            );
        }

        translate([0, 8.7, 0])
        cube([16, 8, 30], center=true);

        // chamfers
        translate([13.2, 0, -2])
        rotate([0, 45, 0])
        cube([5, 30, 5], center=true);

        translate([-13.2, 0, -2])
        rotate([0, 45, 0])
        cube([5, 30, 5], center=true);

        translate([13.2, 0, 15])
        rotate([0, 45, 0])
        cube([5, 30, 5], center=true);

        translate([-13.2, 0, 15])
        rotate([0, 45, 0])
        cube([5, 30, 5], center=true);
    }
}

module _chain_barrel(heavy=false, infill=true) {
    difference() {
        union() {
            translate([0, 0, 12])
            hull() {
                cube([25, 6, 1], center=true);

                if (heavy) {
                    translate([0, 1, 1])
                    cube([25, 8, 1], center=true);

                    translate([0, 0.5, 2])
                    cube([25, 7, 2], center=true);
                } else {
                    translate([0, 1, 1 - 0.1/2])
                    cube([25, 8, 0.1], center=true);
                }
            }

            hull() {
                translate([0, 0, 11.5 + 0.1/2])
                cube([18, 6, 0.1], center=true);

                translate([0, -1, 13 - 0.1/2])
                cube([18, 8, 0.1], center=true);

                if (heavy) {
                    translate([0, 0.5, 14])
                    cube([25, 7, 2], center=true);
                }
            }
            cable_chain_barrel();
        }
        if (heavy && infill) {
            // infill
            translate([0, 2.5, 13.5])
            cube([30, 0.1, 2], center=true);

            translate([0, 0.5, 13.5])
            cube([30, 0.1, 2], center=true);

            translate([0, -1.5, 13.5])
            cube([30, 0.1, 2], center=true);
        }

        // rounding
        translate([1.3, -3, 1])
        cube([2, 3, 3], center=true);

        translate([-1.3, 3, 1])
        cube([2, 3, 3], center=true);

        // chamfers
        translate([13.2, 0, -2])
        rotate([0, 45, 0])
        cube([5, 30, 5], center=true);

        translate([-13.2, 0, -2])
        rotate([0, 45, 0])
        cube([5, 30, 5], center=true);

        translate([13.2, 0, 15])
        rotate([0, 45, 0])
        cube([7, 30, 5], center=true);

        translate([-13.2, 0, 15])
        rotate([0, -45, 0])
        cube([7, 30, 5], center=true);

    }
}

module cable_chain_link(
    brim=true, infill=true, heavy=false,
    holes=false, studs=false
) {
    difference() {
        union () {
            _cable_chain_mount1();
            _chain_barrel(
                heavy=heavy, infill=infill
            );
            _cable_chain_mount2();

            if (studs) {
                translate([25/2 - 4.5, 8.65, 6.5])
                rotate([0, 90, 0])
                cylinder(
                    d=4, h=2, center=true, $fn=50
                );

                translate([-25/2 + 4.5, 8.65, 6.5])
                rotate([0, 90, 0])
                cylinder(
                    d=4, h=2, center=true, $fn=50
                );
            }

            if (brim) {
                translate([
                    25/2 - 6/2 + 3, 25/2 + 1, 0.2/2
                ])
                cube([6, 6, 0.2], center=true);

                translate([
                    -25/2 + 6/2 - 3, 25/2 + 1, 0.2/2
                ])
                cube([6, 6, 0.2], center=true);

                translate([
                    25/2 - 6/2, -25/2 + 3, 0.2/2
                ])
                cube([6, 6, 0.2], center=true);

                translate([
                    -25/2 + 6/2, -25/2 + 3, 0.2/2
                ])
                cube([6, 6, 0.2],center=true);
            }
        }
        if (holes) {
            translate([0, -7.9, 6.5])
            rotate([0, 90, 0])
            cylinder(
                d=4.1, h=25, center=true, $fn=40
            );
        }
	}
}

module cable_chain_link_heavy(
    brim=true, infill=true,
    holes=false, studs=false
) {
    cable_chain_link(
        brim=brim, infill=infill, heavy=true,
        holes=holes, studs=holes
    );
}

module cable_chain_link_cliplock(
    brim=true, holes=false, studs=false
) {

    difference() {
        cable_chain_link(
            brim=brim, infill=false,
            holes=holes, studs=studs
        );

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

module chain_link_cliplock_clip() {
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
    for(i = [0:x - 1]) {
        for(j = [0:y - 1]) {
            translate([i*27, j*26.5, 0])
            cable_chain_link();
        }
    }
}

module _tie_mount(h) {
    union() {
        translate([
            0,
            (motor_side_length + 8)/2 - 0.01
        ])
        intersection() {
            rotate([0, 0, 45])
            translate([-2, -1, 0])
            cube([17, 15, h], center=true);

            translate([0, 20/2, 0])
            cube([24, 24, h], center=true);
        }

        translate([
            0, (motor_side_length + 8)/2 - 0.01, 0
        ])
        rotate([0, 0, -45])
        translate([0, 13/2 -0.01, 0])
        rotate([-90, 0, 0])
        long_tie(h);
    }
}

module chain_motor_mount_y_right() {

    h = 20;

    difference() {
        union() {
            _cable_shroud_motor_clip_body(h=h);
            _tie_mount(h);

            rotate([0, 0, -90])
            mirror([1, 0, 0])
            _tie_mount(h);
        }

        translate([0, -30, 10/2 + 3])
        chamfered_cube(
            16.5, 30, 10, 1, center=true
        );
    }
}

module chain_motor_mount_y_left() {
    h = 20;

    module _cable_chain_end2() {
        union() {
            _chain_barrel(heavy=true);
            _cable_chain_mount2();
        }
    }

    module _y_to_x_arm() {
        // y to x axis
        translate([48.8, -2.5, 0])
        difference() {
            union() {
                translate([0, 0, 30])
                rotate([90, 0, 180])
                _cable_chain_end2();

                hull() {
                    translate([0, 13.5, 27])
                    cube(
                        [18.33, 4, 4], center=true
                    );

                    translate([0, 6.5, 27])
                    cube(
                        [25, 11.34, 4], center=true
                    );

                    translate([0, 5.65, 27])
                    cube(
                        [23.33, 11.3, 4], center=true
                    );
                }

                hull() {
                    translate([0, 13.5, 25])
                    cube(
                        [18.33, 4, 0.1], center=true
                    );

                    translate([0, 6.5, 25])
                    cube(
                        [25, 11.34, 0.1], center=true
                    );

                    translate([0, 5.65, 25])
                    cube(
                        [23.33, 11.3, 0.1], center=true
                    );

                    translate([-8, 16.5, -10 + 0.1/2])
                    cube(
                        [18.33, 4, 0.1], center=true
                    );

                    translate([-8, 9.5, -10 + 0.1/2])
                    cube(
                        [25, 11.34, 0.1], center=true
                    );

                    translate([-8, 8.65, -10 + 0.1/2])
                    cube(
                        [23.33, 11.3, 0.1], center=true
                    );
                }

                hull() {
                    translate([-20.5, 7, -10])
                    cylinder(d=1, h=1, $fn=10);

                    translate([-20.8, 8, 9])
                    cylinder(d=1, h=1, $fn=10);

                    translate([-20, 7, -10])
                    cylinder(d=1, h=1, $fn=10);

                    translate([-14, 12, 9])
                    cylinder(d=1, h=1, $fn=10);

                    translate([-20, -1.47, -10])
                    cylinder(d=1, h=1, $fn=10);

                    translate([-15.5, 3.47, -10])
                    cylinder(d=1, h=1, $fn=10);

                    translate([-20.5, -1.4, 9])
                    cylinder(d=1, h=1, $fn=10);

                    translate([-15, 1.84, 9])
                    cylinder(d=1, h=1, $fn=10);

                }
            }

            hull() {
                translate([0, 13.5, 25])
                cube(
                    [16.33, 1, 0.1], center=true
                );

                translate([0, 6.5, 25])
                cube(
                    [22.5, 10.34, 0.1], center=true
                );

                translate([0, 5.65, 25])
                cube(
                    [21.33, 9.3, 0.1], center=true
                );

                translate([-8, 16.5, -10])
                cube(
                    [16.33, 1, 0.1], center=true
                );

                translate([-8, 9.5, -10])
                cube(
                    [22.5, 10.34, 0.1], center=true
                );

                translate([-8, 8.65, -10])
                cube(
                    [21.33, 9.3, 0.1], center=true
                );

                translate([0, 6.5, 29])
                chamfered_cube_side(
                    13, 10, 0.1, 2, center=true
                );
            }

            translate([-2.5, 0, 27.02])
            rotate([0, 40, 0])
            cube([2, 5, 8], center=true);

            translate([-0.75, 0, 21.02])
            cube([2.5, 5, 16], center=true);

            translate([-2.75, 0, 21.02])
            cube([2.5, 5, 11], center=true);

            hull() {
                 translate([-5.34, 0, 20.6])
                 cube([1, 5, 8], center=true);

                 translate([-1, 0, 20.6])
                 cube([1, 5, 8], center=true);

                 translate([5, 0, -11])
                 cube([1, 7, 8], center=true);

                 translate([9, 0, -11])
                 cube([1, 6, 8], center=true);

                 translate([5, 5, -15])
                 cube([1, 16, 1], center=true);
            }

            translate([-20, 22, -10])
            rotate([-70, 0, 38])
            cylinder(d=20, h=27, center=true, $fn=40);
        }
    }

    module _motor_clip() {
        rotate([0, 0, 45])
        union() {
            _cable_shroud_motor_clip_body(h=h);
            _tie_mount(h);
        }
    }



    union() {
        _motor_clip();

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
                    _cable_chain_mount1();
                }

                hull() {
                    translate([-43.5, 13.75, -h/2])
                    rotate([0, 0, -45])
                    translate([25/2 - 6/2, 0, 14/2])
                    cube([6, 6, 14], center=true);

                    translate([
                        -(motor_side_length + 7)/2 + 1,
                         24/2 - 2, -h/2 + 16/2
                    ])
                    cube([1, 24, 16], center=true);
                }
                hull() {
                    translate([-43.5, 13.75, -h/2])
                    rotate([0, 0, -45])
                    translate([0, 0, 13 + 3.5/2])
                    cube([25, 6, 3.5], center=true);

                    translate([
                        -(motor_side_length + 8)/2 + 1,
                         24/2 - 1.8,
                         -h/2 + 13 + 3.5/2
                    ])
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
            _cable_chain_mount2();
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
    mirror([1, 0, 0])
    chain_frame_mount_right();
}

module _chain_link_mount() {
    difference() {
        union() {
            children();
            _chain_barrel();
            
            hull() {
                translate([0, 3.5, 12 + 7/2])
                cube([25, 13, 7], center=true);
            }

            translate([25/2 - 6/2, 0, 0])
            hull() {
                translate([0, 0, 1/2])
                cube([6, 6, 1], center=true);

                translate([0, 6, 12.5])
                cube([6, 8, 1], center=true);
            }

            translate([-25/2 + 6/2, 0, 0])
            hull() {
                translate([0, 0, 1/2])
                cube([6, 6, 1], center=true);

                translate([0, 6, 12.5])
                cube([6, 8, 1],center=true);
            }
        }
        translate([26/2, 3.5, 19.01])
        rotate([-90, 0, 90])
        male_dovetail(26);
    }
}

module chain_link_mount_1() {
    difference() {
        _chain_link_mount()
        _cable_chain_mount1();

        translate([0, 1.5, 5])
        rotate([0, 90, 0])
        cylinder(d=3, h=30, center=true, $fn=20);
    }
}

module chain_link_mount_2() {
    difference() {
        _chain_link_mount()
        translate([0, 0, 13])
        rotate([0, 180, 180])
        _cable_chain_mount2();

        translate([0, 2, 7])
        rotate([0, 90, 0])
        cylinder(d=3, h=30, center=true, $fn=20);
    }
}

module chain_link_mount_4() {
    difference() {
        union() {
            translate([0, 0, 0])
            rotate([0,0,0]) {
                _chain_barrel();
                _cable_chain_mount1();
            }
            hull() {
                translate([
                    25/2 + 10/2 - 6, 1/2 - 3, 17/2
                ])
                cube([10, 1, 17], center=true);

                translate([
                    25/2 + 8/2 - 4,
                    13 - 1/2 - 3, 17/2
                ])
                cube([8, 1, 17], center=true);
            }
            hull() {
                translate([-25/2 + 1/2, 3/2, 13])
                cube([1, 3, 2], center=true);

                translate([25/2 + 2, 10/2, 13])
                cube([1, 10, 2], center=true);
            }
        }
        translate([25/2 + 4, 3.5, -1])
        rotate([0, 0, 90])
        male_dovetail(26);
    }
}

module cable_chain_support(length, arms=2) {
    d = 28;

    arm_spacing = length/(arms);
    echo(arm_spacing);

    rotate([-25, 0, 0])
    difference() {
        union() {
            translate([0, 2/2, d/2])
            cube([length, 2, d], center=true);

            rotate([25, 0, 0])
            translate([0, -9/2 + 2, 0])
            cube([length, 9, 2], center=true);

            translate([0, 0, d])
            rotate([-25, 0, 0])
            translate([0, -9/2 + 2, 0])
            cube([length, 9, 2], center=true);

            // mount bodies
            translate([-arm_spacing/2, 0, 0])
            for(i = [0:arms - 1]) {
                translate([
                    length/2 - i*arm_spacing,
                    8/2, d/2
                ])
                chamfered_cube_side(
                    10, 8, d,
                    1.8, center=true
                );
            }
        }
        // mount holes
        translate([-arm_spacing/2, 0, 0])
        for(i = [0:arms - 1]) {
            translate([
                length/2 - i*arm_spacing,
                8/2, d/2 + 2
            ])
            chamfered_cube_side(
                7.2, 5.2, d, 1, center=true
            );
        }

        // chamfers
        translate([0, 0, d + 5])
        rotate([-25, 0, 0])
        cube([480, 25, 7.1], center=true);

        translate([0, 0, -5])
        rotate([25, 0, 0])
        cube([480, 25, 7.1], center=true);
    }
}

module cable_chain_support_arm() {
    difference() {
        union() {
            translate([0, 18.1, 15/2])
            rotate([90, 0, 0])
            long_bow_tie_half(15);

            translate([45/2, 0, 7/2])
            chamfered_cube(45, 5, 7, 1, center=true);

            hull() {
                translate([5/2, 18.1 - 4/2, 15/2])
                chamfered_cube(
                    5, 4, 15, 0.8, center=true
                );

                translate([13/2, 0, 7/2])
                chamfered_cube(
                    13, 5, 7, 1, center=true
                );
            }

            // stopper
            translate([19.5, 0, 7/2])
            rotate([0, 0, 25])
            cube([2, 6, 7], center=true);
        }


    }
}