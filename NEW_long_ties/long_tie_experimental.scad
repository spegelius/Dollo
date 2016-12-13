use <long_bow_tie_experimental.scad>;

union() {
    difference() {
        long_bow_tie_split(50);
        translate([0,-25, -3.5]) cube([10,51,7], center=true);
    }
    translate([0,-25, 0.8]) cube([4,50,1.6], center=true);
}