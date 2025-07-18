
include <include.scad>;
include <globals.scad>;
use <long_tie.scad>;
use <mockups.scad>;
use <extention.scad>;

use <../../PCParts/common.scad>;


$fn=30;


//debug_adapter_SSR_1048ZD3();

//adapter_mks_sbase_box();
//adapter_titan();
//ramps_mount_adapter();
//adapter_dove_m3_28();
//adapter_dove_m3_15();
//adapter_shy_rockabilly();
//adapter_shy_rockabilly2();
//adapter_shy_rockabilly2_m3();
//adapter_shy_rockabilly3();
//adapter_airtrippers_bowden_extruder();
//adapter_tl_smoother();
//adapter_SSR_1048ZD3();
adapter_SSR_1048ZD3_cover();


module _frame_clip(h=20) {
    intersection() {
        union() {
            difference() {
                translate([0, -11.5, 0])
                cube([35, 23, h], center=true);

                cube([30, 30, 60], center=true);

                translate([0, -15, -30])
                rotate([0, 0, 180])
                male_dovetail();
            }
            translate([15, 0, 0])
            rotate([0, 0, 5])
            cube([4, 5, h], center=true);

            translate([-15, 0, 0])
            rotate([0, 0, -5])
            cube([4, 4.8, h], center=true);
        }
        translate([0, -11.5])
        chamfered_cube(35, 23, 20, 1, center=true);
    }
}

module debug_adapter_SSR_1048ZD3() {
    adapter_SSR_1048ZD3();

    %translate([0, 0, 6 + 46])
    rotate([180, 0, 0])
    adapter_SSR_1048ZD3_cover();
}

module adapter_mks_sbase_box() {

    l = 125;

    difference() {
        translate([0, 0, 6/2])
        union() {
            cube([67, l - 18, 6], center=true);

            translate([-65/2, l/2 - 10, 0])
            cylinder(d=8, h=6, center=true, $fn=40);

            translate([65/2, l/2 - 10, 0])
            cylinder(d=8, h=6, center=true, $fn=40);

            translate([-65/2, -l/2 + 10, 0])
            cylinder(d=8, h=6, center=true, $fn=40);

            translate([65/2, -l/2 + 10, 0])
            cylinder(d=8, h=6, center=true, $fn=40);
        }

        intersection() {
            difference() {
                cube([67 - 7, l - 18 - 7, 20], center=true);

                translate([5.65, 32, 0])
                cylinder(d=14, h=30, center=true, $fn=30);

                translate([-5.65, -26.5, 0])
                cylinder(d=14, h=30, center=true, $fn=30);
            }

            translate([-219.55, -228, 0])
            for(j = [0:39]) {
                translate([0, j*13])
                rotate([0, 0, -60])
                for (i = [0:39]) {
                    translate([0, i*13])
                    cylinder(
                        d=13, h=60,
                        center=true, $fn=6
                    );
                }
            }
        }

        translate([-65/2, l/2 - 10, 0])
        cylinder(d=2.8, h=20, center=true, $fn=40);

        translate([65/2, l/2 - 10, 0])
        cylinder(d=2.8, h=20, center=true, $fn=40);

        translate([-65/2, -l/2 + 10, 0])
        cylinder(d=2.8, h=20, center=true, $fn=40);

        translate([65/2, -l/2 + 10, 0])
        cylinder(d=2.8, h=20, center=true, $fn=40);

        translate([5.65, 32, -1])
        adapter_mount_thread();

        translate([-5.65, -26.5, -1])
        adapter_mount_thread();
    }
}

module adapter_titan() {
    
    module _titan_body() {
        hull() {
            translate([-46.5/2 + 1/2, -4/2, 30/2])
            cube([1.5, 40.5, 30], center=true);

            translate([-46.5/2 + 1/2 + 4, 0, 30/2])
            cube([1.5, 44.5, 30], center=true);

            translate([46.5/2 - 1/2, 10/2, 30/2])
            cube([1.5, 34.5, 30], center=true);

            translate([46.5/2 - 16/2, -44/2 + 16/2, 0])
            cylinder(d=16.5, h=30, $fn=80);
        }
        translate([-46.5/2 + 7 + 27.2/2, 44/2 - 7 - 27.2/2, 0]) {
            for(i = [0:3]) {
                rotate([0, 0, 360/4*i])
                translate([
                    motor_bolt_hole_distance/2,
                    -motor_bolt_hole_distance/2,
                    0
                ])
                cylinder(d=3.8, h=100, center=true, $fn=30);
            }
            cylinder(d=23.5, h=100, center=true, $fn=40);
        }
    }

