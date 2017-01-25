include <include.scad>;
include <globals.scad>;

height = 7;

frame_mockup();

module triangle(indent) {

    difference() {
        linear_extrude(height=height, convexity=2)
            polygon(points=[[0,0],[135,0],[0,135]]);
        if (indent) {
            translate([23,23,0]) linear_extrude(height=3, convexity=2)
                polygon(points=[[0,0],[125,0],[0,130]]);
        }
        translate([119,0,0]) cube([30,30,10]);
        translate([0,119,0]) cube([30,30,10]);
    }
        
}

module stabilizer(indent=true) {
    difference() {
        triangle(indent);
        translate([0,15,0]) #rotate([90,0,90]) male_dovetail(125);
        translate([15,0,0]) #rotate([90,0,180]) male_dovetail(125);
    }
}

//translate([-120,-120,-100]) rotate([0,-90,0]) stabilizer();
mirror([0,0,1]) stabilizer();