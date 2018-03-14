
include <include.scad>;
use <rail.scad>;

$fn = 50;

// keep this low until rendering final models
steps = 100;

z_step = 3;

screw_d = 25;

thread_length = PI*screw_d;
rise_angle = asin(z_step/thread_length);
echo("Rise angle:", rise_angle);

function cube_w(z_step) = sqrt((z_step*z_step)/2);


module _thread_slice(d, h, angle=360, rotation=45) {
    cube_donut(d, h, angle=angle, rotation=rotation, $fn=20);
}

module _screw_thread(cube_side=4, resolution=steps, thread_d=20, rise_angle=1, r=1,rounds=1) {
    angle_step = 360 / steps;
    z_step = r / steps;
    _rounds = rounds * resolution -1;
    for (i=[0:_rounds]) {
        rotate([0,0,i*angle_step]) translate([0,0,z_step*i]) rotate([rise_angle,0,0]) _thread_slice(thread_d, cube_side, angle_step*2);
    }
}

module _screw(h=1, screw_d=20, z_step=4, direction=0) {
    height = h*z_step;

    difference() {
        cylinder(d=screw_d, h=height);
        if (direction == 0) {
            translate([0,0,-z_step/2]) _screw_thread(cube_w(z_step), thread_d=screw_d, rise_angle=rise_angle,r=z_step, rounds=h+1);
        } else {
            mirror([1,0,0]) translate([0,0,-z_step/2]) _screw_thread(cube_w(z_step), thread_d=screw_d, rise_angle=rise_angle,r=z_step, rounds=h+1);
        }
    }
}

module z_screw(h=5) {
    w = screw_d/2;
    l = h*z_step;
    difference() {
        _screw(h=h, screw_d=screw_d, z_step=z_step);
        rotate([90,0,0]) rail_center(width=w, length=l);
        translate([0,0,l]) rotate([90,0,0]) rail_center(width=w, length=l);
    }
}

side_screw_d = 10;
side_screw_steps = 5;
side_screw_height = side_screw_steps * z_step;
side_screws = 3;
side_screw_angle = 360/side_screws;
side_screw_offset = screw_d/2+side_screw_d/2;
side_screw_axle_d = 6;
module side_screw() {
    // x deviation per z_step
    x_step = sin(rise_angle) * z_step;
    echo("X step:", x_step);
    
    y_angle = asin((x_step)/(screw_d/2));
    echo(y_angle);
    
    screw_r = screw_d/2;
    total_r = screw_r + side_screw_d/2 - z_step/2;
    
    function y_step(step) = total_r/cos(asin((x_step*step)/total_r)) - total_r;
    echo(y_step(3));
    
    steps = [2,1,0,1,2];
    
    difference() {
        for (i = [0:5]) {
            hull() translate([0,0,i*z_step+z_step/2]) cube_donut(10+2*y_step(steps[i]), cube_w(z_step), angle=360, rotation=45, $fn=100);
            echo(2*y_step(steps[i]));
        }
        cylinder(d=side_screw_axle_d, h=6*z_step+1, $fn=60);
    }
}

screw_housing_height = side_screw_height + 10;
screw_housing_thread_d = 7;
screw_housing_bolt_d = screw_housing_thread_d-4*slop;

module _screw_housing() {
    difference() {
        cylinder(d=screw_d+22, h=screw_housing_height/2);
        cylinder(d=screw_d+1, h=screw_housing_height/2+1);
        for(i = [0:side_screws-1]) {
            rotate([0,0,i*side_screw_angle]) translate([side_screw_offset,0,1]) rotate([rise_angle,0,0]) {
                translate([0,0,3]) cylinder(d=side_screw_d+z_step+1,h=7*z_step);
                cylinder(d1=side_screw_axle_d-1,d2=side_screw_axle_d,h=3);
            }
        }
    }
    %translate([side_screw_offset,0,5]) rotate([rise_angle,0,0]) side_screw();
    //%z_screw(6);
}

module screw_housing_bottom() {
    
    difference() {
        _screw_housing();
        for(i = [0:side_screws-1]) {
            rotate([0,0,i*side_screw_angle+45]) translate([side_screw_offset,0,screw_housing_height/2-3]) cylinder(d1=4,d2=5, h=3);
            rotate([0,0,i*side_screw_angle-45]) translate([side_screw_offset+1,0,1]) _threads(d=screw_housing_thread_d, h=screw_housing_height, z_step=1.8, depth=0.5, direction=0);
        }
    }
}

module screw_housing_top() {
    
    difference() {
        _screw_housing();
        for(i = [0:side_screws-1]) {
            rotate([0,0,i*side_screw_angle+45]) translate([side_screw_offset+1,0,-0.1]) {
                cylinder(d=screw_housing_thread_d,h=screw_housing_height);
                cylinder(d1=screw_housing_thread_d+3,d2=screw_housing_thread_d, h=2);
            }
        }
    }
    for(i = [0:side_screws-1]) {
        rotate([0,0,i*side_screw_angle-45]) translate([side_screw_offset,0,screw_housing_height/2]) cylinder(d1=5-slop,d2=4-slop, h=3);
    }

}

module screw_housing_bolt() {
    union() {
        difference () {
            cylinder(d1=screw_housing_thread_d+3-slop,d2=screw_housing_thread_d-2*slop, h=2);
            cube([2,screw_housing_thread_d+4,3], center=true);
        }
        translate([0,0,2]) cylinder(d=screw_housing_thread_d-2*slop, h=screw_housing_height/2-3);
        translate([0,0,screw_housing_height/2-1]) _threads(d=screw_housing_bolt_d, h=screw_housing_height/2-2, z_step=1.8, depth=0.5, direction=0);
    }
    
}

module side_screw_axle() {
    $fn=100;
    d = side_screw_axle_d;
    h = screw_housing_height-8-slop;
    union() {
        cylinder(d1=d-slop-1,d2=d,h=3);
        translate([0,0,3]) cylinder(d=d,h=h);
        translate([0,0,h+3]) cylinder(d1=d,d2=d-slop-1,h=3);
    }
}

module side_screw_axle_bearing() {
    difference() {
        union() {
            cylinder(d=side_screw_d,h=1);
            //cylinder(d=side_screw_axle_d, h=screw_housing_height/2-1);
        }
        cylinder(d=side_screw_axle_d, h=screw_housing_height/2);
    }
}

// debug
module debug() {
    intersection() {
        union() {
            rotate([0,0,180]) z_screw(10);
            translate([side_screw_offset,0,z_step/2]) rotate([rise_angle,0,0]) side_screw();
        }
        translate([-1,-1,0]) cube([30,30,100]);
    }
}

//_thread_slice(20, 5, angle=360, rotation=45);

//debug();
//z_screw(10);
//side_screw();
//screw_housing_bottom();
screw_housing_top();
//translate([0,0,screw_housing_height]) rotate([180,0,-rise_angle]) screw_housing_top();
//screw_housing_bolt();
//side_screw_axle();
//side_screw_axle_bearing();