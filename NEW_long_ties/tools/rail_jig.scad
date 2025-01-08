include <../globals.scad>;
include <../include.scad>;

length = 150; // should be enough
hex_width = 15; // same as bed rail width


//debug();

//rail_jig();
//rail_jig_clip();
rail_drill_jig();


module debug() {
    rail_jig();

    translate([0, -40, 54.4])
    rotate([0, 180, 0])
    rail_jig_clip();
}

module rail_jig() {

    difference() {
        union() {
            translate([0, 0, 30/2])
            cube([12, length,20], center=true);

            translate([0, length/2, 30])
            rotate([90, 0, 0])
            hexagon(hex_width + 8, length);

            translate([0, 0, 40])
            cube([18, length, 13], center=true);
        }

        translate([0, length/2 + 1, 30])
        rotate([90, 0, 0])
        hexagon(hex_width, length + 2);

        translate([0, 0, 20])
        cube([1, length + 2, 19], center=true);

        translate([0, 0, 35])
        cube([30, 10, 30], center=true);

        translate([0, 0, 50])
        cube([12, length + 2, 32], center=true);
    }
}

module rail_jig_clip() {

    w = 14 + 2*3 + 2*4 + 2*slop;

    difference() {
        translate([0, 0, 8/2])
        union() {
            rounded_cube(w, 20, 8, 4, center=true);

            translate([0, 0, 4])
            rounded_cube(14, 20, 10, 4, center=true);

            translate([-w/2 + 2, 0, 4])
            rounded_cube(4, 20, 10, 4, center=true);

            translate([w/2 - 2, 0, 4])
            rounded_cube(4, 20, 10, 4, center=true);
        }
        translate([w/2 + 15/2 - 2, 0, 0])
        cylinder(d=15, h=15, $fn=50);

        translate([-w/2 - 15/2 + 2, 0, 0])
        cylinder(d=15, h=15, $fn=50);
    }
}

module rail_drill_jig() {
    difference() {
        hexagon(hex_width + 10, 100);

        translate([0, 0, 40])
        hexagon(hex_width + 0.2, 100);

        cylinder(d=8.1, h=400, center=true, $fn=40);
    }
}