include <globals.scad>;
include <include.scad>;

$fn=32;

height = 32;

module coupler1 () {
    module body() {
        union() {
            difference() {
                cylinder(d=30, h=height);
                translate([0,0,height/2]) cylinder(d=hole_threaded_rod, h=height/2+1);
                motor_shaft_hole(height/2+1);
                // bolt holes
                translate([-height/2,9,5]) rotate([0,90,0]) cylinder(d=bolt_hole_dia, h=height);
                translate([-height/2,-9,5]) rotate([0,90,0]) cylinder(d=bolt_hole_dia, h=height);
            
                translate([9,height/2,27]) rotate([90,0,0]) cylinder(d=bolt_hole_dia, h=height);
                translate([-9,height/2,27]) rotate([90,0,0]) cylinder(d=bolt_hole_dia, h=height);

                // bolt head holes
                translate([-height/2,9,5]) rotate([0,90,0]) cylinder(d=bolt_head_hole_dia, h=9);
                translate([-height/2,-9,5]) rotate([0,90,0]) cylinder(d=bolt_head_hole_dia, h=9);
            
                translate([9,height/2,27]) rotate([90,0,0]) cylinder(d=bolt_head_hole_dia, h=9);
                translate([-9,height/2,27]) rotate([90,0,0]) cylinder(d=bolt_head_hole_dia, h=9);

                // nut holes
                translate([8,9,5]) rotate([0,90,0]) nut(6);
                translate([8,-9,5]) rotate([0,90,0]) nut(6);

                translate([9,-8,27]) rotate([90,0,0]) nut(6);
                translate([-9,-8,27]) rotate([90,0,0]) nut(6);
            }
            
        }
        
        module throat() {
            translate([-0.7,4.2,height/2+1]) rotate([-5,0,0]) cube([1,3,10]);
        }
        rotate([0,0,45]) throat();
        rotate([0,0,135]) throat();
        rotate([0,0,225]) throat();
        rotate([0,0,315]) throat();
            
    }

    difference() {
        body();
        translate([-1,-height/2,0]) cube([2, height, height/2]);
        translate([-height/2,-1,height/2]) cube([height, 2, height/2]);
    }
}

module coupler2() {
    
    difference() {
        cylinder(d=10, h=15);
        motor_shaft(16);
        rotate([0,0,180]) translate([-0.5,0,0]) cube([1, 5, 15]);
    }
    
    // clamp
    module clamp() {
        difference() {
            cylinder(d=28, h=10);
            cylinder(d=13.2, h=10);

            // bolt holes
            translate([-height/2,9,5]) rotate([0,90,0]) cylinder(d=bolt_hole_dia, h=height);
            translate([-height/2,-9,5]) rotate([0,90,0]) cylinder(d=bolt_hole_dia, h=height);
    
            // bolt head holes
            translate([-height/2,9,5]) rotate([0,90,0]) cylinder(d=bolt_head_hole_dia, h=9);
            translate([-height/2,-9,5]) rotate([0,90,0]) cylinder(d=bolt_head_hole_dia, h=9);
        
            // nut holes
            translate([8,9,5]) rotate([0,90,0]) nut(6);
            translate([8,-9,5]) rotate([0,90,0]) nut(6);
        
            translate([-1,-height/2,0]) cube([2, height, height/2]);
        }
    }
    translate([25,0,0]) clamp();
    translate([0,25,0]) clamp();
    
}

//coupler1();
coupler2();