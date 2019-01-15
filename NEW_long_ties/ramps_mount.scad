include <globals.scad>;
include <include.scad>;
use <long_tie.scad>;
use <long_bow_tie.scad>;

box_width = 83;
box_length = 123;

$fn=30;

arduino_width = 53.7;
arduino_length = 101.6;
arduino_thickness = 2;

ramps_mount_w = arduino_width + 5;
ramps_mount_l = arduino_length;

ramps_w = 60.5;
ramps_l = 123;

raspberry_pi_3b_w = 56.1;
raspberry_pi_3b_l = 85;

raspi_mount_w = raspberry_pi_3b_w + 4;
raspi_mount_l = raspberry_pi_3b_l + 1;

module ear() {
    hull() {
        translate([0,0,0]) cube([5,15,0.1]);
        translate([20,7.5,0]) cylinder(d=15,h=0.1);

        translate([0,3.5,3.9]) cube([5,8,0.1]);
        translate([20,7.5,3.9]) cylinder(d=8,h=0.1);
    }
}

module ears() {
    difference() {
        hull() {
            ear();
            mirror([1,0,0]) ear();
        }
        translate([20,7.5,0]) cylinder(d=bolt_hole_dia,h=7);
        translate([20,7.5,1.8]) nut();

        translate([-20,7.5,0]) cylinder(d=bolt_hole_dia,h=7);
        translate([-20,7.5,1.8]) nut();
    }
}

module ramps_mount_adapter() {
    // for thing: https://www.thingiverse.com/thing:861360
    // drill holes to the box and use 3mm screws & nuts
    difference() {
        union() {
            translate([0,3.5,0]) cube([20, box_length-27, 7.5]);
            translate([10, box_length-20-15, 0]) ears();
            translate([10, 0, 0]) ears();
        }
        translate([10, 0, 7.5]) rotate([-90,0,0]) male_dovetail(box_length);
    }
}

module _stripe() {
    x = arduino_width/4;
    y = x/2;
    hull() {
        translate([-x,y,0]) cylinder(d=4, h=5,$fn=20);
        translate([x,-y,0]) cylinder(d=4, h=5,$fn=20);
    }
}

module _notch(w=2,l=10) {
    notch_h = sqrt(w*w*2);
    rotate([0,45,0]) cube([w,l,w], center=true);
    translate([0,0,-arduino_thickness-notch_h/1.8]) rotate([0,45,0]) cube([w,l,w], center=true);
}

module ramps_mount() {

    module bow_ear() {
        difference() {
            cube([22,15,8]);
            translate([15,22,0]) rotate([90,0,0]) male_dovetail(25);
        }
    }

    // bottom thickness + arduino clearance + arduino mount height
    h = 2.5 + 2 + arduino_thickness + 4;
    h2 = h - 2.5;

    union() {
        difference() {
            translate([0,0,h/2]) cube([ramps_mount_w, arduino_length, h], center=true);
            translate([0,2,h2/2+(h-h2)]) cube([arduino_width, arduino_length, h2], center=true);
            translate([0,-1,h2/2+(h-h2)+2]) cube([arduino_width-3, arduino_length, h2], center=true);
            for(i = [0:8]) {
                translate([0,-arduino_length/3+i*8,0]) _stripe();
            }
        }

        translate([arduino_width/2,arduino_length/2-10,h-1.4]) _notch();
        translate([arduino_width/2,-arduino_length/2+10,h-1.4]) _notch();

        translate([-arduino_width/2,arduino_length/2-10,h-1.4]) _notch();
        translate([-arduino_width/2,-arduino_length/2+10,h-1.4]) _notch();

        translate([ramps_mount_w/2-0.01,arduino_length/2-25,0]) rotate([0,0,180,0]) long_tie_half(20);
        translate([ramps_mount_w/2-0.01,-arduino_length/2+5,0]) rotate([0,0,180,0]) long_tie_half(20);
        translate([-20/2,-ramps_mount_l/2+0.01,0]) rotate([0,0,90,0]) long_tie_half(20);

        translate([-ramps_mount_w/2+0.01,arduino_length/2-5,0]) long_tie_half(20);
        translate([-ramps_mount_w/2+0.01,-arduino_length/2+25,0])  long_tie_half(20);
        translate([-20/2,-ramps_mount_l/2+0.01,0]) rotate([0,0,90,0]) long_tie_half(20);
    }
}

module raspberry_pi_3b_mount() {
    // download: https://www.thingiverse.com/thing:1701186
    %translate([-29.5,45,0.6]) rotate([0,0,-90]) import("../../_downloaded/Raspberry_pi_3_reference/Raspberry_Pi_3_Light_Version.STL");
    
    h = 11;

    difference() {
        cube([raspi_mount_w,raspi_mount_l,h], center=true);
        translate([0,0,2.5]) cube([raspberry_pi_3b_w,raspi_mount_l+1,h], center=true);

        for(i = [0:7]) {
            translate([0,i*7-raspi_mount_l/3.4,-h/2]) _stripe();
        }
        translate([-raspi_mount_w/2-1,27,8/2-1.6]) cube([9.8,9,4]);
        translate([-raspi_mount_w/2-1,2.4,8/2-1.6]) cube([10,16,4]);
        translate([-raspi_mount_w/2-1,-11.2,8/2+2]) rotate([0,90,0]) cylinder(d=8,h=5,$fn=20);
    }

