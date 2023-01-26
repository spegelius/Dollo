
include <include.scad>;
use <rail.scad>;
use <mockups.scad>;
use <extention.scad>;
use <../snappy-reprap/publicDomainGearV1.1.scad>;

$fn = 50;

z_step = 3;

function cube_w(z_step) = sqrt((z_step*z_step)/2);

tooth_mm = 1.9;

thread_length = PI*z_screw_d;
rise_angle = asin(z_step/thread_length);


//test_motor_coupler();
//debug_screw_housing();
//debug_screw_center();
//debug_gears();
//debug_screw_roller();

// 120 mm screw
//z_screw(120, steps=100);

// 10 mm screw
//z_screw(10, steps=100);

//z_screw_center();
//z_screw_center_coupler();

//side_roller();
//screw_housing_bottom();
//screw_housing_top();
//side_roller_axle();
//side_roller_axle_washer();
//screw_housing_bolt();
//screw_housing_bolt_side();

//z_screw_motor_coupler(fast_render=true);
//z_screw_motor_coupler(fast_render=false);
//z_screw_motor_flex_coupler(fast_render=false);
//z_screw_motor_flex_coupler(fast_render=true);
//test_motor_coupler();


module _screw_gear(h=10) {
    
    length = PI*(z_screw_d-1.35);
    teeth = round(length/tooth_mm);
    echo(teeth);
    
    translate([0,0,h/2]) gear (
        mm_per_tooth    = tooth_mm,
        number_of_teeth = teeth,
        thickness       = h,
        hole_diameter   = 0,
        twist           = 0,
        teeth_to_hide   = 0,
        pressure_angle  = 30,
        backlash        = slop/2,
        $fn=20
    );
}

module _roller_gear(h=10) {
    
    length = PI*(side_roller_d+1.35);
    teeth = round(length/tooth_mm);
    echo(teeth);

    one_degree = length/360;
    
    twist = (tan(rise_angle) * h)/one_degree;
    echo("twist: ", twist);

    scale([0.97,0.97,1]) translate([0,0,h/2]) gear (
        mm_per_tooth    = tooth_mm,
        number_of_teeth = teeth,
        thickness       = h,
        hole_diameter   = 0,
        twist           = twist,
        teeth_to_hide   = 0,
        pressure_angle  = 30,
        backlash        = slop/2
    );
}

module z_screw(h=10, fast_render=false, steps=100) {
    w = z_screw_d/2;
    rounds = h/z_step;
    minus_rail_center(h, z_screw_d) {
        union() {
            for (i=[0:rounds-1]) {
                translate([0,0,i*z_step]) render() intersection() {
                    if (fast_render) {
                        cylinder(d=z_screw_d, h=z_step);
                    } else {
                        v_screw(h=z_step, screw_d=z_screw_d, pitch=z_step, steps=steps);
                    }
                    union() {
                        cylinder(d=z_screw_d-5, h=z_step);
                        if (!fast_render) {
                            _screw_gear(h=z_step);
                        }
                    }
                }
            }
        }
    }
}

side_roller_d = 10;
side_roller_steps = 5;
side_roller_height = side_roller_steps * z_step;
side_rollers = 3;
side_roller_angle = 360/side_rollers;
side_roller_offset = z_screw_d/2+side_roller_d/2;
side_roller_axle_d = 6;
module side_roller() {
    // x deviation per z_step
    x_step = sin(rise_angle) * z_step;
    echo("X step:", x_step);
    
    y_angle = asin((x_step)/(z_screw_d/2));
    echo(y_angle);
    
    screw_r = z_screw_d/2;
    total_r = screw_r + side_roller_d/2 - z_step/2;
    
    function y_step(step) = total_r/cos(asin((x_step*step)/total_r)) - total_r;
    echo(y_step(3));
    
    steps = [2,1,0,1,2];
    
    
    difference() {
        union() {
            for (i = [0:4]) {
                intersection() {
                    hull() translate([0,0,i*z_step+z_step/2]) cube_donut(10+2*y_step(steps[i]), cube_w(z_step), angle=360, rotation=45, $fn=100);
                    cylinder(d=z_step+side_roller_d+2*y_step(steps[i])-0.3,h=side_roller_height);
                }
                //echo(2*y_step(steps[i]));
            }
            translate([0,0,z_step/2]) _roller_gear(side_roller_height-z_step);
            cylinder(d=side_roller_d+0.3,h=side_roller_height,$fn=100);
        }
        cylinder(d=side_roller_axle_d+slop/2, h=6*z_step+1, $fn=60);
    }
}

screw_housing_height = side_roller_height + 2/3 * z_step + 9;
screw_housing_thread_d = 7;
screw_housing_bolt_d = screw_housing_thread_d-4*slop;
module _screw_housing(frame_width=22) {

