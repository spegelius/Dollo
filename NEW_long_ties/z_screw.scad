
include <include.scad>;
use <rail.scad>;
use <mockups.scad>;
use <extention.scad>;

$fn = 50;

// keep this low until rendering final models
steps = 10;

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

module z_screw(h=5, fast_render=false) {
    w = screw_d/2;
    l = h*z_step;
    difference() {
        if (fast_render) {
            cylinder(d=screw_d, h=l);
        } else {
            _screw(h=h, screw_d=screw_d, z_step=z_step);
        }
        rotate([90,0,0]) rail_center(width=w, length=l);
        translate([0,0,l]) rotate([90,0,0]) rail_center(width=w, length=l);
    }
}

side_roller_d = 10;
side_roller_steps = 5;
side_roller_height = side_roller_steps * z_step;
side_rollers = 3;
side_roller_angle = 360/side_rollers;
side_roller_offset = screw_d/2+side_roller_d/2;
side_roller_axle_d = 6;
module side_roller() {
    // x deviation per z_step
    x_step = sin(rise_angle) * z_step;
    echo("X step:", x_step);
    
    y_angle = asin((x_step)/(screw_d/2));
    echo(y_angle);
    
    screw_r = screw_d/2;
    total_r = screw_r + side_roller_d/2 - z_step/2;
    
    function y_step(step) = total_r/cos(asin((x_step*step)/total_r)) - total_r;
    echo(y_step(3));
    
    steps = [2,1,0,1,2];
    
    difference() {
        for (i = [0:5]) {
            hull() translate([0,0,i*z_step+z_step/2]) cube_donut(10+2*y_step(steps[i]), cube_w(z_step), angle=360, rotation=45, $fn=100);
            //echo(2*y_step(steps[i]));
        }
        cylinder(d=side_roller_axle_d, h=6*z_step+1, $fn=60);
    }
}

screw_housing_height = side_roller_height + 2/3 * z_step + 9;
screw_housing_thread_d = 7;
screw_housing_bolt_d = screw_housing_thread_d-4*slop;
module _screw_housing(frame_width=22) {

    module screw_hole() {
        h = side_roller_height + 2 + 6;
        translate([0,0,-h/2]) union() {
            cylinder(d=side_roller_d+z_step+1, h=side_roller_height + 2);
            translate([0,0,-3]) cylinder(d1=side_roller_axle_d-1,d2=side_roller_axle_d,h=3);
        }
    }

    _z_step = z_step/side_rollers;
    z = screw_housing_height/2;
    
    difference() {
        cylinder(d=screw_d+frame_width, h=screw_housing_height/2, $fn=100);
        cylinder(d=screw_d+1, h=screw_housing_height/2+1);
        for(i = [0:side_rollers-1]) {
            rotate([0,0,i*side_roller_angle]) translate([side_roller_offset,0,z]) rotate([rise_angle,0,0]) {
                translate([0,0,2+i*_z_step]) screw_hole();
            }
        }
        translate([(screw_d+frame_width)/2,0,0]) rotate([0,0,45]) cube([1,1,50]);
    }
}

module screw_housing_bottom(frame_width=22, render_threads=true) {
    
    z = screw_housing_height/2;
    difference() {
        _screw_housing(frame_width=frame_width);
        for(i = [0:side_rollers-1]) {
            rotate([0,0,i*side_roller_angle+45]) translate([side_roller_offset,0,z-3]) cylinder(d1=4,d2=5, h=3);
            if (render_threads) {
                rotate([0,0,i*side_roller_angle-45]) translate([side_roller_offset+1,0,+1]) _threads(d=screw_housing_thread_d, h=screw_housing_height, z_step=1.8, depth=0.5, direction=0);
            } else {
                rotate([0,0,i*side_roller_angle-45]) translate([side_roller_offset+1,0,+1]) cylinder(d=screw_housing_thread_d, h=screw_housing_height);
            }
        }
    }
}

module screw_housing_top(frame_width=22) {
   
    z = screw_housing_height/2;
    difference() {
        _screw_housing(frame_width=frame_width);
        for(i = [0:side_rollers-1]) {
            rotate([0,0,i*side_roller_angle+45]) translate([side_roller_offset+1,0,-0.1]) {
                cylinder(d=screw_housing_thread_d,h=screw_housing_height);
                cylinder(d1=screw_housing_thread_d+3,d2=screw_housing_thread_d, h=2);
            }
        }
    }
    for(i = [0:side_rollers-1]) {
        rotate([0,0,i*side_roller_angle-45]) translate([side_roller_offset,0,z]) cylinder(d1=5-slop,d2=4-slop, h=3);
    }
}

module screw_housing_bolt() {
    union() {
        difference () {
            cylinder(d1=screw_housing_thread_d+3-slop,d2=screw_housing_thread_d-2*slop, h=2);
            cube([1.5,screw_housing_thread_d+4,3], center=true);
        }
        translate([0,0,2]) cylinder(d=screw_housing_thread_d-2*slop, h=screw_housing_height/2-3);
        translate([0,0,screw_housing_height/2-1]) _threads(d=screw_housing_bolt_d, h=screw_housing_height/2-2, z_step=1.8, depth=0.5, direction=0);
    }
    
}

