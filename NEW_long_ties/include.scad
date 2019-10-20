include <globals.scad>;

//////////////////      END SECTION       //////////////////

	module added_pins(){
		difference(){
			union(){
				translate([30/(15/4),obj_leg*leg_length,30/(15/4)]) pin();
				translate([30/(15/4)+14.5,obj_leg*leg_length,30/(15/4)+14]) pin();
			}
			union(){
							translate([30/(15/4)+13.5,obj_leg*leg_length-20,30/(15/4)+5])cube(size=[2,40,15]);
							translate([30/(15/4)+7.5,obj_leg*leg_length-20,30/(15/4)+15])rotate([0,90,0]) cube(size=[2,40,15]);	

							translate([30/(15/4)-1,obj_leg*leg_length-20,30/(15/4)-8])cube(size=[2,40,15]);
							translate([30/(15/4)-10,obj_leg*leg_length-20,30/(15/4)+1])rotate([0,90,0]) cube(size=[2,40,15]);
			}
		}
	}
	module taken_pins() {
		translate([30/(15/4)+14,obj_leg*leg_length-10,30/(15/4)]) mirror_pin();
		translate([30/(15/4),obj_leg*leg_length-10,30/(15/4)+15]) mirror_pin();
	}

//////////////////      OTHER STUFF       //////////////////

	module holes() {
		rotate([0,0,90]) for(y=[0:other_holes])
		translate([obj_leg+y*15,-15.5,7.5]) union() {
			translate([7.5,0,15]) hole_up();
			hole_down();
		}
	}
	module extend_holes() {
	module top(){
		rotate([0,0,90]) for(y=[0:other_holes+1])
		translate([(30/4)+y*15,-15.5,7.5]) union() {
			translate([7.5,0,15]) hole_up();
		}
	}
	module bottom(){
		rotate([0,0,90]) for(y=[0:other_holes+2])
		translate([(30/4)+y*15,-15.5,7.5]) union() {
			hole_down();
		
}
	}
	union(){
		top();
		bottom();
	}
	}

	module hole() {
		union() {
			rotate([90, 90, 0]) cylinder(h=40, d=hole_pin_diameter, center=true);
			translate([0,7.5,0]) sphere(d=hole_ball_size);
			translate([0,-6,0]) sphere(d=hole_ball_size);
		}
	}
	module hole_up() {
		union() {
			rotate([90, 90, 0]) cylinder(h=40, d=hole_pin_diameter, center=true);
			translate([0,7.5,10]) cylinder(h=hole_pin_height, d=hole_pin_diameter, center=true);
			translate([0,-6,10]) cylinder(h=hole_pin_height, d=hole_pin_diameter, center=true);
			translate([0,7.5,0]) sphere(d=hole_ball_size);
			translate([0,-6,0]) sphere(d=hole_ball_size);
		}
	}
	module hole_down() {
		union() {
			rotate([90, 90, 0]) cylinder(h=40, d=hole_pin_diameter, center=true);
			translate([0,7.5,-10]) cylinder(h=hole_pin_height, d=hole_pin_diameter, center=true);
			translate([0,-6,-10]) cylinder(h=hole_pin_height, d=hole_pin_diameter, center=true);
			translate([0,7.5,0]) sphere(d=hole_ball_size);
			translate([0,-6,0]) sphere(d=hole_ball_size);
		}
	}
	module pin() {
		union() {
			rotate([90, 90, 0]) cylinder(h=pin_height, d=pin_diameter, center=true);
			translate([0,7.5,0]) sphere(d=ball_size);
		}
	}

	module mirror_pin() {
		rotate([90, 90, 0]) cylinder(h=hole_pin_height+small_number, d=hole_pin_diameter, center=true);
		translate([0,-(pin_height-(ball_size/2)),0]) sphere(d=ball_size);
	}


//////////////////      SOME RACK AND Z THINGS       //////////////////

module z_holes() {
    rotate([0,-90,0]) for(z=[0:z_hole_number])
    translate([22.5+z*15,16,-12])
        hole();
}

module pin_cuts() {
	union(){
		cube(size=[2,10,40], center=true);
		rotate([0,0,90]) cube(size=[2,10,40], center=true);
	}
}
module pin_uncut() {
	union(){
		rotate([0, 0, 90]) cylinder(h=hole_pin_height, d=hole_pin_diameter, center=true);
		translate([0,0,10]) sphere(d=ball_hole);
	}
}


