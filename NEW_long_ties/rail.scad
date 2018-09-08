
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

module _rail(length, width) {
    rotate([0,0,0]) hexagon(width, length);
}

module minus_rail_center(length, width) {
    difference() {
        children();
        translate([0,0,-(length+slop)/2+slop]) _rail_center(width/2+slop, length+slop);
        translate([0,0,length/2-slop]) _rail_center(width/2+slop, length+slop);
    }
}

module rail(width=width, length=length, hollow=true) {
    
    if (hollow) {
        minus_rail_center(length, width) _rail(length, width);
    } else {
        _rail(length, width);
    }
}

module _rail_center(width, length) {
    
    module side_notch() {
        intersection() {
            rotate([0,0,45]) cube([width/7,width/7,width/5], center=true);
            rotate([0,45,0]) cube([width/6,width/6,width/6], center=true);
        }
    }
    
    module side_rail() {
        rotate([0,0,45]) cube([width/4,width/4,l], center=true);
    }

    l = length + width/2 - 2;

    translate([0,0,width/4+length/2]) intersection() {
        difference() {
            union() {
                cube([width, width, l], center=true);
                translate([-width/2,0,-width/4]) side_notch();
                translate([width/2,0,-width/4]) side_notch();
                translate([width/2-width/12,width/2-width/12,0]) side_rail();
                translate([-width/2+width/12,-width/2+width/12,0]) side_rail();
            }
            translate([0,0,-l/2-2+slop]) pyramid(width,cap=0);
        }
        translate([0,0,-l/2-slop]) pyramid(l*2, cap=0);
    }
}

module rail_center(width=width, length=length/2) {
    translate([0,0,-1]) intersection() {
        _rail_center(width, length);
        translate([0,0,length/2+width/4-width/10]) difference() {
            cube([width*1.2,width*1.2,length+width/2-2], center=true);
            cylinder(d=0.5,h=length+width/2,center=true);
        }
    }
}

module rail_slide(width=width, height=10, wiggles=3, slop=0) {
    
    module long_cube() {
        hull() {
            translate([0,-1/2,0]) rotate([45,0,0]) cube([10,1.5,1.5], center=true);
            translate([0,1/2,0]) rotate([45,0,0]) cube([10,1.5,1.5], center=true);
        }
    }
    
    spring_d = width*0.6;

    module spring(wiggles) {
        $fn=40;
        z_step = (height-1)/(wiggles-1);
        pos = spring_d/2-3/2+0.1;
        intersection() {
            difference() {
                union() {
                    cylinder(d=spring_d-spring_width, h=height);
                    if (wiggles > 1) {
                        for (i=[0:wiggles-1]) {
                            translate([0,pos,i*z_step+0.5]) hull() {
                                translate([0,0,-0.75]) sphere(d=3);
                                translate([0,0,0.75]) sphere(d=3);
                            }
                        }
                    } else if (wiggles == 1) {
                        translate([0,0,height/2]) hull() {
                                translate([0,0,-0.75]) sphere(d=3);
                                translate([0,0,0.75]) sphere(d=3);
                        }
                    }
                }
                translate([0,0,-0.1]) cylinder(d=spring_d-3*spring_width, h=height+1);
            }
            translate([spring_d/2-1,3,height/2]) cube([spring_d,spring_d/2,height], center=true);
        }
    }
    // debug
    //translate([0,30,0]) spring(1);

    difference() {
        _rail(height, width+spring_d);
        translate([0,0,-0.1]) _rail(height+1, width+spring_d-5);
    }
    for (i = [1:6]) {
        angle = 360/6*i;
        rotate([0,0,angle]) translate([0,-width/2-spring_d/2-slop,0]) spring(wiggles);
    }
}


module debug_rail() {
    intersection() {
        union() {
            rail(50,25);
            translate([0,0,50]) rail(50,25);
            translate([0,0,-25]) rail_center(12.5,50);
            translate([0,0,-25+50]) rail_center(12.5,50);
            translate([0,0,-25+100]) rail_center(12.5,50);
        }
        translate([0,10,0]) cube([20,20,520], center=true);
    }
}

module rail_test_parts() {
    rail(15, 40);
    translate([0,20,0]) rail(15, 40);
    translate([20,0,0]) rail_center(15/2, 40);
    translate([20,20,0]) rail_center(15/2, 40);
}

//debug_rail();

//rail_test_parts();

rail_center();
//translate([0,-length/2,width/2]) rail(length,width);
//rail(length=20,width=15);
//rail_slide(width=15,height=10,wiggles=3);