    module screw_hole() {
        h = side_roller_height + 2.2 + 6;
        translate([0,0,-h/2]) union() {
            cylinder(d=side_roller_d+z_step+1, h=side_roller_height + 2.2);
            translate([0,0,-3]) rotate([0,0,-1]) _axle_end(side_roller_axle_d);
        }
    }

    _z_step = z_step/side_rollers;
    z = screw_housing_height/2;
    
    difference() {
        cylinder(d=z_screw_d+frame_width, h=screw_housing_height/2, $fn=100);
        cylinder(d=z_screw_d+1, h=screw_housing_height/2+1);
        for(i = [0:side_rollers-1]) {
            rotate([0,0,i*side_roller_angle]) translate([side_roller_offset,0,z]) rotate([rise_angle,0,0]) {
                translate([0,0,2+i*_z_step]) screw_hole();
            }
        }
    }
}

module screw_housing_bottom(frame_width=22, render_threads=true) {
    
    z = screw_housing_height/2;
    difference() {
        _screw_housing(frame_width=frame_width);
        for(i = [0:side_rollers-1]) {
            rotate([0,0,i*side_roller_angle+45]) translate([side_roller_offset,0,z-3]) cylinder(d1=4,d2=5, h=3);
            if (render_threads) {
                rotate([0,0,i*side_roller_angle-45]) translate([side_roller_offset+1,0,+1]) v_screw(screw_d=screw_housing_thread_d, h=screw_housing_height, pitch=1.8, direction=0, steps=30);
            } else {
                rotate([0,0,i*side_roller_angle-45]) translate([side_roller_offset+1,0,+1]) cylinder(d=screw_housing_thread_d, h=screw_housing_height);
            }
        }
        translate([(z_screw_d+frame_width)/2,0,0]) rotate([0,0,45]) cube([1,1,50]);
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
        rotate([0,0,-360/side_rollers]) translate([(z_screw_d+frame_width)/2,0,0]) rotate([0,0,45]) cube([1,1,50]);
    }
    for(i = [0:side_rollers-1]) {
        rotate([0,0,i*side_roller_angle-45]) translate([side_roller_offset,0,z]) cylinder(d1=5-slop,d2=4-slop, h=3);
    }
}

module screw_housing_bolt() {
    difference() {
        union() {
            difference () {
                cylinder(d1=screw_housing_thread_d+3-slop,d2=screw_housing_thread_d-2*slop, h=2);
                cube([1.5,screw_housing_thread_d+4,3], center=true);
            }
            translate([0,0,2]) cylinder(d=screw_housing_thread_d-2*slop, h=screw_housing_height/2-3);
            translate([0,0,screw_housing_height/2-1]) v_screw(screw_d=screw_housing_bolt_d, h=screw_housing_height/2-2, pitch=1.8, steps=40, direction=0);
        }
        cylinder(d=0.1,h=screw_housing_height);
    }
    
}

module screw_housing_bolt_side() {
    // printing sideways makes a stronger bolt
    module block() {
        difference() {
            translate([-4/2,0,0])
            cube([4,50,1.8]);

            rotate([-48,0,0])
            translate([-5/2,-2,-1])
            cube([5,2,4]);
        }
    }
    
    difference() {
        translate([0,0,(screw_housing_thread_d+2)/2])
        intersection() {
            rotate([-90,0,0])
            screw_housing_bolt();

            cube([13,50,screw_housing_thread_d+2], center=true);
        }
        block();

        translate([0,0,9.01])
        rotate([0,180,0]) block();
    }
    // support
    translate([-4/2,2.1,0])
    cube([4,21,1.6]);

    // brim
    translate([0,1,0.2/2])
    cube([6,4,0.2],center=true);

    translate([0,0.6/2,0.6/2])
    cube([6,0.6,0.6],center=true);

}

module _axle_end(d) {
    cube_d = sqrt((d*d)/2);
    hull() {
        translate([0,0,1/2]) cube([cube_d,cube_d,1],center=true);
        translate([0,0,3]) cylinder(d=d,h=1);
    }
}

module side_roller_axle() {
    $fn=100;
    d = side_roller_axle_d - 0.05;
    h = side_roller_height + 2;
    union() {
        _axle_end(d);
        translate([0,0,3]) cylinder(d=d,h=h);
        translate([0,0,3+h+3]) rotate([0,180,0]) _axle_end(d);
    }
}

module side_roller_axle_washer() {
    difference() {
        union() {
            cylinder(d=side_roller_d,h=1);
        }
        cylinder(d=side_roller_axle_d, h=screw_housing_height/2);
    }
}

z_screw_center_w = z_screw_d/2 * 0.98;
module z_screw_center(height=120) {
    rail_center(width=z_screw_center_w, length=height);
}

module z_screw_center_coupler() {
    difference() {
        intersection() {
            // 54 = coupler screw length
            translate([0,0,53-60]) z_screw_center();
            cylinder(d=30,h=54+60+5);
        }
        translate([0,0,-2]) pyramid(z_screw_d/2);
    }
}

