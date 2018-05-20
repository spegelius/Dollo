include <globals.scad>;
include <include.scad>;

$fn=40;

height = 32;

// A rigid clamp for leadscrew. Uses 3mm bolts and nuts to tighten
module rigid_leadscrew_coupler () {
    module body() {
        union() {
            difference() {
                cylinder(d=30, h=height);
                translate([0,0,height/2]) cylinder(d=hole_threaded_rod, h=height/2+1);
                motor_shaft(height/2+1);
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

// Flexible coupler motor shaft adapter. 10mm outer diameter
module motor_shaft_adapter() {
    difference() {
        ridged_cylinder(d=10, h=15, r=3);
        motor_shaft(16, extra_slop=slop);
        rotate([0,0,180]) translate([-0.5,0,0]) cube([1, 8, 15]);
    }
}

// Fexible coupler tube. Print ith flexible filament or use silicon tube instead
module flexible_coupler_tube(h=32) {
    wall = 1.6;
    difference() {
        cylinder(d=10+2*wall, h=h);
        ridged_cylinder(d=10, h=h, r=3);
    }
}

// Clamp for flexible coupler. Uses m3 bolts and nuts to tighten
module flexible_coupler_clamp() {
    
    // clamp
    module clamp() {
        difference() {
            cylinder(d=25, h=10);
            cylinder(d=13, h=10);

            // bolt holes
            translate([-height/2,8.8,5]) rotate([0,90,0]) cylinder(d=bolt_hole_dia, h=height);
            translate([-height/2,-8.8,5]) rotate([0,90,0]) cylinder(d=bolt_hole_dia, h=height);
    
            // bolt head holes
            translate([-4,8.8,5]) rotate([0,-90,0]) cylinder(d=bolt_head_hole_dia, h=9);
            translate([-4,-8.8,5]) rotate([0,-90,0]) cylinder(d=bolt_head_hole_dia, h=9);
        
            // nut holes
            translate([4,8.8,5]) rotate([0,90,0]) nut(8);
            translate([4,-8.8,5]) rotate([0,90,0]) nut(8);
        
            translate([-1.5/2,-height/2,0]) cube([1.5, height, height/2]);
        }
    }
    clamp();
}

// Nut for tightening the flexible coupler. Screw over the flexible tube
module flexible_coupler_nut(hex=false) {
    d = 20;
    t_d = 13.2+0.7*4-0.2;
    difference() {
        if (hex == false) {
            cylinder(d=d, h=8);
        } else {
            cylinder(d=d+1, h=8, $fn=6);
        }
        _threads(d=t_d, h=11, z_step=2, depth=0.7, direction=0);

        if (hex == false) {
            for (i = [0:3]) {
                translate([0,0,i*2+1]) cube_donut(d+6.5, 5);
            }
            steps = round(PI*d/2);
            step_angle = 360/steps;
            for(i = [0:steps-1]) {
                rotate([0,0,i*step_angle]) translate([d/2,0,0]) rotate([0,0,45]) cube([0.5,0.5, 30], center=true);
            }
        }
    }
}


//rigid_leadscrew_coupler();
//flexible_coupler_clamp();
//motor_shaft_adapter();
//flexible_coupler_tube();
flexible_coupler_nut(hex=true);