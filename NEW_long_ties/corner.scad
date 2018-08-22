include <include.scad>;
include <globals.scad>;

//if you can do pretty far over hangs, like an SLA printer or something then take this off by setting it to false.
support = true;
slot_translate = .5;
rod_size = .5;
cube_outset = 0.001;

extra_stiff = true;

module basic_corner() {

	module added(){
        w1 = obj_leg + cube_outset;
        w2 = obj_leg*2;

        union() {
            translate([0,0,15]) cube([w1,w1,w2], center=true);
            translate([0,15,0]) cube([w1,w2,w1], center=true);
            translate([15,0,0]) cube([w2,w1,w1], center=true);
            if (extra_stiff) {
                w = 7;
                translate([15,-15+w/2,20]) rotate([0,45,0]) cube([50,w,20], center=true);
                translate([-15+w/2,15,20]) rotate([-45,0,0]) cube([w,50,20], center=true);
                translate([15,20,-15+w/2]) rotate([0,0,-45]) cube([50,20,w], center=true);
                //translate([15,15,15]) sphere(d=15,$fn=40);

                hull() {
                    translate([15,15-w/2,15]) rotate([0,45,0]) cube([10,w,10], center=true);
                    translate([15-w/2,15,15]) rotate([-45,0,0]) cube([w,10,10], center=true);
                    translate([15,15,15-w/2]) rotate([0,0,-45]) cube([10,10,w], center=true);
                }
            }
        }
	}

	module taken(){
		cylinder(d=8.5, h=obj_leg*5, center=true);
		rotate([0,90,0]) cylinder(d=8.5, h=obj_leg*5, center=true);
		rotate([90,0,0]) cylinder(d=8.5, h=obj_leg*5, center=true);
		cylinder(d=23, h=28, center=true);
		rotate([0,90,0]) cylinder(d=23, h=28, center=true);
		rotate([90,0,0]) cylinder(d=23, h=28, center=true);

		module wrap(){
			translate([0,-15.005,0]) male_dovetail(height=50);
			rotate([0,0,90]) translate([0,-15.005,-15]) male_dovetail(height=65);
			rotate([0,0,180]) translate([0,-15.005,-15]) male_dovetail(height=65);
			rotate([0,0,-90]) translate([0,-15.005,-15]) male_dovetail(height=65);
		}

		wrap();
		rotate([0,90,0]) wrap();
		rotate([-90,90,0]) wrap();
		rotate([0,45,180]) translate([0,-45,0]) tie_end();
		rotate([0,45,90]) translate([0,-45,0]) tie_end();
		rotate([-90,0,45]) translate([0,-45,0]) tie_end();

	}
	module corner() {
		difference(){
			added();
			taken();
		}
	};
    //added();
	rotate([45,0,0]) corner();
};

module full_corner(){
	module support_pillars(){
		
		translate([48-slot_translate/2,3,0]) cylinder(h=11,d=4);
		translate([48-slot_translate/2,-3,0]) cylinder(h=11,d=4);
		
		translate([39-slot_translate/2,18,24]) rotate([0,-40,0]) cylinder(h=5.2,d=4);
		translate([39-slot_translate/2,-18,24]) rotate([0,-40,0]) cylinder(h=5.2,d=4);
    
        // Secondary center support pillar
        translate([2.5,4,0]) cylinder(h=14.85,d=4);
	}
	if (support==true)
	{
		support_pillars();
		rotate([0,0,(360/3)*2]) support_pillars();
		rotate([0,0,(360/3)*1]) support_pillars();
        //center support
        cylinder(h=19.4,d1=12,d2=3);
	}
	difference(){
		translate([0,0,0]) rotate([0,-35,0]) basic_corner();
		union(){
			//cylinder(h=50, d=15);
			//translate([-20,0,0]) cylinder(h=50, d=7);
			//translate([10,17,0]) cylinder(h=50, d=7);
			//translate([10,-17,0]) cylinder(h=50, d=7);
			translate([0,0,-25]) cube([200,200,50], center=true);
		}
	}
}

//basic_corner();
full_corner();