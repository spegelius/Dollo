
use <../cable_chain.scad>;

module links() {
    translate([0,-8,14])
    rotate([0,180,0]) {
        cable_chain_link(brim=false);

        translate([0,16.1,0])
        cable_chain_link(brim=false);
    }
    %translate([25/2,0.65,7.5])
    rotate([0,90,0])
    cylinder(d=3,h=20,center=true,$fn=20);
}

module jig(hole=3) {

    %translate([0,0,5])
    links();

    difference() {
        union() {
            difference() {
                translate([0,0,19/2])
                cube([35,50,19],center=true);

                translate([0,0,20/2+5])
                cube([25.2,51,20],center=true);
            }
            translate([0,0,19/2])
            cube([12.6,9.6,19],center=true);

            translate([0,4.6/2+11.2,8/2])
            cube([18.6,4.6,8],center=true);

            translate([0,-4.6/2-11.2,8/2])
            cube([12.6,4.6,8],center=true);

            translate([25/2-2/2,-4.6/2-11.2,12/2])
            cube([3,4.6,12],center=true);

            translate([-25/2+2/2,-4.6/2-11.2,12/2])
            cube([3,4.6,12],center=true);

            translate([35/2-0.1,0.65,7.5+5])
            rotate([0,90,0])
            cylinder(d=10,h=15);

            translate([35/2+15/2-0.1,0.65,9/2])
            cube([15,5,9],center=true);

            translate([-35/2+0.1,0.65,7.5+5])
            rotate([0,-90,0])
            cylinder(d=10,h=15);

            translate([-35/2-15/2+0.1,0.65,9/2])
            cube([15,5,9],center=true);
        }

        translate([0,0.65,7.5+5])
        rotate([0,90,0])
        cylinder(d=hole,h=150,center=true,$fn=20);
    }
}

module nubs() {
    translate([-6,0,0])
    cylinder(d=3.9, h=6,$fn=30);

    translate([0,0,0])
    cylinder(d=3.9, h=6,$fn=30);

    translate([6,0,0])
    cylinder(d=3.9, h=6,$fn=30);

    translate([-6,6,0])
    cylinder(d=3.9, h=6,$fn=30);

    translate([0,6,0])
    cylinder(d=3.9, h=6,$fn=30);

    translate([6,6,0])
    cylinder(d=3.9, h=6,$fn=30);

    translate([-6,12,0])
    cylinder(d=3.9, h=6,$fn=30);

    translate([0,12,0])
    cylinder(d=3.9, h=6,$fn=30);

    translate([6,12,0])
    cylinder(d=3.9, h=6,$fn=30);

    translate([0,0,0.2/2])
    cube([18,2,0.2],center=true);

    translate([0,6,0.2/2])
    cube([18,2,0.2],center=true);

    translate([0,12,0.2/2])
    cube([18,2,0.2],center=true);
}

//links();

//jig();
//jig(4);
nubs();
