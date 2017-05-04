use <long_bow_tie.scad>;
include <include.scad>;
include <globals.scad>;

$fn=35;


module fixing_plate() {
    difference() {
        union () {
            translate([-14.5,0,10]) cube([7,74,20], center = true);
            translate([-14.5,-74/2+20/2,10]) cube([7,20,50], center = true);
            translate([-25,0,4.4]) cube([14, 74, 4], center=true);
            translate([-25,0,15.6]) cube([14, 74, 4], center=true);
        }
		union() {
			// fixing plate cutout
			translate([-16,36,0]) rotate([45,0,0]) cube([16,16,7], center = true);
			translate([-16,-35,-16]) rotate([135,0,0]) cube([16,16,7], center = true);
			translate([-16,36,20]) rotate([135,0,0]) cube([16,16,7], center = true);
			translate([-16,-19,-16]) rotate([45,0,0]) cube([16,16,7], center = true);
            
            translate([-16,-19,36]) rotate([135,0,0]) cube([16,16,7], center = true);
            translate([-16,-35,36]) rotate([45,0,0]) cube([16,16,7], center = true);
            
            translate([-27.5,-36,10]) rotate([90,0,-45]) cube([26,16,12], center = true);
            translate([-27.5,36,10]) rotate([90,0,45]) cube([26,16,12], center = true);
		}
        translate([-28,-15,0]) cylinder(d=m4_bolt_hole_dia, h=20);
        translate([-28,14,0]) cylinder(d=m4_bolt_hole_dia, h=20);
        

        translate([-42,-22,0]) rotate([0,0,45]) cube([30,30,30]);
	}
}

module do_shy_rockabilly_mount() {
    difference() {
        translate([0,0,-11]) rotate([0,90,0]) fixing_plate();
        translate([10,40,0]) rotate([90,0,0]) male_dovetail(height=80);
        translate([40,-27,0]) rotate([90,0,-90]) male_dovetail(height=80);
    }
}

do_shy_rockabilly_mount();