module pin_out() {
	union(){
		rotate([0, 0, 90]) cylinder(h=pin_height, d=pin_diameter, center=true);
		translate([0,0,10]) sphere(d= ball_size);
	}
}


module pins_z(){
	difference() {
		pin_out();
		pin_cuts();
	}
}
//////////////////      RACK AND SLIDE     ///////////////////

module straight_pins() {
	for(z=[0:((((obj_leg*leg_length)*2)-(obj_leg*2))/3)/14.5]) rotate([-90,0,0]) translate([z*15,30/(15/4),14]) pins_z();
	for(z=[0:((((obj_leg*leg_length)*2)-(obj_leg*2))/3)/14.5]) rotate([-90,0,0]) translate([z*15,30/(15/4)-14,14]) pins_z();
}
module stagger_pins() {
	for(z=[0:((((obj_leg*leg_length)*2)-(obj_leg*2))/3)/14.5]) rotate([-90,0,0]) translate([z*15,30/(15/4),14]) pins_z();
	for(z=[0:((((obj_leg*leg_length)*2)-(obj_leg*2))/3)/14.5]) rotate([-90,0,0]) translate([z*15+7,30/(15/4)-14,14]) pins_z();
}


//////////////////      DOVE TAIL       //////////////////

module male_dovetail(height, bridge_extra=0) {
    union() {
        dovetail_3d(male_dove_max_width,male_dove_min_width,male_dove_depth,height);
        if (bridge_extra > 0) {
            translate([-male_dove_max_width/2,male_dove_depth,0]) cube([male_dove_max_width,bridge_extra,height]);
        }
    }
}

//male_dovetail(5,bridge_extra=0.2);

module dovetail_3d(max_width=11, min_width=5, depth=5, height=30) {
	linear_extrude(height=height, convexity=2)
		dovetail_2d(max_width,min_width,depth);
}

module dovetail_2d(max_width=11, min_width=5, depth=5) {
	angle=atan((max_width/2-min_width/2)/depth);
	//echo("angle: ", angle);
	polygon(paths=[[0,1,2,3,0]], points=[[-min_width/2,0], [-max_width/2,depth], [max_width/2, depth], [min_width/2,0]]);
}

//bow tie
module tie_end(height){
	rotate([0,0,0]) translate([0,-0.01,((obj_leg/2)/2)]) male_dovetail(height);
	rotate([0,90,0]) translate([0,-0.01,((obj_leg/2)/2)]) male_dovetail(height);
	rotate([0,180,0]) translate([0,-0.01,((obj_leg/2)/2)]) male_dovetail(height);
	rotate([0,-90,0]) translate([0,-0.01,((obj_leg/2)/2)]) male_dovetail(height);
}

module bow_support(){
	difference(){
		intersection(){
			translate([-15,0,-15]) cube([30,9,30]);
			scale([0.95,0.97,0.95]) rotate([0,45,0]) tie_end();
		}
		cube([29.2,29.2,29.2], center=true);
	}
}

module wrap(units){
	for (y = [-1:units-2]) // two iterations, z = -1, z = 1
	{
		translate([15, (y*30)+15, 15]) {
			for (r = [0:4]) // two iterations, z = -1, z = 1
			{
				rotate([0,r*90,0]) translate([0,15,15]) rotate([-90,0,0])male_dovetail(height=30);
			}
		}
	}
}

module M3_nut(h=2.4, cone=true, bridging=false) {
    hull() {
        cylinder(d=6.5, h=h, $fn=6);
        if (cone) {
            translate([0,0,h-0.01]) cylinder(d=3.2, h=1.2, $fn=20);
        }
    }
    
    if (bridging) {
        translate([0,0,h]) intersection() {
            cube([10,3.2,0.4],center=true);
            cylinder(d=6.5,h=0.5,center=true,$fn=6);
        }
        translate([0,0,h+0.2]) cube([3.2,3.2,0.4],center=true);
    }
}

module M3_nut_tapering(h=2.4, cone=true, bridging=false) {
    if (h>3) {
        union() {
            hull() {
                cylinder(d=6.9, h=0.01, $fn=6);
                translate([0,0,h-2.5]) M3_nut(h=0.1, cone=false, bridging=false);
            }
            translate([0,0,h-2.5]) M3_nut(h=2.5, cone=cone, bridging=bridging);
        }
    } else {
        M3_nut(h=h, cone=cone, bridging=bridging);
    }
}

