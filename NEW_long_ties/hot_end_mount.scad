include <globals.scad>;
include <include.scad>;

use <long_tie.scad>;
use <long_bow_tie.scad>;
use <motor_mount_small.scad>;
use <extention.scad>;
use <rack.scad>;
use <cable_clip.scad>;
use <endstop.scad>;
include <mockups.scad>;


////// VARIABLES //////
hotend_depth = 75;
mounting_diamiter = 12 + slop/2;
top_diamiter = 17;
arm_thickness = 5;
long_tie_len = .9*35;
snap_location = 47-6.3+long_tie_len/2;
natch_height = 6;

$fn=60;

////// VIEW //////
//view_proper();
//debug_radial_fan();

//do_mount();
//clamp();

//rotate([0,180,0])
//clamp_shroud_mount();

//rotate([0,-90,0])
//prox_sensor_clamp();

//leveling_switch_clamp();

//fan_duct_axial_e3dv6();
fan_duct_radial_e3dv6();

//fan_duct_axial_e3dvolcano();
//fan_duct_radial_e3dvolcano();
//cable_pcb_mount_clamp();


////// MODULES //////
module motor_mount_tie(height=15){
    translate([-8+slop,0.95,snap_location])
    rotate([-90,0,0])
    scale([.95,1,0.97])
    long_tie(long_tie_len);
}

module y_mount_added(){
    difference() {
        union() {
            motor_mount_tie();
            translate([0,-29.99,69])
            rotate([90,90,0])
            long_tie(11.5);

            translate([1,-4+((10-arm_thickness)/2),hotend_depth/2])
            cube([25,arm_thickness,hotend_depth],
            center=true);

            translate([1,-15,hotend_depth-(natch_height)])
            cube([25,30,natch_height*2],center=true);

            translate([-4,-14.8,hotend_depth-17.75])
            rotate([-45,0,0])
            cube([15,32.0,11],center=true);

            translate([-4,-5,hotend_depth-27])
            cube([15,5,natch_height*2],center=true);

            translate([1,1,0])
            cube([25,8,5],center=true);

            translate([-11.5,1,65])
            cube([26,8,28]);
        }
        translate([-12,9.01,86])
        rotate([90,0,0])
        rotate([0,90,0])
        rotate([0,0,90])
        male_dovetail(15);

        translate([-12,9.01,86])
        rotate([90,0,0])
        rotate([0,90,0])
        rotate([0,0,-90])
        male_dovetail(15);
    }
}

module dove_end() {
    intersection() {
        union() {
            translate([-8+slop,0.95,-2.5])
            male_dovetail(20);

            translate([-8+slop,0.95,-2.5])
            rotate([0,0,180]) male_dovetail(20);

            translate([-11.5,-8,-2.5])
            cube([5,15,20]);
        }
        translate([-11.5,-8,-2.5])
        cube([10,17,20]);
    }
}

module y_mount_taken(){
    translate([0,-13,hotend_depth/2])
    cylinder(h=70, d=mounting_diamiter);

    translate([0,-13,-1])
    cylinder(h=70, d=top_diamiter);

	translate([0,-26,hotend_depth-natch_height])
    rotate([0,-90,0])
    cylinder(h=30, d=bolt_hole_dia, $fn=20);

	translate([0,-2,hotend_depth-natch_height+3])
    rotate([0,-90,0])
    cylinder(h=30, d=bolt_hole_dia, $fn=20);

    dove_end();
}

module mount(){
	difference(){
		rotate([0,-90,0]){
			intersection(){
				translate([-15,-35,0])
                cube([15,100,100]);

				difference(){
                    y_mount_added();
					y_mount_taken();
				}
			}
			translate([-11.5,.7,37.5+(hotend_depth-80)])
            cube([7,.3,42.5]);
		}
		translate([-hotend_depth/2,0,(-hotend_depth/2)-23/2])
        cube([hotend_depth,hotend_depth,hotend_depth], center=true);
	}
}

module _clamp_base(l=15) {
    union(){
        translate([-8,-l/2,slop])
        long_bow_tie_split(l);

        translate([8,-l/2,slop])
        long_bow_tie_split(l);

        translate([-11.75,-l,-3])
        cube([23.5,l,3]);

        translate([-11.75,-l,0])
        cube([7.5,l,0.75]);

        translate([4.25,-l,0])
        cube([7.5,l,0.75]);
    }
}

