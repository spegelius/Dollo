include <globals.scad>;
include <include.scad>;

use <long_tie.scad>;
use <long_bow_tie.scad>;
use <motor_mount_small.scad>;
use <extention.scad>;
use <rack.scad>;
include <mockups.scad>;

hotend_depth = 75;
mounting_diamiter = 12 + slop/2;
top_diamiter = 17;
arm_thickness = 5;
snap_location = 47;
natch_height = 6;

$fn=60;

module motor_mount_small(height=15){
    translate([-8+slop,0.95,snap_location-6.2]) rotate([-90,0,0]) scale([.95,1,0.97]) long_tie(.9*35);
}

module y_mount_added(){
    difference() {
        union() {
            motor_mount_small();
            translate([1,-4+((10-arm_thickness)/2),hotend_depth/2]) cube([25,arm_thickness,hotend_depth], center=true);
            translate([1,-15,hotend_depth-(natch_height)]) cube([25,30,natch_height*2],center=true);
            translate([-4,-15,hotend_depth-17]) rotate([-45,0,0]) cube([15,33.2,natch_height*2],center=true);
            translate([-4,-5,hotend_depth-27]) cube([15,5,natch_height*2],center=true);
            translate([1,1,0]) cube([25,8,5],center=true);
            translate([-11.5,1,65]) cube([26,8,28]);
        }
        translate([-12,9.01,86]) rotate([90,0,0]) rotate([0,90,0]) rotate([0,0,90]) male_dovetail(15);
    }
}

module dove_end() {
    intersection() {
        union() {
            translate([-8+slop,0.95,-2.5]) male_dovetail(20);
            translate([-8+slop,0.95,-2.5]) rotate([0,0,180]) male_dovetail(20);
            translate([-11.5,-8,-2.5]) cube([5,15,20]);
        }
        translate([-11.5,-8,-2.5]) cube([10,17,20]);
    }
}

module y_mount_taken(){
        translate([0,-13,hotend_depth/2]) cylinder(h=70, d=mounting_diamiter);
	    translate([0,-13,-0.5]) cylinder(h=70, d=top_diamiter);
		translate([0,-26,hotend_depth-natch_height]) rotate([0,-90,0]) cylinder(h=30, d=bolt_hole_dia, $fn=20);
		translate([0,-2,hotend_depth-natch_height+3]) rotate([0,-90,0]) cylinder(h=30, d=bolt_hole_dia, $fn=20);
        dove_end();
}
module mount(){
	difference(){
		rotate([0,-90,0]){
			intersection(){
				translate([-15,-30,0]) cube([15,100,100]);
				difference(){
						y_mount_added();
						y_mount_taken();
				}
			}
			translate([-11.5,.7,37.5+(hotend_depth-80)]) cube([7,.3,42.5]);
		}
		translate([-hotend_depth/2,0,(-hotend_depth/2)-23/2]) cube([hotend_depth,hotend_depth,hotend_depth], center=true);
	}
}

module clamp() {
    
    module cable_hole() {
        difference() {
            union() {
                hull() {
                    translate([-13.5/2,-12.5/2,0]) cube([13.5,6,3]);
                    translate([0,16,0]) cylinder(d=13.5, h=3);
                }
            }
            rotate([-45,0,0]) translate([0,0,-4]) hull() {
                cylinder(d=7, h=19);
                translate([0,9,0]) cylinder(d=7, h=29);
            }
            rotate([30,0,0]) translate([2,2,-5]) cube([5,4,10]);
        }
    }
    
    union(){
        translate([-8,0,slop]) long_bow_tie_split(15);
        translate([8,0,slop]) long_bow_tie_split(15);
        translate([-11.75,-15,-3]) cube([23.5,15,3]);
        translate([-11.75,-15,0]) cube([7.5,15,0.6]);
        translate([4.25,-15,0]) cube([7.5,15,0.6]);
        translate([0,5,-3]) cable_hole();
    }
}

module prox_sensor_clamp() {
    height = 25;
    
    module halfround(h=5) {
        hull() {
            cylinder(d=30,h=h);
            translate([-30/2,-30/2,0]) cube([1,30,h]);
        }
    }
    
    module main() {
        halfround();
        translate([-17.5,-30/2,0]) cube([5,30,25]);
        translate([-2.5,0,24]) halfround(3);
    }

    difference() {
        main();
        cylinder(d=prox_sensor_dia, h=36);

        translate([0,0,5]) cylinder(d=prox_sensor_washer_dia+3, h=10);
        translate([-31,0,-5]) cylinder(d=prox_sensor_washer_dia+1, h=20);
        translate([-20,0,5+10/2]) cube([15,16,10], center=true);

        translate([-12,-12.5,21]) rotate([0,-90,0]) cylinder(d=bolt_hole_dia, h=10, $fn=20);
        translate([-12,11.5,18]) rotate([0,-90,0]) cylinder(d=bolt_hole_dia, h=10, $fn=20);
    }
        
}

module fan_duct() {

    nozzle_offset = 1.5;
    nozzle_width = 34;