module M4_nut(h=3.2, cone=true) {
    hull() {
        cylinder(d = 7.85, h=h, $fn=6);
        if (cone) {
            translate([0,0,h-0.01]) cylinder(d=4.2, h=2.2, $fn=20);
        }
    }
}

module M8_nut(h=5.3, cone=true) {
    hull() {
        cylinder(d = 15, h=h, $fn=6);
        if (cone) {
            translate([0,0,h-0.01]) cylinder(d=8.2, h=3.4, $fn=20);
        }
    }
}

module elongated_nut(length=4) {
    hull() {
        translate([-length/2,0,0]) M3_nut();
        translate([length/2,0,0]) M3_nut();
    }
}

module motor_shaft(h=10, extra_slop=0) {
    d = motor_shaft_hole_dia+extra_slop;
    intersection() {
        cylinder(d=d, h=h);
        union() {
            translate([0,-.5,h/2+4]) cube([d,d,h], center=true);
            cylinder(d=d, h=4.5);
        }
    }
}

//motor_shaft(extra_slop=0.0,$fn=30);

module motor_plate_holes(h=5, bolt_head_cones=false, center_chamfer=true) {
    translate([0,0,-.5]) cylinder(d=motor_center_hole, h=h+1);
    if (h > 2 && center_chamfer) {
        translate([0,0,2]) cylinder(d1=motor_center_hole, d2=motor_center_hole+(h-2), h=h-2+0.1);
    }

    for (i=[0:3]) {
        rotate([0,0,i*(360/4)]) {
            translate([motor_bolt_hole_distance/2,motor_bolt_hole_distance/2,-0.01]) cylinder(d=bolt_hole_dia, h=h+1, $fn=20);
            if (bolt_head_cones) {
                translate([motor_bolt_hole_distance/2,motor_bolt_hole_distance/2,h-2]) cylinder(d1=bolt_hole_dia, d2=bolt_head_hole_dia, h=2.01, $fn=20);

            }
        }
    }
}

module motor_plate(h=5, bolt_head_cones=false) {
    difference () {
        translate([0,0,h/2]) cube([motor_side_length,motor_side_length,h], center=true);
            

        motor_plate_holes(h, bolt_head_cones);
    }
}

module rounded_cube(x,y,z,corner,center=false) {
    fn=50;
    module rcube(x,y,z,corner) {
        translate([corner/2,corner/2,corner/2]) hull() {
            sphere(d=corner, $fn=fn);
            cube([x-corner,y-corner,z-corner]);
            if (x>corner) translate([x-corner,0,0]) sphere(d=corner, $fn=fn);
            if (x>corner && y>corner) translate([x-corner,y-corner,0]) sphere(d=corner, $fn=fn);
            if (y>corner) translate([0,y-corner,0]) sphere(d=corner, $fn=fn);
            if (z>corner) translate([0,0,z-corner]) sphere(d=corner, $fn=fn);
            if (z>corner && x>corner) translate([x-corner,0,z-corner]) sphere(d=corner, $fn=fn);
            if (z>corner && x>corner && y>corner) translate([x-corner,y-corner,z-corner]) sphere(d=corner, $fn=fn);
            if (z>corner && y>corner)translate([0,y-corner,z-corner]) sphere(d=corner, $fn=fn);
        }
    }

    module wrap() {
        diff_x = x<corner ? (corner-x)/2 : 0;
        diff_y = y<corner ? (corner-y)/2 : 0;
        diff_z = z<corner ? (corner-z)/2 : 0;
        
        translate([-diff_x,-diff_y,-diff_z]) intersection() {
            rcube(x,y,z,corner);
            translate([diff_x,diff_y,diff_z]) cube([x,y,z]);
        }
    }
    
    if (center) {
        translate([-x/2, -y/2, -z/2]) wrap();
    } else {
        wrap();
    }
}

module rounded_cube_side(x,y,z,corner,center=false) {
    intersection() {
        cube([x,y,z], center=center);
        if (!center) {
            translate([0,0,-corner]) rounded_cube(x,y,z+2*corner,corner,center);
        } else {
            rounded_cube(x,y,z+2*corner,corner,center);
        }
    }
}