module _clamp_cable_hole() {
    difference() {
        union() {
            hull() {
                translate([-13.5/2,-12.5/2,0])
                cube([13.5,6,3]);

                translate([0,16,0])
                cylinder(d=13.5, h=3);
            }
        }
        rotate([-45,0,0])
        translate([0,0,-4])
        hull() {
            cylinder(d=7, h=19);

            translate([0,9,0])
            cylinder(d=7, h=29);
        }
        rotate([30,0,0])
        translate([2,2,-5])
        cube([5,4,10]);
    }
}


module clamp() {
    union(){
        translate([0,0,21])
        rotate([90,0,0])
        _clamp_base(l=21);

        translate([0,5,0])
        _clamp_cable_hole();

        translate([-22,0,0])
        rotate([0,0,-90])
        cable_pcb_mount();
    }
}

module clamp_shroud_mount() {
    union() {
        intersection() {
            difference() {
                union(){
                    translate([0,0,21])
                    rotate([90,0,0])
                    _clamp_base(l=21);

                    translate([-18.5/2,0,0])
                    cube([18.5,4,21]);

                    translate([0,13,-1])
                    rotate([5,0,0])
                    _shroud_holder(h=24,d=13.5, edge_h=5);
                }
                translate([0,6,-1])
                rotate([5,0,0])
                hull() {
                    cylinder(d=4.3,h=50,$fn=40);

                    translate([0,4,0])
                    cylinder(d=4.3,h=50,$fn=40);
                }
                translate([0,0,-3/2])
                rotate([5,0,0])
                cube([40,50,3],center=true);
            }
            translate([0,0,21/2])
            cube([30,42,21], center=true);
        }
        translate([22,0,21])
        rotate([0,180,90])
        cable_pcb_mount();
    }
}

module prox_sensor_clamp() {
    height = 25;
    
    module halfround(h=5) {
        hull() {
            cylinder(d=30,h=h);

            translate([-30/2,-30/2,0])
            cube([1,30,h]);
        }
    }

    module main() {
        halfround();
        translate([-17.5,-30/2,0])
        cube([5,30,25]);

        translate([-2.5,0,24])
        halfround(3);
    }

    difference() {
        main();
        cylinder(d=prox_sensor_dia, h=36);

        translate([0,0,5])
        cylinder(d=prox_sensor_washer_dia+3, h=10);

        translate([-31,0,-5])
        cylinder(d=prox_sensor_washer_dia+1, h=20);

        translate([-20,0,5+10/2])
        cube([15,16,10], center=true);

        translate([-12,-12.5,21])
        rotate([0,-90,0])
        cylinder(d=bolt_hole_dia, h=10, $fn=20);

        translate([-12,11.5,18])
        rotate([0,-90,0])
        cylinder(d=bolt_hole_dia, h=10, $fn=20);
    }
        
}

module leveling_switch_clamp() {
    length = 60;
    
    difference() {
        union() {
            cube([20,14,10]);
            cube([20,length,3]);

            translate([20/2-3/2,11,0])
            hull() {
                cube([3,1,10]);

                translate([0,length-15])
                cube([3,1,1]);
            }
            translate([22.5,length+5,0])
            rotate([0,0,180])
            _endstop_body(25, 11, 10, holes=true);
        }
        translate([-1,14/2,10.01])
        rotate([-90,0,-90])
        male_dovetail(30);
    }
    %translate([-0.2,length-5.5,2.2])
    mechanical_endstop();
}

module _fan_duct_nozzle(nozzle_offset, nozzle_width) {
    module tube(d=8, h=20) {
        rotate([-90,0,0]) {

            hull() {
                translate([0.5/2,0,0])
                cylinder(d=d+2.5, h=0.1);

                difference() {
                    hull() {
                        translate([-1,1,4])
                        cylinder(d=d);

                        translate([-1,d/2-2+1,0])
                        cube([d/2, 2, 4]);
                    }
                    translate([d-3,-d-1.5,4])
                    rotate([0,0,55])
                    cube([d,d,10]);
                }
            }
            difference() {
                hull() {
                    hull() {
                        translate([-1,1,4])
                        cylinder(d=d);

                        translate([-1,1,h])
                        sphere(d=d);
                    }
                    translate([-1,d/2-2+1,4])
                    cube([d/2, 2, h-4]);
                }
                translate([d-3,-d-1.5,0])
                rotate([0,0,55])
                cube([d,d,h+20]);
           }
        }
    }

    module hollow_tube() {
        difference() {
            tube(d=11, h=20);

            translate([0,-0.1,0])
            tube(d=9, h=20.1);
        }
    }

