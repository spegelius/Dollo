include <publicDomainGearV1.1.scad>;


///////////////////// FOCUS ON THIS NOW //////////////////////////////
pillar_space = 180;
twist_gears = 0;
thickness_gears = 3;
hole_diameter_gears = 3.5;
pin_position = 7;
radius = 37;
$fn = 40;
tooth_depth_twist = 2;
mirror = true;
//mm_per_tooth_gears    = 9;
//pressure_angle_gears  = 28;
mm_per_tooth_gears    = 4;
pressure_angle_gears  = 24;

twist_height_units = 3;
///////////////////// FOCUS ON THIS NOW //////////////////////////////


module frame(){
    side = pillar_space/2 + 15;
    translate([-side,-side,0]) cube([30,30,30], center=true);
    translate([side,side,0]) cube([30,30,30], center=true);
    translate([-side,side,0]) cube([30,30,30], center=true);
    translate([side,-side,0]) cube([30,30,30], center=true);
}
//frame();

//%rotate([0,0,45]) cube([200,200,10], center=true);
holes = 32;
module motor_mount(){
    //rotate([0,0,45]) cube([42,42,5], center=true);
    translate([holes/2,holes/2,0]) cylinder(d=5, h=50);
    translate([-holes/2,holes/2,0]) cylinder(d=5, h=50);
    translate([-holes/2,-holes/2,0]) cylinder(d=5, h=50);
    translate([holes/2,-holes/2,0]) cylinder(d=5, h=50);
}

    
//rotate([0,0,45])motor_mount();
module pins(height=10, z=0, d=5){
    translate([pin_position,pin_position,z]) cylinder(h=height, d=d);
    translate([-pin_position,-pin_position,z]) cylinder(h=height, d=d);
}

module gear_one(hole_diameter_gears=5.5){
    teeth=26;
    translate([0,0,thickness_gears]) mirror([0,0,1]) gear(mm_per_tooth_gears,teeth,thickness_gears,hole_diameter_gears,twist_gears);
    gear(mm_per_tooth_gears,teeth,thickness_gears,hole_diameter_gears,twist_gears);
    translate([0,4.5,thickness_gears/2]) cube([5,5,thickness_gears*2], center=true);
}
		
module gear_one_with_extra_body(hole_diameter_gears=5.5) {
    gear_one(hole_diameter_gears);
    difference() {
        translate([0,0,thickness_gears]) cylinder(d=15, h=5, $fn=20);
        translate([0,0,thickness_gears])cylinder(d=hole_diameter_gears, h=5, $fn=20);
    }
    translate([0,4.5,thickness_gears+2.5]) cube([5,5,5], center=true);
}
		//test

		//end test
		
module gear_large_gear() {
    gear(mm_per_tooth_gears,52,thickness_gears+8,hole_diameter_gears,twist_gears);
}

module gear_large() {
	 difference(){
		union(){
			difference(){
				gear_large_gear();
				translate([15,-4,4]) linear_extrude(h=20) text("", font="fontawesome");
			}
			intersection(){
				hull(){
					translate([0,0,-7]) scale([1,1,.25]) sphere(r=40, $fn=100);
                    translate([0,0,(-10*twist_height_units)+5]) scale([1,1,.25]) sphere(r=40, $fn=100);
									
				}
				translate([0,0,-22]) twist_large();
			}
		}
		cylinder(h=100, d=3.25, center=true);
		translate([0,0,(-10*2)-3]) sphere(d=6, center=true);
	}
}

module middle_gear(){
    teeth = 44;    
    gear(mm_per_tooth_gears,teeth,thickness_gears,hole_diameter_gears,twist_gears);
    mirror([0,0,1]) translate([0,0,thickness_gears]) gear(mm_per_tooth_gears,teeth,thickness_gears,hole_diameter_gears,twist_gears);
}

module reverse_gear_one(){         
    gear(mm_per_tooth_gears,16,thickness_gears*2,hole_diameter_gears,twist_gears);
}

module reverse_gear_two(){         
	gear(mm_per_tooth_gears,25,thickness_gears*2,hole_diameter_gears,twist_gears);
}

module scaled_middle_gear(scaling=1){
    hole_diameter = (1-scaling+1) * hole_diameter_gears;
    echo (hole_diameter);
	scale([scaling, scaling, 1]) gear(mm_per_tooth_gears, 10, thickness_gears*2, hole_diameter, twist_gears);
}

module twist() {
    difference() {
        translate([35,35,0]) linear_extrude(height = 10, center = false, convexity = 10, twist = 360, $fn = 50) translate([tooth_depth_twist, 0, 0]) circle(r = radius);
        union(){
            translate([35,35,3]) cylinder(d=3.5, h=50, center=true);
            translate([35, 35, 0]) pins(height=20, d=5.5 );
        }
    }   
}

module twist_large_extrude() {
    linear_extrude(height = 10*2, center = false, convexity = 10, twist = 360*2, $fn = 60)
        translate([tooth_depth_twist, 0, 0]){
						circle(r = radius);
            }
}

module twist_large() {
    difference(){
        difference() {
            twist_large_extrude();
            //union(){
            //    translate([0,0,3]) cylinder(d=3.5, h=50, center=true);
            //    #translate([0, 0, 0]) pins(height=20, d=3.5 );
            //}
        }
        cylinder(r=radius-2, h=10*3);
        //difference(){
        //    rotate([0,-3.5,0]) translate([0,37,-2.5]) cube([100,37*2,10], center=true);
        //    translate([35,2,2]) sphere(r=5);
        //}
        //difference(){
        //    rotate([0,3.5,0]) translate([0,-37,22]) cube([100,37*2,10], center=true);
        //    translate([35,-2,19]) sphere(r=5);
        //}
    }
	difference(){
		cylinder(h=10*2, r=radius-2);
		rotate([180,0,0])translate([20,-4,-3]) linear_extrude(h=5) text("", font="fontawesome");
	}
}

//gear_large();
//twist();
//reverse_gear_one();
//reverse_gear_two();
//scaled_middle_gear(scaling=1.021);
//twist_large();
//middle_gear();
//gear_one();
//gear_one_with_extra_body();

// for finding out gear's diameter
//difference() {
//    translate([0,0,-20]) cylinder(d=63.7, h=20, $fn=120);
//    translate([0,0,-20]) cylinder(d=3, h=30);
//}

module bed_layout() {
    module motor(){
        #translate([43.84/2,0]) 		circle(d=3, $fn=20);
        #translate([-43.84/2,0]) 		circle(d=3, $fn=20);
        #translate([0,43.84/2]) 		circle(d=3, $fn=20);
        #translate([0,-43.84/2]) 		circle(d=3, $fn=20);
    }
    
    frame();
    rotate([0,0,7]) gear_one();
    //rotate([0,0,45]) 
    translate([45,0,2]) rotate([0,0,4]) middle_gear();
    rotate([0,0,180]) translate([45,0,2]) rotate([0,0,4]) middle_gear();
    rotate([0,0,45]) translate([84.2,0,0]) rotate([0,0,6]) gear_large_gear();
    rotate([0,0,135]) translate([84.2,0,0]) rotate([0,0,2]) gear_large_gear();
    rotate([0,0,225]) translate([84.2,0,0]) rotate([0,0,2]) gear_large_gear();
    rotate([0,0,315]) translate([84.2,0,0]) rotate([0,0,1]) gear_large_gear();
    rotate([0,0,45]) motor();
}

//bed_layout();