    module _mount() {
        difference() {
            union() {
                hull() {
                    cube([32, 32, 6]);
                
                    translate([41, 5, 0])
                    rotate([0, 0, 5])
                    cube([50, 48, 6]);
                }
                cube([32, 32, 20]);

                // extra pillar
                hull() {
                    translate([35, 36, 0])
                    cube([6, 10, 1]);

                    translate([32 - 6, 32 - 6, 20 - 1])
                    cube([6, 6, 1]);
                }
            }

            // extension hole
            translate([-1, -1, -1])
            cube([32 - 8 + 1, 32 - 8 + 1, 22]);

            // dovetails
            translate([32 - 8, 32 - 8 - 15, 0])
            rotate([0, 0, -90])
            male_dovetail(height=80);

            translate([32 - 8 - 15, 32 - 8, 0])
            rotate([0, 0, 0])
            male_dovetail(height=80);

            // titan body
            translate([64, 31, 33.8])
            rotate([0, 180, 5])
            _titan_body();

            translate([88, 52, -1])
            rotate([0, 0, 45 + 5])
            cube([10, 10, 10]);
        }
    }

    _mount();

    %translate([64, 31, 33])
    rotate([0, 180, 5])
    mock_titan();
}

module ramps_mount_adapter() {
    module ear() {
        hull() {
            translate([0, 0, 0])
            cube([5, 15, 0.1]);

            translate([20, 7.5, 0])
            cylinder(d=15, h=0.1);

            translate([0, 3.5, 3.9])
            cube([5, 8, 0.1]);

            translate([20, 7.5, 3.9])
            cylinder(d=8, h=0.1);
        }
    }

    module ears() {
        difference() {
            hull() {
                ear();

                mirror([1, 0, 0])
                ear();
            }
            translate([20, 7.5, 0])
            cylinder(d=bolt_hole_dia, h=7);

            translate([20, 7.5, 1.8])
            M3_nut();

            translate([-20, 7.5, 0])
            cylinder(d=bolt_hole_dia, h=7);

            translate([-20, 7.5, 1.8])
            M3_nut();
        }
    }

    // for thing: https://www.thingiverse.com/thing:861360
    // drill holes to the box and use 3mm screws & nuts
    difference() {
        union() {
            translate([0, 3.5, 0])
            cube([20, box_length - 27, 7.5]);

            translate([10, box_length - 20 - 15, 0])
            ears();

            translate([10, 0, 0])
            ears();
        }
        translate([10, 0, 7.5])
        rotate([-90, 0, 0])
        male_dovetail(box_length);
    }
}

module adapter_dove_m3_28() {
    difference() {
        long_tie(34);

        translate([0, 0, 5/2 + 0.6])
        cube([2.5, 35, 5], center=true);

        translate([0, 28/2, 0])
        cylinder(d=2.8, h=5, $fn=20);

        translate([0, -28/2, 0])
        cylinder(d=2.8,h=5,$fn=20);
    }
}

module adapter_dove_m3_15() {
    difference() {
        translate([0, 0, 0])
        long_tie(15);

        translate([0, 0, 5/2 + 0.6])
        cube([2.5, 16, 5], center=true);

        cylinder(d=2.8, h=5, $fn=20);
    }
}

module adapter_shy_rockabilly() {

    // adapter for this extruder: https://www.thingiverse.com/thing:1223730

    module fixing_plate() {
        union () {
            hull() {
                translate([7.9/2, 5, 20/2])
                cube([7.9, 36, 20], center = true);

                translate([-2, 5, 20/2 ])
                cube([1, 20, 10], center=true);
            }

            translate([24/2 + 7.5, 15.1 + 7.9/2, 20/2])
            cube([24, 7.9, 20], center=true);

            translate([10, 45, 0])
            rotate([0, 0, -20])
            difference() {
                hull() {
                    translate([-15/2, 0, 5/2])
                    cube([15, 46, 5], center=true);

                    translate([13, -20, 5/2])
                    rotate([0, 0, 20])
                    cube([25, 1, 5], center=true);
                }
                translate([-10, -15, 0])
                cylinder(d=m4_bolt_hole_dia, h=20);

                translate([-10, 14, 0])
                cylinder(d=m4_bolt_hole_dia, h=20);

                translate([-24, -22, 0])
                rotate([0, 0, 45])
                cube([30, 30, 30]);
            }
        }
    }
    difference() {
        fixing_plate();

        translate([8, 0, 0])
        rotate([0, 0, 90])
        male_dovetail(height=80);

        translate([8 + 15, 15, 0])
        male_dovetail(height=80);
    }
}