    module nozzle_main() {
        translate([-nozzle_width/2+1+nozzle_offset,0,0])
        hollow_tube();

        translate([nozzle_width/2-1+nozzle_offset,0,0])
        mirror([1,0,0])
        hollow_tube();
        
        rotate([-90,0,0])
        difference() {
            translate([nozzle_offset,0,1/2])
            cube([nozzle_width-1,13,1], center=true);

            translate([-nozzle_width/2+nozzle_offset+1,0,-1])
            cylinder(d=12,h=2.1);

            translate([nozzle_width/2+nozzle_offset-1,0,-1])
            cylinder(d=12,h=2.1);
        }
    }

    difference() {
        nozzle_main();

        // air cutouts
        translate([nozzle_width/2+nozzle_offset-4,20/2+1,-4])
        rotate([0,60,0])
        cube([4, 20, 6], center=true);

        translate([-nozzle_width/2+nozzle_offset+4,20/2+1,-4])
        rotate([0,-60,0])
        cube([4, 20, 6], center=true);
        
        translate([nozzle_offset,1,-4.35])
        rotate([60,0,0])
        cube([15,3,6], center=true);
    }
}

module _fan_duct_radial(nozzle_offset, nozzle_width, hot_end, supports=false) {
    
    module fan_base() {
        difference() {
            union() {
                hull() {
                    // duct body
                    translate([7.4,-3,17/2-1])
                    rotate([0,0,20])
                    cube([22.5,4,19],center=true);

                    translate([nozzle_offset,7,13/2+1])
                    rotate([90+25,0,0])
                    hull() {
                        translate([-nozzle_width/2+1,0,0])
                        cylinder(d=13,h=1);

                        translate([nozzle_width/2-1,0,0])
                        cylinder(d=13,h=1);
                    }
                }

                // mount body
                if (hot_end == "E3D_v6") {
                    rotate([25,0,0])
                    translate([0,-4.1,15/2+29])
                    cube([27.5,10,15],center=true);

                    hull() {
                        rotate([25,0,0])
                        translate([0,-4.1,29])
                        cube([27.5,10,0.1],center=true);

                        translate([0,0,10])
                        cube([27.5,10,1],center=true);

                        translate([0,-5,-1.5])
                        cube([27.5,12,1],center=true);

                    }
                } else {
                    rotate([25,0,0])
                    translate([0,-4.1,15/2+38.5])
                    cube([27.5,10,15],center=true);

                    hull() {
                        rotate([25,0,0])
                        translate([0,-4.1,38.5])
                        cube([27.5,10,0.1],center=true);

                        translate([0,0,10])
                        cube([27.5,10,1],center=true);

                        translate([0,-5,-1.5])
                        cube([27.5,12,1],center=true);
                    }
                }

                // fan hole body
                hull() {
                    translate([1.4,-34,-2])
                    cylinder(d=55,h=19,$fn=40);

                    translate([7.4,-3,17/2-1])
                    rotate([0,0,20])
                    cube([22.5,4,19],center=true);
                }

                // fan screw hole body
                hull() {
                    translate([-25.2,-22.7,-2])
                    cylinder(d=8.5,h=19,$fn=30);

                    translate([1.2,-34,-2])
                    cylinder(d=30,h=19,$fn=40);

                    translate([27.6,-43.8,-2])
                    cylinder(d=8.5,h=19,$fn=30);
                }
            }

            // fan input
            translate([7.4,-3,15.2/2])
            rotate([0,0,20])
            translate([0,-2,0])
            cube([19.4,4,15.2],center=true);

            translate([7.4+19.4/2,-3,15.2/2-0.2])
            rotate([0,0,20])
            translate([0,-5,0])
            cube([5,14,3],center=true);

            translate([-1-19.4/2,-3,15.2/2-0.2])
            rotate([0,0,20])
            translate([0,-8,0])
            cube([12,4,3],center=true);

            // duct
            difference() {
                hull() {
                    translate([7.4,-3,17/2-1])
                    rotate([0,0,20])
                    cube([19.4,0.1,15.2],center=true);

                    translate([nozzle_offset,7.01,13/2+1])
                    rotate([90+25,0,0])
                    hull() {
                        translate([-nozzle_width/2+1,0,0])
                        cylinder(d=11,h=0.2);

                        translate([nozzle_width/2-1,0,0])
                        cylinder(d=11,h=0.2);

                    }
                }
                translate([-9,20/2,20/2])
                rotate([0,0,45])
                cube([0.8,20,20],center=true);

                if (hot_end == "E3D_v6") {
                    translate([14.5,20/2,20/2])
                    rotate([0,0,-44])
                    cube([0.8,20,20],center=true);
                } else {
                    translate([11.3,20/2,20/2])
                    rotate([0,0,-36])
                    cube([0.8,20,20],center=true);
                }
                    
            }

            // mount dove
            if (hot_end == "E3D_v6") {
                rotate([25,0,0])
                translate([0,-0.1,15/2+29.7-0.25])
                rotate([180,90,0])
                male_dovetail(34,center=true);

                rotate([25,0,0])
                translate([0,-0.1,15/2+29.7-0.25])
                rotate([0,90,0])
                male_dovetail(34,center=true);

                rotate([25,0,0])
                translate([0,-0.1+1,20/2+29.7-0.25])
                cube([24,2,20],center=true);
            } else {
                rotate([25,0,0])
                translate([0,-0.1,15/2+38.5-0.25])
                rotate([180,90,0])
                male_dovetail(34,center=true);

                rotate([25,0,0])
                translate([0,-0.1,15/2+38.5-0.25])
                rotate([0,90,0])
                male_dovetail(34,center=true);

                rotate([25,0,0])
                translate([0,-0.1+1,20/2++38.5-0.25])
                cube([24,2,20],center=true);
            }

            // fan hole
            translate([0,-64])
            rotate([0,0,-21.4])
            cube([100,50,60],center=true);

            hull() {
                translate([7.4,-3,15.4/2])
                rotate([0,0,20])
                translate([0,-5,0])
                cube([19.4,8,15.4],center=true);

                translate([7.2,-32.5,0])
                cylinder(d=40,h=15.4);
            }
            translate([1.25,-34,15.2/2])
            cylinder(d=51.5,h=15.2,center=true,$fn=40);

            translate([1.2,-34,20/2])
            cylinder(d=40,h=20,center=true,$fn=40);

            translate([1.2,-34,19.99])
            cylinder(d1=40,d2=20,h=10,$fn=40);


            hull() {
                translate([-25.2,-22.7,0])
                cylinder(d=6.8,h=15.2,$fn=30);

                translate([-8.2,-60,0])
                cylinder(d=61,h=15.2,$fn=40);

                translate([27.6,-43.8,0])
                cylinder(d=6.8,h=15.2,$fn=30);
            }

            // fan screw holes
            translate([-25.2,-22.7,-3])
            cylinder(d=4.2,h=22,$fn=30);

            translate([27.6,-43.8,-3])
            cylinder(d=4.2,h=22,$fn=30);

        }
    }

