
use <../bed_carriage.scad>

// ye olde stuff
//
//module qnd() {
//    difference() {
//        corner_arm();
//        cube([95,95,15]);
//        translate([0,0,5]) cube([140,140,15]);
//        cube([140,140,1]);
//    }
//}
//
//rotate([180,0,0]) qnd();

module rail_center_quickfix_joiner() {
    difference() {
        bed_rail_center();
        cylinder(d=20,h=58.9);
    }
    rotate([0,0,45]) intersection() {
        bed_rail_center();
        translate([1,1,59/2]) cube([9.5,9.5,59],center=true);
    }
}

module rail_center_quickfix_joiner2() {
    difference() {
        bed_rail_center();
        translate([0,0,58.9]) cylinder(d=20,h=68.9);
    }
    translate([0,0,58.89]) rotate([0,0,-15]) intersection() {
        bed_rail_center();
        translate([1,1,30/2]) cube([9.5,9.5,30],center=true);
    }
}

//rail_center_quickfix_joiner();
rail_center_quickfix_joiner2();