module adapter_shy_rockabilly2(m3=false) {

    // adapter for this extruder: https://www.thingiverse.com/thing:1223730
    
    // different angle

    module fixing_plate() {
        union () {
            hull() {
                translate([7.9/2, 5, 20/2])
                cube([7.9, 36, 20], center = true);

                if (!m3) {
                    translate([-2, 5, 20/2 ])
                    cube([1, 20, 10], center=true);
                }
            }

            if (m3) {
                difference() {
                    union() {
                        translate([8 + 15, 15, 0])
                        rotate([0, 0, 180])
                        male_dovetail(height=20);

                        translate([8 + 15, 15, 20/2])
                        cube([5, 0.2, 20], center=true);
                    }

                    hull() {
                        translate([
                            8 + 10, 30/2 - 1/2, 0
                        ])
                        cube([5, 1, 80], center=true);

                        translate([
                            8 + 14, 0, 0
                        ])
                        cube([5, 1, 80], center=true);
                    }
                }
            }

            translate([24/2 + 7.5, 15.1 + 7.9/2, 20/2])
            cube([24, 7.9, 20], center=true);

            translate([10, 27, 0])
            rotate([0, 0, -45])
            difference() {
                hull() {
                    translate([-16/2,0,7/2])
                    cube([16, 44, 7], center=true);

                    translate([8, 1, 7/2])
                    rotate([0, 0, 45])
                    cube([25, 1, 7], center=true);
                }
                translate([-10, -14.5, 0]) {
                    translate([0, 0, 4.2])
                    cylinder(d=m4_bolt_hole_dia, h=20);

                    rotate([0, 0, 360/6/2])
                    M4_nut(4, cone=false);
                }

                translate([-10, 14.5, 0]) {
                    translate([0, 0, 4.2])
                    cylinder(d=m4_bolt_hole_dia, h=20);

                    rotate([0, 0, 360/6/2])
                    M4_nut(4, cone=false);
                }

                translate([-26, -22, -2])
                rotate([0, 0, 45])
                cube([30, 30, 30]);
            }
        }
    }
    difference() {
        fixing_plate();

        if (!m3) {
            translate([8, 0, 0])
            rotate([0, 0, 90])
            male_dovetail(height=80);

            translate([8 + 15, 15, 0])
            male_dovetail(height=80);
        } else {
            translate([0, 0, 20/2])
            rotate([0, 90, 0])
            cylinder(d=3.2, h=20, center=true, $fn=30);

            translate([0, 0, 20/2])
            rotate([0, 90, 0])
            cylinder(
                d1=11.5, d2=6.5, h=6,
                center=true, $fn=30
            );
        }
    }
}

module adapter_shy_rockabilly2_m3() {
    difference() {
        adapter_shy_rockabilly2(m3=true);
    }
}

module adapter_shy_rockabilly3() {

    // adapter for this extruder: https://www.thingiverse.com/thing:1223730
    
    // different angle

    module fixing_plate() {
        union () {
            translate([8/2, 5, 20/2])
            cube([8, 36, 20], center = true);

            translate([23/2 + 8, 15 + 8/2, 20/2])
            cube([23, 8, 20], center=true);

            translate([22, 23, 0])
            rotate([0, 0, -90])
            difference() {
                hull() {
                    translate([-16/2, 0, 7/2])
                    cube([16, 44, 7], center=true);

                    translate([2, -7, 7/2])
                    rotate([0, 0, 90])
                    cube([25, 1, 7], center=true);
                }
                translate([-10, -14.5, 0]) {
                    translate([0, 0, 4.2])
                    cylinder(d=m4_bolt_hole_dia, h=20);

                    rotate([0, 0, 360/6/2])
                    M4_nut(4, cone=false);
                }

                translate([-10, 14.5, 0]) {
                    translate([0, 0, 4.2])
                    cylinder(d=m4_bolt_hole_dia, h=20);

                    rotate([0, 0, 360/6/2])
                    M4_nut(4, cone=false);
                }

                translate([-26,-22,0])
                rotate([0,0,45])
                cube([30,30,30]);
            }
        }
    }
    difference() {
        fixing_plate();
        translate([8,0,0])
        rotate([0,0,90]) male_dovetail(height=80);

        translate([8+15,15,0])
        rotate([0,0,0]) male_dovetail(height=80);
    }
}

