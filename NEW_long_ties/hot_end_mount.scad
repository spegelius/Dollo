include <globals.scad>;
include <include.scad>;

use <long_tie.scad>;
use <long_bow_tie_experimental.scad>;
use <long_bow_tie.scad>;
use <motor_mount_small.scad>;
include <mockups.scad>;

hotend_depth = 75;
mounting_diamiter = 12+slop;
top_diamiter = 17;
arm_thickness = 5;
snap_location = 47;
natch_height = 6;

$fn=60;

module motor_mount_small(height=15){
	//scale([.9,.9,.9]) translate([-8.75,1,snap_location]) male_dovetail(35);
    translate([-8+slop,0.95,snap_location-6.2]) rotate([-90,0,0]) scale([.98,1,0.99]) long_tie(.9*35);
}

module y_mount_added(){
	motor_mount_small();
	translate([1,-4+((10-arm_thickness)/2),hotend_depth/2]) cube([25,arm_thickness,hotend_depth], center=true);
    translate([1,-15,hotend_depth-(natch_height)]) cube([25,30,natch_height*2],center=true);
	translate([-4,-15,hotend_depth-17]) rotate([-45,0,0]) cube([15,33.2,natch_height*2],center=true);
    translate([-4,-5,hotend_depth-27]) cube([15,5,natch_height*2],center=true);
	translate([1,1,0]) cube([25,8,5],center=true);
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
                    cylinder(d=12.5, h=3);
                    translate([0,10.5,0]) cylinder(d=12.5, h=3);
                }
                translate([-12.5/2,-12.5/2,0]) cube([12.5,6,3]);
            }
            rotate([-45,0,0]) translate([0,0,-4]) hull() {
                cylinder(d=7, h=19);
                translate([0,5.5,0]) cylinder(d=7, h=19);
            }
            rotate([30,0,0]) translate([2,2,-5]) cube([5,4,10]);
        }
    }
    
    union(){
        translate([-8,0,5]) long_bow_tie_split(15);
        translate([8,0,5]) long_bow_tie_split(15);
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
    nozzle_width = 30;
    
    module fan_base() {
        difference() {
            translate([0,0,-2]) union() {
                translate([0,0,1]) cube([42,42,2],center=true);
                translate([-32.5/2,-32.5/2,0]) cylinder(d=6, h=6);
                translate([32.5/2,-32.5/2,0]) cylinder(d=6, h=6);
                translate([32.5/2,32.5/2,0]) cylinder(d=6, h=9);
                translate([-32.5/2,32.5/2,0]) cylinder(d=6, h=9);
                
                cylinder(d=43,h=2,$fn=60);
                translate([-26/2+4,-42/2-1,0]) hull() {
                    cube([26, 9, 6]);
                    translate([0,6/2-5,6/2]) rotate([0,90,0]) cylinder(d=6,h=26);
                }
                translate([0,0,1]) duct(d2=12, x=nozzle_width-2);
            }
            translate([0,0,-4]) cylinder(d=40,h=4,$fn=60);
            translate([-32.5/2,-32.5/2,-2]) cylinder(d=bolt_hole_dia-0.2, h=8);
            translate([32.5/2,-32.5/2,-2]) cylinder(d=bolt_hole_dia-0.2, h=8);
            translate([32.5/2,32.5/2,-2]) cylinder(d=bolt_hole_dia-0.2, h=8);
            translate([-32.5/2,32.5/2,-2]) cylinder(d=bolt_hole_dia-0.2, h=8);
            
            translate([-26/2+4,-42/2-3,6/2-2]) rotate([0,90,0]) cylinder(d=bolt_hole_dia, h=30);
            
            translate([0,0,-1]) duct(d=41, d2=10, x=nozzle_width-2);
        }
    }
    
    module capsule_3d(d=12, x=20, h=1) {
        hull() {
            translate([0,x/2,0]) cylinder(d=d, h=h, $fn=30);
            translate([0,-x/2,0]) cylinder(d=d, h=h, $fn=30);
        }
    }
    
    module duct(d=43, d2=10, x=nozzle_width) {
        hull() {
            cylinder(d=d,h=1);
            translate([nozzle_offset,12,31.3]) rotate([0,-18,90]) capsule_3d(d=d2, x=x);
        }
    }

    module nozzle() {
        
        module tube(d=8, h=20) {
            rotate([-90,0,0]) {
                hull() {
                    cylinder(d=d+2);
                    translate([-1,1,4]) cylinder(d=d);
                    translate([-1,1,0]) cube([d/2, d/2, 4]);
                }
                hull() {
                    translate([-1,1,4]) cylinder(d=d);
                    translate([-1,1,h]) sphere(d=d);
                    translate([-1,1,4]) cube([d/2, d/2, h-4]);
                }
            }
        }
        
        module hollow_tube() {
            difference() {
                tube(d=10, h=23);
                tube(d=8, h=23);
            }
        }
        
        module nozzle_main() {
            translate([-nozzle_width/2+1+nozzle_offset,0,0]) hollow_tube();
            translate([nozzle_width/2-1+nozzle_offset,0,0]) mirror([1,0,0])  hollow_tube();
            
            
            rotate([-90,0,0]) difference() {
                translate([nozzle_offset,0,1/2]) cube([28,12,1], center=true);
                translate([-nozzle_width/2+nozzle_offset,0,-1]) cylinder(d=12,h=2);
                translate([nozzle_width/2+nozzle_offset,0,-1]) cylinder(d=12,h=2);
            }
        }
        
        difference() {
            nozzle_main();
            translate([nozzle_width/2+nozzle_offset-4,24/2+1,-5]) rotate([0,45,0]) cube([2, 24, 5], center=true);
            translate([-nozzle_width/2+nozzle_offset+4,24/2+1,-5]) rotate([0,-45,0]) cube([2, 24, 5], center=true);
            
            translate([nozzle_offset,1,-4]) rotate([60,0,0]) cube([10,2.5,5], center=true);
        }
        
    }
    
    fan_base();
    translate([0,11.75,31]) rotate([108,0,0]) nozzle();

}

