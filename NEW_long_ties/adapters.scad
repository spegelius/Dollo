
include <include.scad>;
include <globals.scad>;
use <long_tie.scad>;

$fn=30;

module adapter_mks_sbase_box() {
    
    h = 20;

    difference() {
        union() {
            intersection() {
                union() {
                    difference() {
                        translate([0,-11.5,0]) cube([35,23,h],center=true);
                        cube([30,30,60],center=true);
                        translate([0,-15,-30]) rotate([0,0,180]) male_dovetail();
                    }
                    translate([15,0,0]) rotate([0,0,5]) cube([3,5,h],center=true);
                    translate([-15,0,0]) rotate([0,0,-5]) cube([3,4.8,h],center=true);
                }
                translate([0,-11.5]) chamfered_cube(35,23,20,1,center=true);
            }
            translate([-80,-18,-10]) rotate([90,0,0]) chamfered_cube_side(70,10,5,3);
            translate([-24,-20,-10]) hull() {
                rotate([0,0,35]) cube([10,1,5]);
                translate([7.5,1/2,0]) cylinder(d=1,h=5);
            }
        }
        translate([-10,-24,-5]) rotate([-90,0,0]) cylinder(d=2.8,h=8,$fn=20);
        translate([-75,-24,-5]) rotate([-90,0,0]) cylinder(d=2.8,h=8,$fn=20);
    }
}

module adapter_dove_m3_28() {
    difference() {
        translate([0,34/2,0]) long_tie(34);
        translate([0,0,5/2+0.6]) cube([2.5,35,5],center=true);
        translate([0,28/2,0]) cylinder(d=2.8,h=5,$fn=20);
        translate([0,-28/2,0]) cylinder(d=2.8,h=5,$fn=20);
        
    }
}

module adapter_dove_m3_15() {
    difference() {
        translate([0,15/2,0]) long_tie(15);
        translate([0,0,5/2+0.6]) cube([2.5,16,5],center=true);
        cylinder(d=2.8,h=5,$fn=20);
    }
}


module adapter_shy_rockabilly() {

    // adapter for this extruder: https://www.thingiverse.com/thing:1223730

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
    
    
    difference() {
        fixing_plate();
        translate([8,0,0]) rotate([0,0,90]) male_dovetail(height=80);
        translate([8+15,15,0]) rotate([0,0,0]) male_dovetail(height=80);
    }
}

module airtrippers_fixing_pin(pin_size=6.4) {
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

module airtrippers_fixing_plate(pin_distance, pin_size) {
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
	translate([-18,-pin_distance/2,10]) rotate([0,270,0]) airtrippers_fixing_pin(pin_size);
	translate([-18,pin_distance/2,10]) rotate([0,270,0]) airtrippers_fixing_pin(pin_size);

}

module adapter_airtrippers_bowden_extruder(pin_distance=61, pin_size=6.4) {
    difference() {
        translate([0,0,-11]) rotate([0,90,0]) airtrippers_fixing_plate(pin_distance, pin_size);
        translate([10,40,0]) rotate([90,0,0]) male_dovetail(height=80);
        translate([40,-27,0]) rotate([90,0,-90]) male_dovetail(height=80);
    }
}

//adapter_mks_sbase_box();
//adapter_dove_m3_28();
adapter_dove_m3_15();
//adapter_shy_rockabilly();
//adapter_airtrippers_bowden_extruder();