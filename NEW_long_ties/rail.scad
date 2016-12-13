
include <globals.scad>;
include <include.scad>;

length=130;
width=20;

nozzle=0.6;
spring_width=1*nozzle+0.05;

module wiggly(d, h, wiggles) {
    z_step = h/wiggles;
    
    for (i = [0:wiggles]) {
        translate([0,0,i*z_step]) linear_extrude(height=z_step, center=true, convexity = 10, twist = 360, $fn = 30) translate([0.2, 0, 0]) circle(d=d-0.4);
    }
}

module hexagon(inner_diameter, height) {
    $fn=6;
    dia = sqrt(((inner_diameter/2)*(inner_diameter/2))/0.75) * 2;
    echo (dia);
    cylinder(d=dia, h=height);
}

module _rail(length, width) {
    rotate([-90,0,0]) hexagon(width, length);
}

module rail(length, width, hollow=true) {
    if (hollow) {
        difference() {
            _rail(length, width);
            translate([0,length/2,0]) rotate([0,45,0]) cube([width/2, length, width/2], center=true);
        }
    } else {
        _rail(length, width);
    }
}


module slide(height=10, wiggles) {
    
    module long_cube() {
        hull() {
            rotate([45,0,0]) cube([10,1.5,1.5], center=true);
            translate([0,2,0]) rotate([45,0,0]) cube([10,1.5,1.5], center=true);
        }
    }
    
    module spring(wiggles) {
        $fn=60;
        z_step = height/(wiggles);
        intersection() {
            difference() {
                //wiggly(d=11, h=height, wiggles=wiggles);
                //wiggly(d=11-2*spring_width, h=height, wiggles=wiggles);
                cylinder(d=11, h=height);
                cylinder(d=11-2*spring_width, h=height, wiggles=wiggles);
                for (i=[1:wiggles]) {
                    translate([-7.8,-4.5,i*z_step-1.5]) rotate([0,0,25]) long_cube();
                }
            }
            translate([-13,2,height/2]) rotate([0,0,-65]) cube([20,20,height], center=true);
        }
    }

    rotate([90,0,0]) difference() {
        _rail(height, width*1.55);
        _rail(height+1, width*1.25);
    }
    for (i = [1:6]) {
        angle = 360/6*i;
        rotate([0,0,angle]) translate([0,15.5,0]) rotate([0,0,65]) spring(wiggles);
    }
}

module rail_finished() {
    translate([0,-length/2,width/2]) rail(length,width);
    translate([-25,-length/2,0]) cube([width/2-slop, length/2,width/2-slop]);
}

rail_finished();
//translate([32,0,0]) rotate([90,0,0]) rail(length,width);
//translate([35,0,0]) slide(15, 5);



