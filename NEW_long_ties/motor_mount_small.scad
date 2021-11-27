$fn = 30;
include <globals.scad>;
include <include.scad>;


////// VARIABLES //////
frame_width = 35.5;
tail_depth = 11;
rack_height = 12.5;
rack_slide_height = 8;
mount_max = 62.5;
wabble = 1.5;
not_tooth_gap = 0;
rack_gap = 2.5;
tower_height = 17.5+3;

text = "Dollo";
font = "Liberation Sans";

hole_length = 1;

//$fn=220;

// for rounded cube
diameter = 2;


////// VIEW //////
//motor_mount(bridges=true);
motor_mount(bridges=true, motor_side=false);


////// MODULES //////
module y_mount_added(motor_side){    
    //base
    translate([0, -5.75 + rack_gap/2, -1])
    rounded_cube(
        y=38.5 + rack_gap * 2, x=frame_width + 35 + 1,
        z=4, center=true, corner=diameter);
    
    // lower slide
    slide_depth = 11;
    slide_pos_y = frame_width - 24.9 + rack_gap;
    
    module slide() {
        difference() {
            rotate([45, 0, 0])
            rounded_cube(
                z=15, x=17, y=15, corner=2, center=true);

            translate([0, 0, -8])
            cube([60, 30, 30], center=true);
        }
    }
    
    translate([-27, slide_pos_y, -4.55])
    slide();

    translate([0, slide_pos_y, -4.55])
    slide();

    translate([27, slide_pos_y, -4.55])
    slide();
    
    translate([0, slide_pos_y - 8.85, 0.6])
    rounded_cube(
        z=5, x=frame_width + 35 + 1, y=26,
        corner=diameter, center=true);

    if (motor_side) {
        translate([0, slide_pos_y, 0.05])

        hull() {
            rounded_cube(
                z=6.1, x=10, y=28, corner=diameter,
                center=true
            );

            translate([0, -28/2 + 2/2, 0])
            rounded_cube(
                z=6.1, x=35, y=2, corner=diameter,
                center=true
            );
        }

    }

    // center
	translate([-11, -12.75, 0.625])
    cube([22, 18, 10]);

    // towers

    //top tower
	translate([0 - 21, -25.75, 0.625])
    cube([42, 18, tower_height]);
    
    tower_pos_y = -2;

    // right tower
	translate([20, tower_pos_y, (17.5 + 4.25)/2])
    rounded_cube(20, 15, tower_height, diameter, center=true);

    translate([
        (32  -21 - 4) + 19 - 4.5,
        tower_pos_y + 15/2 - 4.8,
        tower_height]
    ) 
    cylinder(d=7, h=2);
    
    // left tower
    difference() {
        translate([-20, tower_pos_y, (17.5 + 4.25)/2])
        rounded_cube(20, 15, tower_height, diameter, center=true);

        translate([
            (-21 - 4) + 3.5, tower_pos_y + 15/2 - 4.8,
            tower_height-1.5]
        )
        cylinder(d=7.25, h=2.5);
    }
}

module bolt_hole() {
    hull() {
        cylinder(d=bolt_hole_dia, h=70);

        translate([hole_length, hole_length, 0])
        cylinder(d=bolt_hole_dia, h=70);
    }
}

module bolt_head_hole() {
    hull() {
        cylinder(d=6.5, h=3);

        translate([hole_length,hole_length,0])
        cylinder(d=6.5, h=3);
    }
}

module tapered_bolt_head_hole() {
    hull() {
        cylinder(d1=bolt_hole_dia, d2=6.5, h=3);

        translate([hole_length, hole_length, 0])
        cylinder(d1=bolt_hole_dia, d2=6.5, h=3);
    }
}

module y_mount_taken(bridges, motor_side){

    function bolt_hole_h() = bridges ? 0.2 : 0;

	halign = [
	   [0, "center"]
	 ];
	 
    rotate([0, 0, -90])
    for (a = halign) {
        translate([-6.5, 12, -3])
        linear_extrude(height = 1)
        text(text = str(text), font = font, size = 6, halign = a[1]);
    }
    rotate([0, 0, 90])
    for (a = halign) {
        translate([6.5, 12, -3])
        linear_extrude(height = 1)
        text(text = str(text), font = font, size = 6, halign = a[1]);
    }
		 
	rotate([0, 0, 45]) {
        // bolt holes. leave 0.2 = one layer which can be easily drilled out
        translate([5.65 - 21, 5.65 - 21, bolt_hole_h()])
        bolt_hole();

		translate([5.65 + 31-21, 5.65 - 21, bolt_hole_h()])
        bolt_hole();

		translate([5.65 - 21, 5.65 + 31 - 21, bolt_hole_h()])
        bolt_hole();

		//counter sink
        translate([5.65 - 21, 5.65 - 21, -3])
        bolt_head_hole();

		translate([5.65 + 31 - 21, 5.65 - 21, -3])
        bolt_head_hole();

        translate([5.65 - 21, 5.65 + 31 - 21, -3])
        bolt_head_hole();


        if (motor_side) {
            translate([5.65 + 31 - 21, 5.65 + 31 - 21, -10])
            bolt_hole();

            translate([5.65 + 31 - 21, 5.65 + 31 - 21, 0.5])
            tapered_bolt_head_hole();
        }

        // large chamfers
        difference() {
            translate([-70, -30, -5])
            cube([50, 70, 50]);

            translate([-19, -7, 0])
            rotate([0, 0, 45])
            rounded_cube(12, 12, 100, 3, center=true);
        }
        difference() {
            translate([-30, -70, -5])
            cube([70, 50, 50]);

            translate([-7, -19, 0])
            rotate([0, 0, 45])
            rounded_cube(12, 12, 100, 3, center=true);
        }

        // motor center hole
        if (motor_side) {
            translate([0, 0, -5])
            hull() {
                cylinder(d=motor_center_hole, h=4);
                cylinder(d=motor_center_hole - 8, h=18);

                translate([hole_length, hole_length, 0]) {
                    cylinder(d=motor_center_hole, h=4);
                    cylinder(d=motor_center_hole - 8, h=18);
                }
            }
        }

        // dove holes
        if (!motor_side) {
            rotate([90, 0, -45])
            translate([-8, -3, -43 + tail_depth])
            male_dovetail(height=30, bridge_extra=0.2);

            rotate([90, 0, -45])
            translate([8, -3, -43 + tail_depth])
            male_dovetail(height=30, bridge_extra=0.2);
        }

		rotate([90, 0, -45])
        translate([-8, -3, 22 - tail_depth])
        male_dovetail(height=30, bridge_extra=0.2);

		rotate([90, 0, -45])
        translate([8, -3, 22 - tail_depth])
        male_dovetail(height=30, bridge_extra=0.2);
	}
}

module _motor_mount(bridges, motor_side){
	difference(){
		y_mount_added(motor_side);
		y_mount_taken(bridges, motor_side);
	}
}

module translated_mount(bridges, motor_side){
    translate([(-obj_leg/2) - 2.5, 0, 0])
    rotate([0, 90, 0])
    _motor_mount(bridges, motor_side);
}

module motor_mount(bridges=true, motor_side=true) {
    translate([0, 0, 20.5])
    rotate([0, -90, 0])
    difference(){
        translated_mount(bridges, motor_side);

        translate([-15, 0, 0])
        rotate([0, 90, 0])
        union(){
            translate([-20, 20, 15])
            rotate([90, 0, 45])
            cylinder(h=70, d=22);

            translate([20, 20, 15])
            rotate([90, 0, -45])
            cylinder(h=70, d=22);
        }
    }
}