    module fan_base() {
        difference() {
            translate([0,0,-2]) union() {
                translate([0,0,1]) cube([42,42,2],center=true);
                translate([-32.5/2,-32.5/2,0]) cylinder(d=6, h=6);
                translate([32.5/2,-32.5/2,0]) cylinder(d=6, h=6);
                translate([32.5/2,32.5/2,0]) cylinder(d=6, h=9);
                translate([-32.5/2,32.5/2,0]) cylinder(d=6, h=9);
                
                cylinder(d=43,h=2,$fn=60);
                translate([0,0,1]) duct(d2=13, x=nozzle_width-2);
                rotate([11,0,0]) translate([1.5,-13.25,16.6/2+4.3]) cube([23,15,16.5], center=true);
            }
            translate([0,0,-4]) cylinder(d=40,h=4,$fn=60);
            translate([-32.5/2,-32.5/2,-2]) cylinder(d=bolt_hole_dia-0.1, h=8);
            translate([32.5/2,-32.5/2,-2]) cylinder(d=bolt_hole_dia-0.1, h=8);
            translate([32.5/2,32.5/2,-2]) cylinder(d=bolt_hole_dia-0.1, h=8);
            translate([-32.5/2,32.5/2,-2]) cylinder(d=bolt_hole_dia-0.1, h=8);
            
            translate([-26/2+4,-42/2-3,6/2-2]) rotate([0,90,0]) cylinder(d=bolt_hole_dia, h=30);
            
            translate([0,0,-1]) duct(d=41, d2=11, x=nozzle_width-2, h=31.31);
            
            translate([-25/2,-17.19,15.9]) rotate([-90+11,0,0]) rotate([0,90,0]) male_dovetail(27);
        }
    }

    module capsule_3d(d=12, x=20, h=1) {
        hull() {
            translate([0,x/2,0]) cylinder(d=d, h=h, $fn=30);
            translate([0,-x/2,0]) cylinder(d=d, h=h, $fn=30);
        }
    }

    module duct(d=43, d2=11, x=nozzle_width, h=31.3) {
        hull() {
            cylinder(d=d,h=1);
            translate([nozzle_offset,14.2,h]) rotate([0,-11,90]) capsule_3d(d=d2, x=x);
        }
    }

    module nozzle() {

        module tube(d=8, h=20) {
            rotate([-90,0,0]) {

                hull() {
                    cylinder(d=d+2);
                    difference() {
                        hull() {
                            translate([-1,1,4]) cylinder(d=d);
                            translate([-1,d/2-2+1,0]) cube([d/2, 2, 4]);
                        }
                        translate([d-3,-d-1.5,4]) rotate([0,0,55]) cube([d,d,10]);
                    }
                }
                difference() {
                    hull() {
                        hull() {
                            translate([-1,1,4]) cylinder(d=d);
                            translate([-1,1,h]) sphere(d=d);
                        }
                        translate([-1,d/2-2+1,4]) cube([d/2, 2, h-4]);
                    }
                    translate([d-3,-d-1.5,0]) rotate([0,0,55]) cube([d,d,h+20]);
               }
            }
        }

        module hollow_tube() {
            difference() {
                tube(d=11, h=23);
                tube(d=9, h=23);
            }
        }

        module nozzle_main() {
            translate([-nozzle_width/2+1+nozzle_offset,0,0]) hollow_tube();
            translate([nozzle_width/2-1+nozzle_offset,0,0]) mirror([1,0,0])  hollow_tube();
            
            
            rotate([-90,0,0]) difference() {
                translate([nozzle_offset,0,1/2]) cube([28,13,1], center=true);
                translate([-nozzle_width/2+nozzle_offset,0,-1]) cylinder(d=12,h=2);
                translate([nozzle_width/2+nozzle_offset,0,-1]) cylinder(d=12,h=2);
            }
        }

        difference() {
            nozzle_main();
            translate([nozzle_width/2+nozzle_offset-4,24/2+1,-5]) rotate([0,50,0]) cube([4, 24, 5], center=true);
            translate([-nozzle_width/2+nozzle_offset+4,24/2+1,-5]) rotate([0,-50,0]) cube([3.5, 24, 5], center=true);
            
            translate([nozzle_offset,1,-4]) rotate([60,0,0]) cube([12,2.5,5], center=true);
        }
        
    }
    
    fan_base();
    translate([0,14,31.2]) rotate([101,0,0]) nozzle();

}

module do_mount() {
    translate([0,0,25/2-1]) mount();
    translate([0,-65,25/2-1]) mirror([0,1,0]) mount();
}

module gnd_fan_adapter() {
    // do not use
    union() {
        rotate([-90,0,0]) long_tie_split(23);
        translate([4,-1.5,0]) rotate([-90,0,180]) long_tie_split(23);
        translate([-6/2,-1.51,0]) cube([10, 1.52, 23]);
    }
}

module view_proper() {
    rotate([0,-90,0]) mount();
    rotate([0,-90,0]) mirror([0,0,1]) mount();
    %translate([0,1,-28.7]) rotate([-90,0,0]) do_motor_mount();
    %translate([0,25.3,-42.1]) do_rack(fast_render=true);
    %translate([0,-13,-127.7]) rotate([0,0,180]) e3dv6();
    %translate([29,-13.5,-120]) proximity_sensor(25.5,5);
    %translate([20,10.3,-76.2]) rotate([0,0,90]) extention();
    
    %translate([-60,-25,-76.2-43.5]) rotate([0,0,0]) extention();

    translate([29,-13.5,-90]) prox_sensor_clamp();
    translate([1.5,28,-99.8]) rotate([-101,0,180]) fan_duct();
}

//do_mount();
//clamp();
//rotate([0,-90,0])  prox_sensor_clamp();
//intersection() {
//    fan_duct();
//    cube([100,100,36]);
//}
//fan_duct();

//view_proper();

gnd_fan_adapter();
