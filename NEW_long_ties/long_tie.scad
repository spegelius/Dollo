length = 50;

include <include.scad>;
include <globals.scad>;

use <long_bow_tie.scad>;

$fn=30;

// alter these the get properly fitting parts
scale_x = scale_x();
scale_z = scale_z();
length = 50;


//long_tie(length);
//long_tie_half(length);
long_tie_half(20);
//long_tie_half(30);
//long_tie_half(40);
//long_tie_split(length);


module long_tie(length=length) {
    translate([0, 0, scaled_male_dove_depth()])
    rotate([0, 180, 0])
    difference() {
        long_bow_tie(length, scale_x=scale_x, scale_z=scale_z);

        translate([
            -5, -length/2 - 1, scaled_male_dove_depth()
        ])
        cube([10, length + 2, male_dove_depth]);
    }
}

module long_tie_split(length=length) {
    union() {
        difference() {
            translate([0, 0, -male_dove_depth + slop])
            long_bow_tie_split(length);

            translate([0, 0, -3.5])
            cube([10, length + 1, 7], center=true);
        }
        translate([0, 0, 0.8])
        cube([4, length, 1.6], center=true);
    }
}

module long_tie_half(length=length) {
    rotate([0, -90, 0])
    intersection() {
        long_tie(length);

        translate([0, -length/2, 0])
        cube([5, length, 5]);
    }
}