    fan_base();

    translate([0,7,13/2+1])
    rotate([25,0,0])
    _fan_duct_nozzle(nozzle_offset, nozzle_width);

    %translate([16.5,0,0])
    rotate([0,0,200])
    mock_5015_fan();
}

module _fan_duct_axial(nozzle_offset, nozzle_width, hot_end) {

    module fan_base() {
        difference() {
            translate([0,0,-2])
            union() {
                translate([0,0,1])
                rounded_cube_side(42,42,2,8,center=true);

                translate([-32.5/2,-32.5/2,0])
                cylinder(d=6, h=6);

                translate([32.5/2,-32.5/2,0])
                cylinder(d=6, h=6);

                translate([32.5/2,32.5/2,0])
                cylinder(d=6, h=9);

                translate([-32.5/2,32.5/2,0])
                cylinder(d=6, h=9);
                
                cylinder(d=43,h=2,$fn=60);
                translate([0,0,1])
                duct(d2=13, x=nozzle_width-2);

                if (hot_end == "E3D_v6") {
                    rotate([11,0,0])
                    translate([nozzle_offset,-12.25,18.5/2+4.3])
                    cube([27.5,15,18.5], center=true);
                } else if (hot_end == "E3D_Volcano") {
                    intersection() {
                        rotate([11,0,0])
                        translate([nozzle_offset,-16.5,18.5/2+4.3])
                        cube([27.5,25,18.5], center=true);

                        translate([0,-20,18/2])
                        cube([27.5,30,18],center=true);
                    }
                }
            }
            translate([0,0,-4])
            cylinder(d=40,h=4,$fn=60);

            translate([-32.5/2,-32.5/2,-2.1])
            cylinder(d=bolt_hole_dia-0.5, h=8.1);

            translate([32.5/2,-32.5/2,-2.1])
            cylinder(d=bolt_hole_dia-0.5, h=8.1);

            translate([32.5/2,32.5/2,-2.1])
            cylinder(d=bolt_hole_dia-0.5, h=8.1);

            translate([-32.5/2,32.5/2,-2.1])
            cylinder(d=bolt_hole_dia-0.5, h=8.1);

            translate([0,0,-1])
            duct(d=41, d2=11, x=nozzle_width-2, h=31.31);

            if (hot_end == "E3D_v6") {
                rotate([11,0,0])
                translate([0,-13.65,18.9])
                rotate([-90,0,90])
                male_dovetail(36, center=true);

                rotate([11,0,0])
                translate([0,-13.65,18.9])
                rotate([90,0,90])
                male_dovetail(36, center=true);
            } else if (hot_end == "E3D_Volcano") {
                rotate([11,0,0])
                translate([0,-22.10,18.9])
                rotate([-90,0,90])
                male_dovetail(33,center=true);

                rotate([11,0,0])
                translate([0,-22.10,18.9])
                rotate([90,0,90])
                male_dovetail(33,center=true);

                translate([0,-35,-3])
                rotate([45,0,0])
                cube([33,15,15],center=true);
            }
            rotate([11,0,0])
            translate([nozzle_offset,-18,18.9+2/2])
            cube([24,28,2],center=true);
        }
    }