module screw_housing_bolt_side() {
    
    module block() {
        difference() {
            translate([-4/2,0,0]) cube([4,50,1.8]);
            rotate([-48,0,0]) translate([-5/2,-2,-1]) cube([5,2,4]);
        }
    }
    
    difference() {
        translate([0,0,(screw_housing_thread_d+2)/2]) intersection() {
            rotate([-90,0,0]) screw_housing_bolt();
            cube([13,50,screw_housing_thread_d+2], center=true);
        }
        block();
        translate([0,0,9.01]) rotate([0,180,0]) block();
    }
    translate([-4/2,2.1,0]) cube([4,21,1.6]);
}

module side_roller_axle() {
    $fn=100;
    d = side_roller_axle_d - 0.05;
    h = side_roller_height + 2 - slop;
    union() {
        cylinder(d1=d-slop-1,d2=d,h=3);
        translate([0,0,3]) cylinder(d=d,h=h);
        translate([0,0,h+3]) cylinder(d1=d,d2=d-slop-1,h=3);
    }
}

module side_roller_axle_bearing() {
    difference() {
        union() {
            cylinder(d=side_roller_d,h=1);
            //cylinder(d=side_roller_axle_d, h=screw_housing_height/2-1);
        }
        cylinder(d=side_roller_axle_d, h=screw_housing_height/2);
    }
}

module z_screw_center() {
    w = screw_d/2;
    scale([0.97,1,0.97]) rail_center(width=w, length=60);
}

module z_screw_motor_coupler(fast_render=false) {
    h=18;
    l = h * z_step;
    echo(l);
    w = screw_d/2;
    bolt_d = bolt_hole_dia-0.15;
    difference() {
        union() {
            cylinder(d=screw_d, h=31, $fn=50);
            translate([0,0,31]) z_screw(h, fast_render=fast_render);
        }
        translate([0,0,-4]) motor_shaft(22, extra_slop=0.1);
        translate([0,0,8]) rotate([-90,0,0]) cylinder(d=bolt_d,h=20);
        translate([0,8.5,8]) rotate([-90,0,0]) cylinder(d1=bolt_d, d2=8,h=5);
        
        hull() {
            translate([-m3_nut_side/2,4.5,0]) cube([m3_nut_side,m3_nut_height+slop,1]);
            translate([0,4.5,8]) rotate([-90,30,0]) nut(m3_nut_height+slop,cone=false);
        }
    }
}

module z_screw_motor_mount() {
    motor_plate(5, bolt_head_cones=true);
    %translate([0,42/2,-40/2]) rotate([90,0,0]) mock_stepper_motor();
    %translate([-30-screw_d/2-1,-30,5]) extention();
}

module test_motor_coupler() {
    intersection() {
        z_screw_motor_coupler(fast_render=false);
        cube([40,40,26], center=true);
    }
}

// debug
module debug() {
    z = screw_housing_height/2;
    intersection() {
        union() {
            //rotate([0,0,180]) z_screw(8);
            screw_housing_bottom();
            translate([0,0,screw_housing_height]) rotate([180,0,-1/3*360]) screw_housing_top();
            translate([side_roller_offset,0,z]) rotate([rise_angle,0,0]) translate([0,0,-side_roller_height/2-1]) side_roller();
            rotate([0,0,side_roller_angle]) translate([side_roller_offset,0,z]) rotate([rise_angle,0,0]) translate([0,0,-side_roller_height/2]) side_roller();
            rotate([0,0,side_roller_angle*2]) translate([side_roller_offset,0,z]) rotate([rise_angle,0,0]) translate([0,0,-side_roller_height/2+1]) side_roller();
            
            translate([side_roller_offset,0,z]) rotate([rise_angle,0,0]) translate([0,0,-side_roller_height/2-2]) side_roller_axle_bearing();
            translate([side_roller_offset,0,z]) rotate([rise_angle,0,0]) translate([0,0,side_roller_height/2-1]) side_roller_axle_bearing();
            
            translate([side_roller_offset,0,z]) rotate([rise_angle,0,0]) translate([0,0,-(side_roller_height+8-slop)/2-1]) scale([0.9,0.9,1])  side_roller_axle();

        }
        //translate([-1,-1,-50]) cube([30,30,100]);
        //rotate([0,0,1/3*360]) translate([-1,-1,-50]) cube([30,30,100]);
        //rotate([0,0,2/3*360]) translate([-1,-1,-50]) cube([30,30,100]);
    }
    
}

//_thread_slice(20, 5, angle=360, rotation=45);

//debug();
//z_screw(40);
//z_screw_center();
//side_roller();
//screw_housing_bottom();
//screw_housing_top();
//side_roller_axle();
//side_roller_axle_bearing();
//screw_housing_bolt();
//screw_housing_bolt_side();

//z_screw_motor_coupler(fast_render=true);
z_screw_motor_mount();

//test_motor_coupler();