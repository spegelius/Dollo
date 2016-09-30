
use <../bed_carriage.scad>

module qnd() {
    difference() {
        corner_arm();
        cube([95,95,15]);
        translate([0,0,5]) cube([140,140,15]);
        cube([140,140,1]);
    }
}

rotate([180,0,0]) qnd();