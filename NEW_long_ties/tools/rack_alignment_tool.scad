
include <include.scad>;
include <globals.scad>;
use <rack.scad>;

clip_bolt_dia = 10-2*slop;
clip_bolt_dia_minus = 10+2*slop;

length = 100;

rack_width = 36;

temp = sqrt((5*5)/2);
echo(temp);

module plate() {
    cube([length,40,5]);
    translate([0,40,0]) cube([length,5,5+rack_width/2]);
    translate([0,0,5]) intersection() {
        rotate([45,0,0]) translate([0,0,-4]) cube([length,4,4]);
        translate([0,0,0]) cube([length,20,10]);
    }
}

module plate1() {
    difference() {
        
        plate();
        translate([length/2,40+5/2,5+rack_width/2]) rotate([45,0,0]) cube([length,temp,temp], center=true);
        
        
        translate([10,23,0]) _threads(d=clip_bolt_dia_minus, h=10, z_step=1.8, depth=0.5, direction=0);
        translate([length-10,23,0]) _threads(d=clip_bolt_dia_minus, h=10, z_step=1.8, depth=0.5, direction=0);
    }
}

module plate2() {
    difference() {
        
        union() {
            plate();
            translate([length/2,40+5/2,5+rack_width/2]) rotate([45,0,0]) cube([length,temp,temp], center=true);
        }
           
        translate([10,23,0]) cylinder(d=clip_bolt_dia_minus+1, h=10);
        translate([length-10,23,0]) cylinder(d=clip_bolt_dia_minus+1, h=10);
    }
}

module bolt() {
    $fn=30;
    _bolt(d=clip_bolt_dia, h=rack_width+20, h2=20, shaft=rack_width+2, diameter=1, z_step=1.8, depth=0.5)
    _bolt();
}

module temp() {
    difference() {
        union() {
            cube([length, 5, 4]);
            translate([length/2,5/2,4]) rotate([45,0,0]) cube([length,temp,temp], center=true);
        }
        translate([length/2,5/2,0]) rotate([45,0,0]) cube([length,temp,temp], center=true);
    }
    
}

//translate([40,3,5+18.5]) %rotate([-90,0,0]) do_rack();
//plate1();
//plate2();
//translate([-length-5,0,0]) rotate([]) plate2();

//bolt();

temp();