    module capsule_3d(d=12, x=20, h=1) {
        hull() {
            translate([0,x/2,0])
            cylinder(d=d, h=h, $fn=30);

            translate([0,-x/2,0])
            cylinder(d=d, h=h, $fn=30);
        }
    }

    module duct(d=43, d2=11, x=nozzle_width, h=31.3) {
        hull() {
            cylinder(d=d,h=1);

            translate([nozzle_offset,14.2,h])
            rotate([0,-11,90])
            capsule_3d(d=d2, x=x);
        }
    }

    fan_base();

    translate([0,14,31.2])
    rotate([101,0,0])
    _fan_duct_nozzle(nozzle_offset, nozzle_width);
}

module fan_duct_radial_supports() {
    // brim
    translate([-11,-7.5,0.2/2])
    cube([10,19,0.2],center=true);

    translate([38,-7.5,0.2/2])
    cube([10,19,0.2],center=true);

    translate([10,-38,0.2/2])
    cube([30,15,0.2],center=true);

    // supports
    translate([-0.2,-43.5])
    cylinder(d=5,h=2);

    hull() {
        translate([-1.8,-40,7/2])
        cube([1,0.5,7],center=true);

        translate([22.7,-40,13/2])
        cube([1,0.5,13],center=true);
    }

    hull() {
        translate([-3.30,-32,12/2])
        cube([1,0.5,12],center=true);

        translate([21.4,-32,16.5/2])
        cube([1,0.5,16.5],center=true);
    }

    hull() {
        translate([5,-44.2,6/2])
        cube([0.5,1,6],center=true);

        translate([5,-32.5,10/2])
        cube([0.5,1,10],center=true);
    }

    hull() {
        translate([15,-44.2,8/2])
        cube([0.5,1,8],center=true);

        translate([15,-32.5,16/2])
        cube([0.5,1,16],center=true);
    }
}

module fan_duct_axial_e3dv6() {
    _fan_duct_axial(1.5, 38, "E3D_v6");
}

module fan_duct_radial_e3dv6(print_orientation=true) {
    if (print_orientation) {
        translate([0,0,34.6])
        rotate([90,-21.4,0])
        _fan_duct_radial(1.5, 38, "E3D_v6");
    } else {
        _fan_duct_radial(1.5, 38, "E3D_v6");
    }
}

module fan_duct_axial_e3dvolcano() {
    _fan_duct_axial(0, 34, "E3D_Volcano");
}

module fan_duct_radial_e3dvolcano(print_orientation=true) {
    if (print_orientation) {
        translate([0,0,34.6])
        rotate([90,-21.4,0])
        _fan_duct_radial(0, 34, "E3D_Volcano");
    } else {
        _fan_duct_radial(0, 34, "E3D_Volcano");
    }
    fan_duct_radial_supports();
}

module do_mount() {
    translate([0,10,25/2-1])
    mount();

    translate([0,-65,25/2-1])
    mirror([0,1,0])
    mount();
}

module cable_pcb_mount() {
    w = 40;
    l = 44;