module airtrippers_fixing_pin(pin_size=6.4) {
    difference() {
        union() {
            cylinder(3, r=pin_size/2);
            hull() {
                translate([0,0,3]) cylinder(0.5, r=pin_size/2);
                translate([0,0,3.5]) cylinder(1, r=pin_size/2+0.5);
                translate([0,0,4.5]) cylinder(1, r=2);
            }
        }
        cube([8,1,12], center=true);
    }
}

module airtrippers_fixing_plate(pin_distance, pin_size) {
    difference() {
        union () {
            translate([-14.5,0,10]) cube([7,74,20], center = true);
            translate([-14.5,-74/2+20/2,10]) cube([7,20,50], center = true);
        }
		union() {
			// fixing plate cutout
			translate([-16,36,0]) rotate([45,0,0]) cube([16,16,7], center = true);
			translate([-16,-35,-16]) rotate([135,0,0]) cube([16,16,7], center = true);
			translate([-16,36,20]) rotate([135,0,0]) cube([16,16,7], center = true);
			translate([-16,-19,-16]) rotate([45,0,0]) cube([16,16,7], center = true);
            
            translate([-16,-19,36]) rotate([135,0,0]) cube([16,16,7], center = true);
            translate([-16,-35,36]) rotate([45,0,0]) cube([16,16,7], center = true);
		}
	}
	translate([-18,-pin_distance/2,10]) rotate([0,270,0]) airtrippers_fixing_pin(pin_size);
	translate([-18,pin_distance/2,10]) rotate([0,270,0]) airtrippers_fixing_pin(pin_size);

}

module adapter_airtrippers_bowden_extruder(
    pin_distance=61, pin_size=6.4
) {
    difference() {
        translate([0, 0, -11])
        rotate([0, 90, 0])
        airtrippers_fixing_plate(pin_distance, pin_size);

        translate([10, 40, 0])
        rotate([90, 0, 0])
        male_dovetail(height=80);

        translate([40, -27, 0])
        rotate([90, 0, -90])
        male_dovetail(height=80);
    }
}

module adapter_tl_smoother() {
    %translate([0, 0, 7])
    mock_tl_smoother();

    difference() {
        union() {
            rounded_cube_side(
                32, 42, 6, 6, center=true, $fn=40
            );

            translate([22/2, 32/2, 10/2 - 6/2])
            cylinder(d=7, 10, center=true, $fn=30);

            translate([-22/2, 32/2, 10/2 - 6/2])
            cylinder(d=7, 10, center=true, $fn=30);

            translate([22/2, -32/2, 10/2 - 6/2])
            cylinder(d=7, 10, center=true, $fn=30);

            translate([-22/2, -32/2, 10/2 - 6/2])
            cylinder(d=7, 10, center=true, $fn=30);
        }

        difference() {
            rounded_cube_side(
                26, 36, 7, 3, center=true, $fn=40
            );
            cylinder(d=15, h=20, center=true, $fn=40);

            translate([22/2, 32/2, 0])
            cylinder(d=9, 25, center=true, $fn=30);

            translate([-22/2, 32/2, 0])
            cylinder(d=9, 25, center=true, $fn=30);

            translate([22/2, -32/2, 0])
            cylinder(d=9, 25, center=true, $fn=30);

            translate([-22/2, -32/2, 0])
            cylinder(d=9, 25, center=true, $fn=30);

            cube([40, 3, 20], center=true);
            cube([3, 40, 20], center=true);

            hull() {
                translate([22/2, 32/2, 0])
                cylinder(
                    d=2, h=20, center=true, $fn=30
                );

                translate([-22/2, -32/2, 0])
                cylinder(
                    d=2, h=20, center=true, $fn=30
                );
            }

            hull() {
                translate([-22/2, 32/2, 0])
                cylinder(
                    d=2, h=20, center=true, $fn=30
                );

                translate([22/2, -32/2, 0])
                cylinder(
                    d=2, h=20, center=true, $fn=30
                );
            }
        }

        translate([0, 0, -4])
        adapter_mount_thread();

        translate([22/2, 32/2, 0])
        cylinder(d=2.7, 25, center=true, $fn=30);

        translate([-22/2, 32/2, 0])
        cylinder(d=2.7, 25, center=true, $fn=30);

        translate([22/2, -32/2, 0])
        cylinder(d=2.7, 25, center=true, $fn=30);

        translate([-22/2, -32/2, 0])
        cylinder(d=2.7, 25, center=true, $fn=30);
    }
}