coupler_steps = 18;
coupler_h = coupler_steps * z_step;
coupler_w = z_screw_d/2;

module _coupler_screw(fast_render=false) {
    union() {
        intersection() {
            translate([0,0,-2*coupler_h]) z_screw(coupler_h*3, fast_render=fast_render);
            cylinder(d=z_screw_d, h=coupler_h);
        }
        translate([0,0,-slop]) pyramid(z_screw_center_w, cap=1.5);
    }
}

module z_screw_motor_coupler(fast_render=false) {

    bolt_d = bolt_hole_dia-0.15;
    difference() {
        union() {
            cylinder(d1=motor_center_hole-1, d2=z_screw_d-0.5, h=4, $fn=50);
            translate([0,0,4]) cylinder(d=z_screw_d-0.5, h=31-4, $fn=50);
            translate([0,0,31]) _coupler_screw(fast_render);
        }
        translate([0,0,-3]) motor_shaft(h=34, extra_slop=slop);
        translate([0,0,8]) rotate([-90,0,0]) cylinder(d=bolt_d,h=20);
        translate([0,8.5,8]) rotate([-90,0,0]) cylinder(d1=bolt_d, d2=8,h=5);
        
        hull() {
            translate([-m3_nut_side/2,4.5,0]) cube([m3_nut_side,m3_nut_height+slop,1]);
            translate([0,4.5,8]) rotate([-90,30,0]) M3_nut(m3_nut_height+slop,cone=false);
        }
    }
}

module z_screw_motor_flex_coupler(fast_render=false) {
    difference() {
        union() {
            ridged_cylinder(d=10, h=12.5, r=3);
            translate([0,0,12.5]) cylinder(d1=15, d2=z_screw_d-1,h=2.5);
            translate([0,0,15]) cylinder(d=z_screw_d-4,h=1.5);
            translate([0,0,15]) _coupler_screw(fast_render);
        }
        cylinder(d=6, h=5);
    }
}


module test_motor_coupler() {
    intersection() {
        z_screw_motor_coupler(fast_render=false);
        cube([40,40,26], center=true);
    }
}

// debug
module debug_screw_housing() {
    z = screw_housing_height/2;
    intersection() {
        union() {
            //rotate([0,0,180]) z_screw(8);
            screw_housing_bottom();
            translate([0,0,screw_housing_height]) rotate([180,0,-1/3*360]) screw_housing_top();
            translate([side_roller_offset,0,z]) rotate([rise_angle,0,0]) translate([0,0,-side_roller_height/2-1]) side_roller();
            rotate([0,0,side_roller_angle]) translate([side_roller_offset,0,z]) rotate([rise_angle,0,0]) translate([0,0,-side_roller_height/2]) side_roller();
            rotate([0,0,side_roller_angle*2]) translate([side_roller_offset,0,z]) rotate([rise_angle,0,0]) translate([0,0,-side_roller_height/2+1]) side_roller();
            
            color("black") {
                translate([side_roller_offset,0,z]) rotate([rise_angle,0,0]) translate([0,0,-side_roller_height/2-2]) side_roller_axle_washer();
                translate([side_roller_offset,0,z]) rotate([rise_angle,0,0]) translate([0,0,side_roller_height/2-1]) side_roller_axle_washer();
            }
            
            translate([side_roller_offset,0,z]) rotate([rise_angle,0,0]) translate([0,0,-(side_roller_height+8-slop)/2-1.1])  side_roller_axle();

        }
        translate([-1,-1,-50]) cube([30,30,100]);
        //rotate([0,0,1/3*360]) translate([-1,-1,-50]) cube([30,30,100]);
        //rotate([0,0,2/3*360]) translate([-1,-1,-50]) cube([30,30,100]);
    }
    
}

module debug_screw_center() {
    intersection() {
        union() {
            //z_screw_motor_coupler(fast_render=true);
            translate([0,0,16]) z_screw_motor_flex_coupler(fast_render=false);
            translate([0,0,85]) z_screw(120, fast_render=true);
            translate([0,0,85+120]) z_screw(120, fast_render=true);
            translate([0,0,85+120*2]) z_screw(120, fast_render=true);

            translate([0,0,33]) z_screw_center_coupler();
            translate([0,0,86+120/2]) z_screw_center();
            translate([0,0,86+120/2+120]) z_screw_center();
        }
        translate([-25,0,0]) cube([50,50,1200]);
    }
}

module debug_gears() {
    //cylinder(d=z_screw_d, h=7);
    rotate([0,0,4.4]) _screw_gear();
    translate([side_roller_offset,0,0]) rotate([rise_angle,0,0]) _roller_gear();
}

module debug_screw_roller() {
    intersection() {
        union() {
            z_screw(10, steps=100);
            translate([side_roller_offset,0,-z_step/2]) rotate([rise_angle,0,0]) rotate([0,0,9]) side_roller();
        }
        translate([0,0,-5]) cube([100,100,27.5]);
    }
}