    difference() {
        union() {
            cube([w,l,3]);

            translate([w-15,-9.99,0])
            cube([15,10,3]);
        }
        translate([9,0,3])
        rotate([0,-15,0])
        cube([12,24,25]);

        translate([-0.1,2,5.2])
        cube([2.1,18.1,22]);
        
        translate([0,2+5,5.2+9])
        rotate([0,90,0])
        cylinder(d=3.3,h=5,$fn=20);

        translate([0,2+18-5,5.2+9])
        rotate([0,90,0])
        cylinder(d=3.3,h=5,$fn=20);
        
        translate([13,9,-0.1])
        cube([21,26,4]);

        translate([12,8,1.5])
        cube([23,28,4]);
        
        translate([23.5,4,-0.1])
        cylinder(d=3.3,h=5,$fn=20);

        translate([23.5,l-4,-0.1])
        cylinder(d=3.3,h=5,$fn=20);
        
        translate([w-15/2,-10,10])
        rotate([-90,0,0])
        cylinder(d=15,h=20,$fn=50);
        
        translate([w-17.3,-5,0])
        rotate([0,35,0])
        cylinder(d=4,h=15,$fn=30);

        translate([w+2.3,-5,0])
        rotate([0,-35,0])
        cylinder(d=4,h=15,$fn=30);
    }
}

module cable_pcb_mount_clamp() {
    l = 44;
    translate([42,0,0])
    difference() {
        union() {
            hull() {
                translate([26/2,4,0])
                cylinder(d=7,h=2,$fn=20);

                translate([0,6,0])
                cube([26,l-12,2]);

                translate([26/2,l-4,0])
                cylinder(d=7,h=2,$fn=20);
            }
            translate([26/2,4])
            cylinder(d=8,h=5,$fn=20);

            translate([26/2,l-4])
            cylinder(d=8,h=5,$fn=20);
        }
        translate([3,(l-25)/2,-0.1])
        cube([20,25,14]);

        translate([26/2,4])
        cylinder(d=3.3,h=5,$fn=20);

        translate([26/2,l-4])
        cylinder(d=3.3,h=5,$fn=20);

        translate([26/2,4,3])
        M3_nut();

        translate([26/2,l-4,3])
        M3_nut();
    }
}

module view_proper() {

    x_pos = -110;
    translate([0,-x_pos+10.1,-449.7])
    frame_mockup(bed_angle=45, units_x=2, units_y=2, units_z=2, x_pos=x_pos);
    
    //hot_end = "E3D_v6";
    hot_end = "E3D_Volcano";
    
    //fan_duct = "axial";
    fan_duct = "radial";

    rotate([0,-90,0])
    render()
    mount();

    rotate([0,-90,0])
    mirror([0,0,1])
    render()
    mount();

    %translate([0,1,-28.7])
    rotate([-90,0,0])
    render()
    do_motor_mount();

    %translate([0,49.2,-28.7])
    rotate([-90,0,180])
    render()
    do_motor_mount();

    %translate([0,25.1,-42.2])
    render()
    do_rack(fast_render=true);

    //%translate([29,-13.5,-120])
    //proximity_sensor(25.5,5);

    //translate([29,-13.5,-90])
    //prox_sensor_clamp();
    
//    %translate([50,40.1,-76.2])
//    rotate([0,-90,0])
//    extention(support=false);
//
//    %translate([-60,-25,-76.2-43.5])
//    rotate([-90,0,0])
//    extention(support=false);

    translate([0,-4,3.3])
    rotate([180,0,0])
    clamp();
    
//    translate([-10,-40,-62])
//    rotate([-90,0,0])
//    leveling_switch_clamp();

    if (hot_end == "E3D_v6") {
        %translate([0,-13,-127.6])
        rotate([0,0,180])
        e3dv6();

        if (fan_duct == "axial") {
            translate([0,27.9,-99.65])
            rotate([-101,0,180])
            fan_duct_axial_e3dv6();
        } else {
            translate([0,8.9,-123])
            rotate([-25,0,180])
            fan_duct_radial_e3dv6(print_orientation=false);
        }
    } else {
        %translate([0,-13,-136.1])
        rotate([0,0,180])
        e3d_Volcano();

        if (fan_duct == "axial") {
            translate([0,27.9,-108.1])
            rotate([-101,0,180])
            fan_duct_axial_e3dvolcano();
        } else {
            translate([0,8.9,-131.5])
            rotate([-25,0,180])
            fan_duct_radial_e3dvolcano(print_orientation=false);
        }
    }
}

module debug_radial_fan() {
    intersection() {
        fan_duct_radial_e3dv6(print_orientation=false);

        translate([0,0,20/2-10])
        cube([200,200,20],center=true);
    }
}