module adapter_SSR_1048ZD3() {
    %translate([-23, 0, 17])
    mock_SSR_1048zZD3();

    %translate([24, 0, 6])
    mock_liitinrima_medium(4);

//    %translate([24, -20, 6])
//    mock_liitinrima_big(3);


    w = 100;
    l = 90;
    corner = 12;

    module _main() {
        difference() {
            translate([0, 0, 6/2])
            rounded_cube_side(
                w, l, 6, corner, center=true, $fn=50
            );

            intersection() {
                difference() {
                    rounded_cube_side(
                        w - 6, l - 6, 60, corner - 6, center=true
                    );

                    translate([-22.65, 26, 0])
                    cylinder(d=14, h=30, center=true, $fn=30);

                    translate([-22.65, -26, 0])
                    cylinder(d=14, h=30, center=true, $fn=30);

                    translate([33.3, 19.5, 0])
                    cylinder(d=14, h=30, center=true, $fn=30);

                    translate([-34.3, -19.5, 0])
                    cylinder(d=14, h=30, center=true, $fn=30);
                }

                translate([-214.4, -227.5, 0])
                for(j = [0:39]) {
                    translate([0, j*13])
                    rotate([0, 0, -60])
                    for (i = [0:39]) {
                        translate([0, i*13])
                        cylinder(
                            d=13, h=60,
                            center=true, $fn=6
                        );
                    }
                }
            }
        }
    }

    difference() {
        union() {
            _main();

            // corners
            translate([-w/2 + corner/2, l/2 - corner/2, 0])
            cylinder(d=corner, h=6);

            translate([w/2 - corner/2, l/2 - corner/2, 0])
            cylinder(d=corner, h=6);

            translate([-w/2 + corner/2, -l/2 + corner/2, 0])
            cylinder(d=corner, h=6);

            translate([w/2 - corner/2, -l/2 + corner/2, 0])
            cylinder(d=corner, h=6);

            // SSR mount studs
            hull() {
                translate([-20, 24, 0])
                cylinder(d=10, h=17);

                translate([-26, 24, 0])
                cylinder(d=10, h=17);

                translate([-23, 26, 0])
                cylinder(d=10, h=17);
            }

            hull() {
                translate([-20, -24, 0])
                cylinder(d=10, h=17);

                translate([-26, -24, 0])
                cylinder(d=10, h=17);

                translate([-23, -26, 0])
                cylinder(d=10, h=17);
            }

            // liitinrima mount base
            translate([w/2 - 46/2, 0, 6/2])
            cube([46, 15, 6], center=true);

            // cable mount bases
            translate([23, -l/2 + 15/2, 6/2])
            cube([30, 14.8, 6], center=true);

            translate([23, l/2 - 15/2, 6/2])
            cube([30, 14.8, 6], center=true);

            translate([23, -l/2 + 10/2 + 5, 10/2])
            cube([21, 10, 10], center=true);

            translate([23, l/2 - 10/2 - 5, 10/2])
            cube([21, 10, 10], center=true);
        }
        // corner screw holes
        translate([-w/2 + corner/2, l/2 - corner/2, 0])
        cylinder(d=2.7, h=50, center=true);

        translate([w/2 - corner/2, l/2 - corner/2, 0])
        cylinder(d=2.7, h=50, center=true);

        translate([-w/2 + corner/2, -l/2 + corner/2, 0])
        cylinder(d=2.7, h=50, center=true);

        translate([w/2 - corner/2, -l/2 + corner/2, 0])
        cylinder(d=2.7, h=50, center=true);

        // SSR mount holes
        translate([-23, 24, 0])
        cylinder(d=4.2, h=50, center=true);

        translate([-23, -24, 0])
        cylinder(d=4.2, h=50, center=true);

        translate([-23, 24, -1])
        M4_nut_tapering(h=10, cone=false, bridging=true);

        translate([-23, -24, -1])
        M4_nut_tapering(h=10, cone=false, bridging=true);

        // liitinrima screw holes
        translate([14, 0, 0])
        cylinder(d=2.7, h=60, center=true);

        translate([33.85, 0, 0])
        cylinder(d=2.7, h=60, center=true);

        // cable cuts
        translate([23, 0, 12])
        rotate([90, 0, 0])
        cylinder(d=10, h=l + 10, center=true);

        translate([23, l/2 - 15 + 5, 13/2])
        rotate([90, 0, 0])
        difference() {
            rounded_cube_side(17.5, 12, 3, 8, center=true);
            rounded_cube_side(13.5, 8, 4, 4, center=true);
        }

        translate([23, -l/2 + 15 - 5, 13/2])
        rotate([90, 0, 0])
        difference() {
            rounded_cube_side(17.5, 12, 3, 8, center=true);
            rounded_cube_side(13.5, 8, 4, 4, center=true);
        }

        // threads
        translate([33.3, 19.5, -3.9])
        adapter_mount_thread();

        translate([-34.3, -19.5, -3.9])
        adapter_mount_thread();
    }
}

