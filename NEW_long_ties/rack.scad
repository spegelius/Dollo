include <include.scad>;
include <globals.scad>;


//globals

obj_height = 20;
units = 3; //only even numbers
unit_length = 29.93;
tail_depth = 8;
tie_scale_x = 1;
tie_scale_y = 1;
tie_scale_z = 1;

resolution = 10;

teeth_angle = 25;

// for rounded cube
diameter = 3;

module tie_taken(){
    difference(){
        translate([0,tail_depth,0]) rotate([0,90,180]) scale([tie_scale_x,tie_scale_z,tie_scale_y])  male_dovetail(height=30);
	}
}

module rackHalf(){
    intersection() {
        union() {
            translate([0,0,-10]) rotate(a=[0,-teeth_angle,0]) {
                linear_extrude(height = obj_height*2, center = true, convexity = 10)
                import (file = "rack.dxf", layer = "Layer_1");
            }
        }
        translate([1, 0, obj_height/-4]) cube(center = true, [50, 10, obj_height/2]);
    }
}
module rackFull(){
    intersection() {
        union() {
            mirror([0,0,1]) rackHalf();
            rackHalf();
        }
        union() {
            cube(center = true, [50, 10, obj_height-8]);

        }
    }
}

//herring bone style rack made from inkscape and OpenScad
module rackObject() {



    for(rack_length=[-2:units-2]){
        translate([-rack_length*unit_length,0,13.5]) {
					intersection(){
						rackFull();
						scale([1,.95,1]) translate([0,3,0]) rotate([0,90,0]) cylinder(r=6.5, h=40, center=true);
					}
		}
	}

    difference(){
        union() {
            translate([-units*(unit_length/2)+45,6,0]) cube([unit_length*units+20,8,40], center=true);
            // slides
            translate([-units*(unit_length/2)+51,1,-17]) rounded_cube(unit_length*units+5,5,6,$fn=40);
            translate([-units*(unit_length/2)+51,1,4]) rounded_cube(unit_length*units+5,5,6,$fn=40);
        }
        // side indents
        translate([-units*(unit_length/2)+51,4,-23]) rounded_cube(unit_length*units+5,6,7,$fn=40);
        translate([-units*(unit_length/2)+51,5,23]) rounded_cube(unit_length*units+5,4,7,$fn=40);
    }
    translate([-units*(unit_length)+41,0.5,-18.75]) cube([unit_length*units+10,1.5,25.7]);
}

//translate([0,30,0]) rackHalf();

// height measurement cube
//translate([0,0,-10]) cube([20,20,11.5]);

end_offset = 47.8;
head_offset = end_offset - unit_length;

intersection(){
//translate([0,0,-10]) cube([20,20,20]);
	intersection(){
		rotate([-90,0,0]) translate([-10-((units-2)*15),0,0]) translate([unit_length+5,0,0]) rounded_cube(unit_length*units+25,20,40,$fn=40);
        union(){
            rotate([-90,0,0]) intersection(){
                difference(){
                    rackObject();
                    for(rack_length=[-units:1]){
						translate([30*rack_length+30,2,0]) tie_taken();
                        //translate([30*rack_length+30,7,-12]) rotate([180,0,0]) tie_taken();
                    }
                }

                difference(){
                    union(){
                        translate([-units*(unit_length/2)+51+slop/2,0,0]) rounded_cube(unit_length*units-slop,20,40,$fn=50);
                        translate([end_offset-(units*unit_length)+slop,-5,13.5]) rotate([0,teeth_angle,0]) cube([30,30,30]);
                        mirror([0,0,1]) translate([end_offset-(units*unit_length)+slop,-5,-13.5]) rotate([0,teeth_angle,0]) cube([20,20,30]);
                        
                        // coupler
                        translate([-units*(unit_length)+49.8+slop, 10, 13.5]) rotate([90,-90,0]) scale([0.95,0.95,0.95]) male_dovetail(5);
                        translate([-units*(unit_length)+52+slop, 7.62, 13.5]) scale([0.95,0.95,0.95]) cube([5,5,5], center=true);
                        
                        translate([-units*(unit_length)+51+slop, 10, -10]) rotate([90,-90,0]) scale([0.95,0.95,0.95]) male_dovetail(10);
                        translate([-units*(unit_length)+53.2+slop, 7.62, -10]) scale([0.95,0.95,0.95]) cube([5,5,5], center=true);
                    }
                    union(){
                        translate([end_offset,-5,13.5]) rotate([0,teeth_angle,0]) cube([30,30,30]);
                        mirror([0,0,1]) translate([end_offset,-5,-13.5]) rotate([0,teeth_angle,0]) cube([30,30,30]);
                    }
                    
                    // coupler hole
                    translate([end_offset+2, 10, 13.5]) rotate([90,-90,0]) male_dovetail(5.5);
                    translate([end_offset+3.2, 10, -10]) rotate([90,-90,0]) male_dovetail(10);
                }
            //intersection
            }
        //union
        }
	//intersection
	}
//intersection
}

// slide