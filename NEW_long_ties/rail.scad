
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

module rail(length=length, width=width, hollow=true) {
    if (hollow) {
        difference() {
            _rail(length, width);
            rotate([0,135,0]) translate([0,slop,0]) rail_center(width/2+slop, length+1);
            rotate([0,135,0]) translate([0,length-slop,0]) rail_center(width/2+slop, length+1);
        }
    } else {
        _rail(length, width);
    }
}

module rail_center(width=width, length=length/2) {

    module side_notch() {
        intersection() {
            rotate([0,45,0]) cube([width/7,width/5,width/7],  center=true);
            rotate([0,0,45]) cube([width/6,width/6,width/5], center=true);
        }
    }

    union() {
        cube([width, length, width], center=true);
        translate([-width/2,0,0]) side_notch();
        translate([width/2,0,0]) side_notch();
        translate([width/2-width/12,0,width/2-width/12]) rotate([0,45,0]) cube([width/4,length,width/4], center=true);
    }
}

module rail_slide(width=width, height=10, wiggles=3) {
    
    module long_cube() {
        hull() {
            translate([0,-1.5/2,0]) rotate([45,0,0]) cube([10,1.5,1.5], center=true);
            translate([0,1.5/2,0]) rotate([45,0,0]) cube([10,1.5,1.5], center=true);
        }
    }
    
    spring_d = width*0.6;

    module spring(wiggles) {
        $fn=30;
        z_step = height/(wiggles);
        intersection() {
            difference() {
                //wiggly(d=11, h=height, wiggles=wiggles);
                //wiggly(d=11-2*spring_width, h=height, wiggles=wiggles);
                cylinder(d=spring_d, h=height);
                translate([0,0,-0.1]) cylinder(d=spring_d-2*spring_width, h=height+1, wiggles=wiggles);
                for (i=[1:wiggles]) {
                    translate([0,0,i*z_step-1.5]) rotate([0,0,45]) long_cube();
                }
            }
            translate([-width/2,-width/2+spring_d/4,height/2]) cube([width,width,height], center=true);
        }
    }
    // debug
    //translate([0,30,0]) spring(1);

    rotate([90,0,0]) difference() {
        _rail(height, width+spring_d*1);
        translate([0,-0.1,0]) _rail(height+1, width+spring_d-5);
    }
    for (i = [1:6]) {
        angle = 360/6*i;
        rotate([0,0,angle]) translate([0,width/2+spring_d/2-0.1,0]) rotate([0,0,45]) spring(wiggles);
    }
}



//rail_center();
translate([0,-length/2,width/2]) rail(length,width);
//rotate([90,0,0]) rail(20,15);
//rail_slide(15,10,3);