module fan_mount() {
    
    module mount_body() {
        union() {
            cube([4,34,10]);
            translate([-22,-4.1,0]) cube([26,7,10]);
            translate([-22, -4.1,-5]) cube([26,5.1, 7]);
            translate([-22,-4,-7.5]) hull() {
                cube([26,5, 6]);
                translate([0,-1,3]) rotate([0,90,0]) cylinder(d=6, h=26);
            }
        }
    }
    
    difference() {
        mount_body();
        translate([5,6,3.5]) rotate([0,-90,0]) cylinder(d=bolt_hole_dia, h=10, $fn=20);
        translate([5,30,6.5]) rotate([0,-90,0]) cylinder(d=bolt_hole_dia, h=10, $fn=20);
        
        translate([5,-5,-4.5]) rotate([0,-90,0]) cylinder(d=bolt_hole_dia, h=30, $fn=20);
        
        translate([4.1,6,3.5]) rotate([0,-90,0]) nut(cone=false);
        translate([4.1,30,6.5]) rotate([0,-90,0]) nut(cone=false);
        
        // doves
        translate([-3.7,3,3]) rotate([0,0,180]) male_dovetail();
        translate([-19.4,3,3]) rotate([0,0,180]) male_dovetail();
    }
}

module fan_mount_clip() {
    length = 9;
    gap = 26.3;
    rotate([0,90,0]) difference() {
        hull () {
            cylinder(d=6, h=gap+4);
            translate([0,length,0]) cylinder(d=6,h=gap+4);
            translate([-4,2,0]) cube([1,5,gap+4]);
        }
        cylinder(d=bolt_hole_dia, h=32);
        translate([0,length,0]) cylinder(d=bolt_hole_dia, h=32);
        
        translate([0,-2,2]) cylinder(d=11, h=gap);
        translate([0,length+2,2]) cylinder(d=11, h=gap);
    }
}

module do_mount() {
    translate([0,0,25/2-1]) mount();
    translate([0,-65,25/2-1]) mirror([0,1,0]) mount();
}

module view_proper() {
    rotate([0,-90,0]) mount();
    rotate([0,-90,0]) mirror([0,0,1]) mount();
    %translate([0,21.6,-28.7]) rotate([-90,0,0]) do_motor_mount();
    %translate([0,-13,-124]) rotate([0,0,180]) e3dv6();
    %translate([29,-13.5,-120]) proximity_sensor(25.5,5);
    translate([29,-13.5,-90]) prox_sensor_clamp();
    
    translate([-11.5,4,-75.5]) rotate([0,0,180]) fan_mount();
    translate([1.5,28,-96]) rotate([-108,0,180]) fan_duct();
    translate([-17.5,10,-71.5]) rotate([-4,0,0]) fan_mount_clip();
}

//do_mount();
//clamp();
//rotate([0,-90,0])  prox_sensor_clamp();

fan_duct();
//fan_mount_clip();
//fan_mount();

//view_proper();
