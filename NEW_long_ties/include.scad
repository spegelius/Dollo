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

module male_dovetail(height) {
	dovetail_3d(male_dove_max_width,male_dove_min_width,male_dove_depth,height);
}

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
			scale([1.05,1.05,1.05]) rotate([0,45,0]) tie_end();
		}
		cube([29.2,29.2,29.2], center=true);
	}
}

	module wrap(units){
	for (y = [-1:units-2]) // two iterations, z = -1, z = 1
	{
			translate([15, (y*30)+15, 15]){
			for (r = [0:4]) // two iterations, z = -1, z = 1
			{
				rotate([0,r*90,0]) translate([0,15,15]) rotate([-90,0,0])male_dovetail(height=30);
			}
		}
	}
	}


module nut(h=2.4) {
    hull() {
        cylinder(d = 6.5, h=h, $fn=6);
        translate([0,0,2.4]) cylinder(d = 3.2, h=1.2, $fn=20);
    }
}

module elongated_nut(length=4) {
    hull() {
        translate([-length/2,0,0]) nut();
        translate([length/2,0,0]) nut();
    }
}

module motor_shaft_hole(h=10) {
    difference() {
        cylinder(d=motor_shaft_hole_dia, h=h);
        translate([0,4.5,h/2]) cube([5,5,h], center=true); 
    }
}

module motor_plate(h=5) {
    difference () {
        translate([0,0,h/2]) cube([motor_side_length,motor_side_length,h], center=true);
            
        translate([0,0,-.5]) cylinder(d=motor_center_hole, h=h+1);

        translate([motor_bolt_hole_distance/2,motor_bolt_hole_distance/2,0]) cylinder(d=bolt_hole_dia, h=h+1, $fn=20);
        translate([-motor_bolt_hole_distance/2,motor_bolt_hole_distance/2,0]) cylinder(d=bolt_hole_dia, h=h+1, $fn=20);
        translate([motor_bolt_hole_distance/2,-motor_bolt_hole_distance/2,0]) cylinder(d=bolt_hole_dia, h=h+1, $fn=20);
        translate([-motor_bolt_hole_distance/2,-motor_bolt_hole_distance/2,0]) cylinder(d=bolt_hole_dia, h=h+1, $fn=20);
    }
}

module rounded_cube(width,depth,height){
    hull(){
        translate([width/2-diameter/2,depth/2-diameter/2,height/2-diameter/2]) sphere(d=diameter);
        translate([width/2-(diameter/2),depth/2-(diameter/2),-height/2+(diameter/2)]) sphere(d=diameter);
        translate([-width/2+diameter/2,depth/2-diameter/2,height/2-diameter/2]) sphere(d=diameter);
        translate([-width/2+(diameter/2),depth/2-(diameter/2),-height/2+(diameter/2)]) sphere(d=diameter);
        
        translate([width/2-diameter/2,-depth/2+diameter/2,height/2-diameter/2]) sphere(d=diameter);
        translate([width/2-(diameter/2),-depth/2+(diameter/2),-height/2+(diameter/2)]) sphere(d=diameter);
        translate([-width/2+diameter/2,-depth/2+diameter/2,height/2-diameter/2]) sphere(d=diameter);
        translate([-width/2+(diameter/2),-depth/2+(diameter/2),-height/2+(diameter/2)]) sphere(d=diameter);
    }
}
//translate([50,50]) nut();
//translate([50,50]) elongated_nut();
//translate([50,47.2]) cube([5.6, 5.6, 2.4]);

module frame_mockup(bed_angle=45, units=1) {
    corner_side = 60;
    unit = 120;
    unit_len = units*unit;
    z = 2*corner_side + unit_len - 30;
    
    module corner() {
        difference() {
            union() {
                cube([30,30,corner_side]);
                cube([30,corner_side,30]);
                cube([corner_side,30,30]);
            }
            translate([15,-0.01,0]) male_dovetail(corner_side+1);
            translate([-0.01,15,0]) rotate([0,0,-90]) male_dovetail(corner_side+1);
            translate([15,30.01,0]) rotate([0,0,180]) male_dovetail(corner_side+1);
            translate([30.01,15,0]) rotate([0,0,90]) male_dovetail(corner_side+1);
        }
    }
    
    module side() {
        difference() {
            cube([30,30,unit_len]);
            translate([15,-0.01,0]) male_dovetail(corner_side+1);
            translate([-0.01,15,0]) rotate([0,0,-90]) male_dovetail(unit_len+1);
            translate([15,30.01,0]) rotate([0,0,180]) male_dovetail(unit_len+1);
            translate([30.01,15,0]) rotate([0,0,90]) male_dovetail(unit_len+1);
        }
    }
    
    // corners
    %translate([-corner_side-unit_len/2, -corner_side-unit_len/2, 0]) corner();
    %mirror([1,0,0]) translate([-corner_side-unit_len/2, -corner_side-unit_len/2, 0]) corner();
    %mirror([0,1,0]) translate([-corner_side-unit_len/2, -corner_side-unit_len/2, 0]) corner();
    %mirror([1,1,0]) translate([-corner_side-unit_len/2, -corner_side-unit_len/2, 0]) corner();
    
    // corners
    translate([0,0,2*corner_side + unit_len]) mirror([0,0,1]) {
        %translate([-corner_side-unit_len/2, -corner_side-unit_len/2, 0]) corner();
        %mirror([1,0,0]) translate([-corner_side-unit_len/2, -corner_side-unit_len/2, 0]) corner();
        %mirror([0,1,0]) translate([-corner_side-unit_len/2, -corner_side-unit_len/2, 0]) corner();
        %mirror([1,1,0]) translate([-corner_side-unit_len/2, -corner_side-unit_len/2, 0]) corner();
    }

    // sides
    %translate([-corner_side-unit_len/2, unit_len/2, 0]) rotate([90,0,0]) side();
    %mirror([1,0,0]) translate([-corner_side-unit_len/2, unit_len/2, 0]) rotate([90,0,0]) side();
    %rotate([0,0,90]) translate([-corner_side-unit_len/2, unit_len/2, 0]) rotate([90,0,0]) side();
    %mirror([0,1,0]) %rotate([0,0,90]) translate([-corner_side-unit_len/2, unit_len/2, 0]) rotate([90,0,0]) side();
    
    // sides
    %translate([-corner_side-unit_len/2, unit_len/2, z]) rotate([90,0,0]) side();
    %mirror([1,0,0]) translate([-corner_side-unit_len/2, unit_len/2, z]) rotate([90,0,0]) side();
    %rotate([0,0,90]) translate([-corner_side-unit_len/2, unit_len/2, z]) rotate([90,0,0]) side();
    %mirror([0,1,0]) %rotate([0,0,90]) translate([-corner_side-unit_len/2, unit_len/2, z]) rotate([90,0,0]) side();

    %translate([-corner_side-unit_len/2, -corner_side-unit_len/2, corner_side]) side();
    %mirror([1,0,0]) translate([-corner_side-unit_len/2, -corner_side-unit_len/2, corner_side]) side();
    %mirror([0,1,0]) translate([-corner_side-unit_len/2, -corner_side-unit_len/2, corner_side]) side();
    %mirror([1,1,0]) translate([-corner_side-unit_len/2, -corner_side-unit_len/2, corner_side]) side();

    // bed
    translate([0,0,60]) %difference() {
        rotate([0,0,bed_angle]) cube([210,210,1], center=true);
        rotate([0,0,bed_angle]) cube([190,190,2], center=true);
    }
    
}

//frame_mockup(0, 2);