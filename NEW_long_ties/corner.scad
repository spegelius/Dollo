include <include.scad>;
include <globals.scad>;

use <extention.scad>;

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

module full_corner(support=support, extra_stiff=extra_stiff){
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

module corner_90(corner_len=30, extra_stiff=false, support=support) {

    l = corner_len + 40;    

    module extention_rotated() {
        parts = ceil(l/30);
        diff = l%30;
        
        function get_diff(diff) = diff > 0 ? 30-diff : 0;
        
        intersection() {
            rotate([0,45,0]) translate([-17,0,-23-get_diff(diff)]) extention(parts);
            translate([0,-35,0]) cube([100,40,100]);
        }
    }
    difference() {
        union() {
            extention_rotated();
            mirror([1,0,0]) extention_rotated();
            if (extra_stiff) {
                h = sqrt((corner_len*corner_len)/2);
                echo(h);
                translate([0,-30+7/2,h+15]) cube([2*h-7,7,10],center=true);
                translate([0,0-7/2,h+15]) cube([2*h-7,7,10],center=true);
            }
        }
        
        translate([0,-30/2,0]) rotate([0,45,0]) translate([-2,0,0]) cylinder(d=21,h=34,$fn=30,center=true);
        translate([0,-30/2,0]) rotate([0,-45,0]) translate([2,0,0]) cylinder(d=21,h=34,$fn=30,center=true);
        
        translate([13,0.01,-10]) rotate([0,45,180]) male_dovetail(20);
        translate([-13,0.01,-10]) rotate([0,-45,180]) male_dovetail(20);

        translate([-12.83,-30,-10]) rotate([0,45,0]) male_dovetail(20);
        translate([12.83,-30,-10]) rotate([0,-45,0]) male_dovetail(20);

        translate([12.83,-15,-10]) rotate([0,-45,0]) rotate([0,0,180]) cylinder(d=metal_rod_size,h=20,$fn=15);
        translate([-12.83,-15,-10]) rotate([0,45,0]) cylinder(d=metal_rod_size,h=20,$fn=15);

    }

    // supports
    if (support==true)
    {
        cylinder(d=4,h=7);
        translate([0,-30,0]) cylinder(d=4,h=7);
    }
    %translate([0,-30/2,0]) rotate([0,45,0]) translate([-2,0,11.8]) M8_nut(cone=false);
    %translate([0,-30/2,0]) rotate([0,-45,0]) translate([2,0,11.8]) M8_nut(cone=false);
}

module debug_90() {
    intersection() {
        corner_90();
        translate([0,-31,0]) cube([60,40,50]);
    }
}


//full_corner(support=support, extra_stiff=extra_stiff);

//corner_90(extra_stiff=false);
//corner_90(extra_stiff=true);

//corner_90(corner_len=20, extra_stiff=false);
corner_90(corner_len=20, extra_stiff=true);
