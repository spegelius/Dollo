include <../globals.scad>;
include <../include.scad>;

use <../mockups.scad>;


bed_340_300_drill_jig();


module bed_340_300_drill_jig() {
    %bed_340_300();

    difference() {
        union() {
            translate([-200/2, -300/2 + 23, 0])
            cylinder(d=10, h=20, $fn=20);

            translate([200/2, -300/2 + 23, 0])
            cylinder(d=10, h=20, $fn=20);

            translate([-260/2, 300/2 - 27, 0])
            cylinder(d=10, h=20, $fn=20);

            translate([260/2, 300/2 - 27, 0])
            cylinder(d=10, h=20, $fn=20);

            hull() {
                translate([0, -127, 3/2])
                cube([200, 1, 3], center=true);

                translate([0, 125, 3/2])
                cube([265, 1, 3], center=true);
            }

            translate([-340/2 + 100/2, -117, 4/2])
            cube([100, 20, 4], center=true);

            translate([-340/2 + 20/2, -300/2 + 40/2, 4/2])
            cube([20, 40, 4], center=true);

            translate([0, -300/2 + 40/2, 4/2])
            cube([20, 40, 4], center=true);

            translate([0, 300/2 - 40/2, 4/2])
            cube([20, 40, 4], center=true);

            translate([-30, -125, 8/2])
            cube([260, 5, 8], center=true);

            translate([0, 125, 8/2])
            cube([260, 5, 8], center=true);

            hull() {
                translate([130, 125, 0])
                cylinder(d=5, h=8, $fn=30);

                translate([98, -125, 0])
                cylinder(d=5, h=8, $fn=30);
            }

            hull() {
                translate([-130, 125, 0])
                cylinder(d=5, h=8, $fn=30);

                translate([-98, -125, 0])
                cylinder(d=5, h=8, $fn=30);
            }
        }

        hull() {
            translate([0, -112, 0])
            cube([178, 1, 13], center=true);

            translate([0, 110, 0])
            cube([234, 1, 13], center=true);
        }

        translate([-200/2, -300/2 + 23, 0])
        cylinder(d=2, h=60, center=true, $fn=20);

        translate([200/2, -300/2 + 23, 0])
        cylinder(d=2, h=60, center=true, $fn=20);

        translate([-260/2, 300/2 - 27, 0])
        cylinder(d=2, h=60, center=true, $fn=20);

        translate([260/2, 300/2 - 27, 0])
        cylinder(d=2, h=60, center=true, $fn=20);
    }
}