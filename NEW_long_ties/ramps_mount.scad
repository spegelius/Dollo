include <globals.scad>;
include <include.scad>;

box_width = 83;
box_length = 123;

frame_mockup(units_x=2, units_y=2);

$fn=30;

arduino_width = 53.3;
arduino_length = 101.6;
arduino_thickness = 2;

ramps_mount_w = arduino_width + 5;
ramps_mount_l = arduino_length;

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

module ramps_mount() {
    
    module notch() {
        notch_h = sqrt(2*2*2);
        rotate([0,45,0]) cube([2,10,2], center=true);
        translate([0,0,-arduino_thickness-notch_h/2]) rotate([0,45,0]) cube([2,10,2], center=true);
    }
    
    module bow_ear() {
        difference() {
            cube([22,20,8]);
            translate([15,22,0]) rotate([90,0,0]) male_dovetail(25);
        }
    }
    
    // bottom thickness + arduino clearance + arduino mount height
    h = 2.5 + 2 + arduino_thickness + 2;
    h2 = h - 2.5;
    
    union() {
        difference() {
            translate([0,0,h/2]) cube([ramps_mount_w, arduino_length, h], center=true);
            translate([0,2,h2/2+(h-h2)]) cube([arduino_width, arduino_length, h2], center=true);
            translate([0,-1,h2/2+(h-h2)+2]) cube([arduino_width-3, arduino_length, h2], center=true);
        }
        
        translate([arduino_width/2,arduino_length/2-10,h]) notch();
        translate([arduino_width/2,-arduino_length/2+10,h]) notch();
        
        translate([-arduino_width/2,arduino_length/2-10,h]) notch();
        translate([-arduino_width/2,-arduino_length/2+10,h]) notch();
        
        translate([ramps_mount_w/2,0,0]) bow_ear();
        translate([-20/2,-ramps_mount_l/2,0]) rotate([0,0,-90]) bow_ear();
    }
    
}

module debug() {
    
    translate([120.65,-180,80.8]) rotate([90,0,0]) ramps_mount();
}

debug();

//translate([95,127.5,0]) rotate([90,0,0]) body();
//ramps_mount_adapter();
//ramps_mount();