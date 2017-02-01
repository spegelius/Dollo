
use <long_tie.scad>;
length=50;

rotate([0,-90,0]) intersection() {
    long_tie(length);
    translate([0,-length,0]) cube([5,length,5]);
}