module chamfered_cube(x,y,z, chamfer, center=false) {

    hull() {
        if (center) {
            cube([x, y-2*chamfer,z-2*chamfer], center=center);
            cube([x-2*chamfer,y,z-2*chamfer], center=center);
            cube([x-2*chamfer,y-2*chamfer,z], center=center);
        } else {
            translate([0,chamfer,chamfer]) cube([x, y-2*chamfer,z-2*chamfer], center=center);
            translate([chamfer,0,chamfer]) cube([x-2*chamfer,y,z-2*chamfer], center=center);
            translate([chamfer,chamfer,0]) cube([x-2*chamfer,y-2*chamfer,z], center=center);
        }
    }
}

module chamfered_cube_side(x,y,z, chamfer, center=false) {

    hull() {
        if (center) {
            cube([x, y-2*chamfer,z], center=center);
            cube([x-2*chamfer,y,z], center=center);
        } else {
            translate([0,chamfer,0]) cube([x, y-2*chamfer,z], center=center);
            translate([chamfer,00]) cube([x-2*chamfer,y,z], center=center);
        }
    }
}

module rounded_cylinder(d, h, corner) {
    hull() {
        translate([0,0,corner/2]) donut(d-corner,corner);
        translate([0,0,h-corner/2]) donut(d-corner,corner);
    }
}

module chamfered_cylinder(d,h,chamfer,center=false) {
    module _chamfered_cylinder() {
        union() {
            cylinder(d1=d-2*chamfer,d2=d,h=chamfer);
            translate([0,0,chamfer]) cylinder(d=d,h=h-2*chamfer);
            translate([0,0,h-chamfer]) cylinder(d1=d,d2=d-2*chamfer,h=chamfer);
        }
    }
    
    if (center) {
        translate([0,0,-h/2]) _chamfered_cylinder();
    } else {
        _chamfered_cylinder();
    }
}

//chamfered_cylinder(10,20,2,$fn=40);

// Thread generator. d is the outer diameter of the thread
module _threads(d=8, h=10, z_step=1.8, depth=0.5, direction=0) {
    
    function get_twist(dir) = (direction == 0) ? -360 : 360;

    multiple = round(h/z_step)+1;
    echo(h);
    
    intersection() {
        union() {
            for (i = [0:multiple]) {
                translate([0,0,i*z_step]) linear_extrude(height=z_step+0.0001, center=true, convexity = 10, twist = get_twist(direction)) translate([depth, 0, 0]) circle(d=d-2*depth);
            }
        }
        cylinder(d=2*d,h=h);
    }
}

module _nut(d=8, d2=18, h=7, indents=20, z_step=1.8, depth=0.5) {
    $fn=60;
    sphere_dia=d2+h/1.8;
    intersection() {
        difference() {
            cylinder(d=d2,h=h);
            _threads(d=d+4*slop, h=h, z_step=z_step, depth=depth);
            for (i = [0:indents-1]) {
                rotate([0,20,i*360/indents]) translate([-2,d2/2+2,0]) rotate([0,0,45]) cube([4,4,35], center=true);
            }
        }
        translate([0,0,h-sphere_dia/3]) sphere(d=sphere_dia);
        translate([0,0,sphere_dia/3]) sphere(d=sphere_dia);
    }
}

module _bolt_shaft(d, h, shaft=0, z_step=1.8, depth=0.5, direction=0) {
    module _do_shaft(th) {
        intersection() {
            rotate([-90,0,0]) _threads(d=d, h=th, z_step=z_step, depth=depth, direction=direction);
            translate([0,th/2,d*0.1]) cube([d,th,d], center=true);
        }
    }

    if (shaft == 0) {
        _do_shaft(h);
    } else {
        translate([0,shaft-0.01,0]) _do_shaft(h-shaft);
        intersection() {
            rotate([-90,0,0]) cylinder(d=d, h=shaft);
            translate([0,shaft/2,d*0.1]) cube([d,shaft,d], center=true);
        }
    }
}

