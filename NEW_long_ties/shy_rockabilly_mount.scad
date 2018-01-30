use <long_bow_tie.scad>;
include <include.scad>;
include <globals.scad>;

$fn=35;


module fixing_plate() {
    difference() {
        union () {
            translate([8/2,0,20/2]) cube([8,46,20], center = true);
            translate([-15/2,0,5/2]) cube([15, 46, 5], center=true);
            translate([23/2+8,15+8/2,20/2]) cube([23, 8, 20], center=true);
        }
        translate([-10,-15,0]) cylinder(d=m4_bolt_hole_dia, h=20);
        translate([-10,14,0]) cylinder(d=m4_bolt_hole_dia, h=20);
        

        translate([-24,-22,0]) rotate([0,0,45]) cube([30,30,30]);
	}
}

module do_shy_rockabilly_mount() {
    difference() {
        fixing_plate();
        translate([8,0,0]) rotate([0,0,90]) male_dovetail(height=80);
        translate([8+15,15,0]) rotate([0,0,0]) male_dovetail(height=80);
    }
}

do_shy_rockabilly_mount();