    translate([raspberry_pi_3b_w/2, raspi_mount_l/2-3.75,h/2-1]) _notch(w=1.5,l=7.5);
    translate([raspberry_pi_3b_w/2, -raspi_mount_l/2+21,h/2-1]) _notch(w=1.5);
    translate([-raspberry_pi_3b_w/2, raspi_mount_l/2-3.5,h/2-1]) _notch(w=1.5,l=7);
    translate([-raspberry_pi_3b_w/2, -raspi_mount_l/2+22,h/2-1]) _notch(w=1.5,l=10);

    translate([-raspi_mount_w/2+0.01,raspi_mount_l/2-5,-h/2]) long_tie_half(20);
    translate([-raspi_mount_w/2+0.01,-raspi_mount_l/2+25,-h/2]) long_tie_half(20);

    translate([raspi_mount_w/2-0.01,raspi_mount_l/2-25,-h/2]) rotate([0,0,180]) long_tie_half(20);
    translate([raspi_mount_w/2-0.01,-raspi_mount_l/2+5,-h/2]) rotate([0,0,180]) long_tie_half(20);

    translate([-20/2,-raspi_mount_l/2+0.01,-h/2]) rotate([0,0,90,0]) long_tie_half(20);
    translate([20/2,raspi_mount_l/2-0.01,-h/2]) rotate([0,0,-90,0]) long_tie_half(20);
}

module atx_connector_mount() {
    // for the connector parts, see: https://github.com/spegelius/3DModels/blob/master/PrinterParts/ATX_Connector_Mount.scad

    wall = 2.5;
    inner_w = 79.35;
    outer_w = inner_w+2*wall;
    l = 70;
    h = 14;

    union() {
        difference() {
            translate([0,0,14/2]) cube([outer_w, l, h], center=true);
            translate([0,2,14/2+wall]) cube([inner_w, l+1, h], center=true);
            translate([0,0,14/2+wall+1.5]) cube([inner_w-3, l+1, h], center=true);

            for(i = [0:6]) {
                translate([0,i*7-l/3.4,-0.01]) _stripe();
            }

        }

        translate([inner_w/2, l/2-3.75,h-1]) _notch(w=1.5,l=7.5);
        translate([inner_w/2, -2,h-1]) _notch(w=1.5,l=15);
        translate([inner_w/2, -l/2+5,h-1]) _notch(w=1.5,l=7.5);

        translate([-inner_w/2, l/2-3.75,h-1]) _notch(w=1.5,l=7.5);
        translate([-inner_w/2, -2,h-1]) _notch(w=1.5,l=15);
        translate([-inner_w/2, -l/2+5,h-1]) _notch(w=1.5,l=7.5);

        translate([-outer_w/2+0.01,l/2-5,0]) long_tie_half(20);
        translate([-outer_w/2+0.01,-l/2+25,0]) long_tie_half(20);

        translate([outer_w/2-0.01,l/2-25,0]) rotate([0,0,180]) long_tie_half(20);
        translate([outer_w/2-0.01,-l/2+5,0]) rotate([0,0,180]) long_tie_half(20);

        translate([-20/2,-l/2+0.01,0]) rotate([0,0,90,0]) long_tie_half(20);
    }
}

module fan_mount_60mm() {
    // inspired by: https://www.thingiverse.com/thing:145946
    h = 12;
    l = 50;
    wall = 3.5;
    inner_w = ramps_w-4;
    outer_w = inner_w + 2*wall;

    difference() {
        rounded_cube_side(outer_w,l,h,5, center=true);
        translate([0,wall,1.5]) rounded_cube_side(inner_w,l,h+1, 4, center=true);
        translate([0,wall+10,0]) cube([inner_w,l,h+1], center=true);
        translate([0,l/2-3,0]) cube([ramps_w-1,2.2,20], center=true);

        translate([0,l/2-10,20/2]) chamfered_cube(outer_w+20,l,20,7, center=true);

        translate([0,0,60/2-h/2+4]) rotate([90,0,0]) {
            cylinder(d=60,h=100,$fn=60);
            translate([-25,-25,0]) cylinder(d=2.8,h=100,$fn=20);
            translate([25,-25,0]) cylinder(d=2.8,h=100,$fn=20);
        }

        #mirror([1,0,0]) translate([outer_w/2-5,-l/2+10,-h/2]) rotate([0,0,180]) linear_extrude(0.6) text(align="center",size=8, "RAMPS 1.4");
    }
}

module _male_dove_half(h) {
    intersection() {
        scale([1.08,1.02,1]) male_dovetail(h);
        translate([-5,0,0]) cube([5,5,h]);
    }
}

module frame_clip() {
    union() {
        difference() {
            translate([0,2,0]) rounded_cube_side(8,12,20,3);
            translate([6,2,0]) _male_dove_half(21);
        }
        translate([8-2,0,0]) rounded_cube_side(2,14,20,2);
        translate([3.5,14,0]) rotate([-90,0,180]) long_bow_tie_half(20);
    }
}

module joint_clip() {
    union() {
        difference() {
            translate([0,2,0]) rounded_cube_side(8,12,20,3);
            translate([6,2,0]) _male_dove_half(21);
            translate([6,14,0]) mirror([0,1,0]) _male_dove_half(21);
        }
        translate([8-2,0,0]) rounded_cube_side(2,16,20,2);
    }
}

module debug() {
    frame_mockup(units_x=2, units_y=2);
    translate([120.65,-180,80.8]) rotate([90,0,0]) ramps_mount();
}

//debug();

//translate([95,127.5,0]) rotate([90,0,0]) body();
//ramps_mount_adapter();
//ramps_mount();
raspberry_pi_3b_mount();
//atx_connector_mount();
//fan_mount_60mm();
//frame_clip();
//joint_clip();