module _bolt(d=8, h=20, h2=20, shaft=0, diameter=1, z_step=1.8, depth=0.5) {
    l = h + shaft;
    difference() {
        union() {
            _bolt_shaft(d=d, h=h, shaft=shaft, z_step=z_step, depth=depth);
            translate([0,-1.499,0]) rounded_cube(d*1.1,3,d*1.1,diameter,center=true);
            translate([0,-6,0]) rounded_cube(4,10,d*1.1,diameter,center=true);
        }
        // hidden infill
        translate([1.5,-10,-1.5]) rotate([-90,0,0]) cylinder(d=0.1,h=l);
        translate([0,-10,1.5]) rotate([-90,0,0]) cylinder(d=0.1,h=l);
        translate([-1.5,-10,-1.5]) rotate([-90,0,0]) cylinder(d=0.1,h=l);
    }
}

module donut(d, h, angle=360) {
    rotate_extrude(angle=angle, convexity=10) translate([d/2,0,0]) circle(h);
}

module cube_donut(d, h, angle=360, rotation=45) {
    rotate([0,0,-angle/2])
    rotate_extrude(angle=angle, convexity=10)
    translate([d/2,0,0])
    rotate([0,0,rotation])
    square([h,h], center=true);
}

function hexagon_dia_to_cylinder(hex_dia) = (hex_dia/2) / sin(60) * 2;

module hexagon(inner_diameter, height=10) {
    cylinder(d=hexagon_dia_to_cylinder(inner_diameter), h=height, $fn=6);
}

//translate([50,50]) M3_nut();
//translate([50,50]) elongated_nut();
//translate([50,47.2]) cube([5.6, 5.6, 2.4]);

module pyramid(w, cap=0) {
    h = w/2;
    module _pyramid() {
        hull() {
            translate([0,0,0.01/2]) cube([w,w,0.01], center=true);
            translate([0,0,h-0.01]) cube([0.01,0.01,0.01]);
        }
    }

    if (cap > 0) {
        intersection() {
            _pyramid(w);
            translate([0,0,(h-cap)/2]) cube([w,w,h-cap], center=true);
        }
    } else {
        _pyramid();
    }
}

module ridged_cylinder(d=10, h=15, r=1.5) {
    steps = round(PI*d/r);
    ridge = PI*d/steps/2;

    union() {
        cylinder(d=d-ridge/2,h=h);
        for (i = [0:steps-1]) {
            rotate([0,0,i*360/steps]) translate([d/2-ridge*0.45,0,h/2]) cube([ridge,ridge,h], center=true);
        }
    }
}

module _v_thread(thread_d=20, pitch=3, rounds=1, direction=0, steps=100) {

    module _v_thread_slice(d, h, angle=360, rotation=45) {
        cube_donut(d, h, angle=angle, rotation=rotation, $fn=angle);
    }

    thread_length = PI*thread_d;
    rise_angle = asin(pitch/thread_length);
    echo("Rise angle:", rise_angle);

    angle_step = 360 / steps;

    z_step = pitch / steps;

    cube_w = sqrt((pitch*pitch)/2);

    function get_z_pos(i) = direction == 0 ? z_step*i : -z_step*i+pitch*rounds;
    function get_rise_angle() = direction == 0 ? rise_angle : -rise_angle;

    _rounds = rounds * steps - 1;
    union() {
        for (i=[0:_rounds]) {
            rotate([0,0,i*angle_step]) translate([0,0,get_z_pos(i)]) rotate([get_rise_angle(),0,0]) _v_thread_slice(thread_d, cube_w, angle_step*1.01);
        }
    }
}
//_v_thread(thread_d=20, pitch=3, rounds=1, direction=0, steps=50);

module v_screw(h=10, screw_d=20, pitch=4, direction=0, steps=100) {
    rounds = h/pitch+1;
    d = screw_d - pitch;

    // debug
    //translate([0,0,5]) cylinder(d=screw_d, h=20);


    render(convexity = 10) {
        intersection() {
            union() {
                translate([0,0,-pitch/2]) _v_thread(thread_d=d, pitch=pitch, rounds=rounds, direction=direction, steps=steps);
                cylinder(d=d+pitch/10, h=h, $fn=steps);
            }
            cylinder(d=screw_d-pitch/10, h=h, $fn=steps);
        }
    }
}

//v_screw(h=10, screw_d=20, pitch=4, direction=1, steps=100);

module tube(d=10,h=10,wall=1,center=false) {
    difference() {
        cylinder(d=d,h=h,center=center);
        translate([0,0,-1/2]) cylinder(d=d-2*wall,h=h+2,center=center);
    }
}