module adapter_SSR_1048ZD3_cover() {
    w = 100;
    l = 90;
    corner = 12;
    h = 47;

    module _screw_hole() {
        cylinder(d=3.3, h=100, center=true);
        chamfered_cylinder(
            6.8, (h - 40 + 5)*2, 2, center=true, $fn=30
        );
    }

    difference() {
        translate([0, 0, h/2])
        rounded_cube_side(
            w, l, h, corner, center=true, $fn=50
        );

        difference() {
            translate([0, 0, h/2 + 0.8])
            rounded_cube_side(
                w - 4, l - 4, h, corner - 4, center=true, $fn=50
            );

            translate([-w/2 + corner/2, l/2 - corner/2, 0])
            cylinder(d=corner - 1, h=100);

            translate([w/2 - corner/2, l/2 - corner/2, 0])
            cylinder(d=corner - 1, h=100);

            translate([-w/2 + corner/2, -l/2 + corner/2, 0])
            cylinder(d=corner - 1, h=100);

            translate([w/2 - corner/2, -l/2 + corner/2, 0])
            cylinder(d=corner - 1, h=100);

            for(i = [0:10]) {
                translate([-w/2 + i*12, 0, 0])
                rotate([0, 0, 30])
                cube([1.8, 1000, 4], center=true);

                translate([-w/2 + i*12, 0, 0])
                rotate([0, 0, -30])
                cube([1.8, 1000, 4], center=true);
            }
        }

        // screw holes
        translate([-w/2 + corner/2, l/2 - corner/2, 0])
        _screw_hole();

        translate([w/2 - corner/2, l/2 - corner/2, 0])
        _screw_hole();

        translate([-w/2 + corner/2, -l/2 + corner/2, 0])
        _screw_hole();

        translate([w/2 - corner/2, -l/2 + corner/2, 0])
        _screw_hole();

        // cable cuts
        translate([23, 0, h])
        rotate([90, 0, 0])
        hull() {
            cylinder(d=10, h=l + 10, center=true);

            translate([0, -6, 0])
            cylinder(d=10, h=l + 10, center=true);
        }

        // vents
        for(i = [0:3]) {
            translate([-w/2 + 20 + i*10, 0, h/2])
            rotate([90, 19, 0])
            hull() {
                translate([0, h/2 - 7, 0])
                cylinder(d=4, h=l + 10, center=true, $fn=30);

                translate([0, -h/2 + 7, 0])
                cylinder(d=4, h=l + 10, center=true, $fn=30);
            }
        }

        for(i = [0:2]) {
            translate([-w/2 + 60 + i*10, 0, h/2])
            rotate([90, 19, 0])
            hull() {
                translate([0, h/2 - 17, 0])
                cylinder(d=4, h=l + 10, center=true, $fn=30);

                translate([0, -h/2 + 7, 0])
                cylinder(d=4, h=l + 10, center=true, $fn=30);
            }
        }

        for(i = [0:5]) {
            translate([0, -l/2 + 20 + i*10, h/2])
            rotate([90, 19, 90])
            hull() {
                translate([0, h/2 - 7, 0])
                cylinder(d=4, h=w + 10, center=true, $fn=30);

                translate([0, -h/2 + 7, 0])
                cylinder(d=4, h=w + 10, center=true, $fn=30);
            }
        }
    }
}