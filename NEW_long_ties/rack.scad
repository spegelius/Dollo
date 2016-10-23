include <include.scad>;
include <globals.scad>;


//globals

obj_height = 40;
units = 6; //only even numbers
unit_length = 29.93;
tail_depth = 8;
tie_scale_x = 1;
tie_scale_y = 1;
tie_scale_z = 1;

resolution = 10;

teeth_angle = 25;


//good things
module rounded_cube(width,depth,height){
    hull(){
        translate([width/2-diamiter/2,depth/2-diamiter/2,height/2-diamiter/2]) sphere(d=diamiter);
        translate([width/2-(diamiter/2),depth/2-(diamiter/2),-height/2+(diamiter/2)]) sphere(d=diamiter);
        translate([-width/2+diamiter/2,depth/2-diamiter/2,height/2-diamiter/2]) sphere(d=diamiter);
        translate([-width/2+(diamiter/2),depth/2-(diamiter/2),-height/2+(diamiter/2)]) sphere(d=diamiter);
        
        translate([width/2-diamiter/2,-depth/2+diamiter/2,height/2-diamiter/2]) sphere(d=diamiter);
        translate([width/2-(diamiter/2),-depth/2+(diamiter/2),-height/2+(diamiter/2)]) sphere(d=diamiter);
        translate([-width/2+diamiter/2,-depth/2+diamiter/2,height/2-diamiter/2]) sphere(d=diamiter);
        translate([-width/2+(diamiter/2),-depth/2+(diamiter/2),-height/2+(diamiter/2)]) sphere(d=diamiter);
    }
}  

module tie_taken(){
    difference(){
        translate([0,tail_depth,0]) rotate([0,90,180]) scale([tie_scale_x,tie_scale_z,tie_scale_y])  male_dovetail(height=30);
	}
}

module rackHalf(){
    intersection() {
        union() {
            translate([0,0,-10]) rotate(a=[0,-teeth_angle,0]) {
                linear_extrude(height = obj_height*1, center = true, convexity = 10)
                import (file = "rack.dxf", layer = "Layer_1");
            }
        }
        translate([1, 0, obj_height/-4]) cube(center = true, [50, 20, obj_height/2]);
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



    for(rack_length=[-units:units]){
        translate([rack_length*unit_length,0,0]) {
					intersection(){
						rackFull();
						scale([1,.25,1]) translate([0,5,0]) rotate([0,90,0]) cylinder(r=15, h=40, center=true);
					}
		}
	}

	for(rack_length=[-units:units]){
		difference(){
			translate([unit_length*rack_length+15,6,0]) cube([unit_length,8,40], center=true);
		}
	}
}
diamiter = 4;

//translate([0,30,0]) rackHalf();

end_offset = 47.8;
head_offset = end_offset - unit_length;

intersection(){
//translate([0,0,-10]) cube([20,20,20]);
	intersection(){
		rotate([-90,0,0]) translate([-10-((units-2)*15),0,0]) translate([unit_length,0,0]) rounded_cube(unit_length*units+10,20,40,$fn=resolution);
        union(){
            rotate([-90,0,0]) intersection(){
                difference(){
                    rackObject();
                    for(rack_length=[-units:1]){
						translate([30*rack_length+30,2,0]) tie_taken();
                    }
                }

                difference(){
                    union(){
                        translate([-(units-4)*unit_length/2,0,0]) rounded_cube(30*units,20,40,$fn=50);
                        translate([end_offset-(units*unit_length),-5,0]) rotate([0,teeth_angle,0]) cube([30,30,30]);
                        mirror([0,0,1]) translate([end_offset-(units*unit_length),-5,0]) rotate([0,teeth_angle,0]) cube([30,30,30]);
                    }
                    union(){
                        translate([end_offset,-5,0]) rotate([0,teeth_angle,0]) cube([30,30,30]);
                        mirror([0,0,1]) translate([end_offset,-5,0]) rotate([0,teeth_angle,0]) cube([30,30,30]);
                    }
                }
            //intersection
            }
        //union
        }
	//intersection
	}
//intersection
}