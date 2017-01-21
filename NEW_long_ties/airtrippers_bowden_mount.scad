use <long_bow_tie.scad>;
include <include.scad>;
include <globals.scad>;

$fn=35;

module fixing_pin(pin_size=6.4) {
    difference() {
        union() {
            cylinder(3, r=pin_size/2);
            hull() {
                translate([0,0,3]) cylinder(0.5, r=pin_size/2);
                translate([0,0,3.5]) cylinder(1, r=pin_size/2+0.5);
                translate([0,0,4.5]) cylinder(1, r=2);
            }
        }
        cube([8,1,12], center=true);
    }
}

module fixing_plate(pin_distance, pin_size) {
    difference() {
        union () {
            translate([-14.5,0,10]) cube([7,74,20], center = true);
            translate([-14.5,-74/2+20/2,10]) cube([7,20,50], center = true);
        }
		union() {
			// fixing plate cutout
			translate([-16,36,0]) rotate([45,0,0]) cube([16,16,7], center = true);
			translate([-16,-35,-16]) rotate([135,0,0]) cube([16,16,7], center = true);
			translate([-16,36,20]) rotate([135,0,0]) cube([16,16,7], center = true);
			translate([-16,-19,-16]) rotate([45,0,0]) cube([16,16,7], center = true);
            
            translate([-16,-19,36]) rotate([135,0,0]) cube([16,16,7], center = true);
            translate([-16,-35,36]) rotate([45,0,0]) cube([16,16,7], center = true);
		}
	}
	translate([-18,-pin_distance/2,10]) rotate([0,270,0]) fixing_pin(pin_size);
	translate([-18,pin_distance/2,10]) rotate([0,270,0]) fixing_pin(pin_size);

}

module do_airtrippers_bowden_mount(pin_distance=61, pin_size=6.4) {
    difference() {
        translate([0,0,-11]) rotate([0,90,0]) fixing_plate(pin_distance, pin_size);
        translate([10,40,0]) rotate([90,0,0]) male_dovetail(height=80);
        translate([40,-27,0]) rotate([90,0,-90]) male_dovetail(height=80);
    }
}

do_airtrippers_bowden_mount();

// pins scaled due to wrong dimension airtrippers
//do_airtrippers_bowden_mount(59, 6);