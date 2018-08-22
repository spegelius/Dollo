include <../globals.scad>;
include <../include.scad>;
use <../z_screw.scad>;

length = 130; // should be enough
z_step = 3;
d = z_screw_d;//-0.5;

$fn=50;

module z_screw_jig() {

    translate([0,0,length/2]) rotate([90,0,0]) difference() {
        union() {
            translate([0,0,30/2]) cube([12,length,20], center=true);
            translate([0,length/2,30]) rotate([90,0,0]) cylinder(d=d+6, h=length);
            translate([0,0,40]) cube([22,length,15], center=true);
        }
        //translate([0,length/2+30/2, 30]) rotate([90,0,0]) cylinder(d=z_screw_d-0.5, h=length/2);
        translate([0,-length/2, 30]) rotate([-90,0,0]) cylinder(d=d-0.5, h=length);

        //translate([0,30/2, 30]) rotate([90,0,0]) render() _screw(h=30/z_step, screw_d=z_screw_d, z_step=z_step, steps=100);
        translate([0,0,20]) cube([1,length,19],center=true);
        translate([0,0,55]) rotate([45,0,0]) cube([d+8,40,40],center=true);
        
        translate([0,0,50]) cube([16,length,32],center=true);
        
    }


}

module jig_clip() {

    w = 20+2*4+2*slop;
    echo(w);

    rotate([90,0,0]) difference() {
        union() {
            translate([0,0,8/2]) rounded_cube(w,18,8,4, center=true);
            
            translate([-w/2,0,14/2]) rounded_cube(8,18,14,4, center=true);
            translate([w/2,0,14/2]) rounded_cube(8,18,14,4, center=true);
        }
        translate([w/2+15/2+1,0,0]) cylinder(d=15,h=15, $fn=50);
        translate([-w/2-15/2-1,0,0]) cylinder(d=15,h=15, $fn=50);
    }
}

//z_screw_jig();
jig_clip();