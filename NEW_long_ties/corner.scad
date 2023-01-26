include <include.scad>;
include <globals.scad>;

use <extention.scad>;

////// VARIABLES //////
//if you can do pretty far over hangs, like an SLA printer or something then take this off by setting it to false.
support = true;
slot_translate = .5;
rod_size = .5;
cube_outset = 0.001;

extra_stiff = true;


////// VIEW //////
//full_corner();
//full_corner(support=true);
//full_corner(support=false, extra_stiff=true);
//full_corner(support=true, extra_stiff=true);
full_corner(
    support=true, extra_stiff=true,
    side_support=true
);

//corner_90(extra_stiff=false);
//corner_90(extra_stiff=true);

// for bed carriage
//corner_90(corner_len=20, extra_stiff=false);
//corner_90(corner_len=20, extra_stiff=true);
//corner_90(corner_len=70, extra_stiff=true);


////// MODULES //////
module basic_corner(
    w=obj_leg + 15, extra_stiff=false
) {

    w1 = obj_leg + cube_outset;
    w2 = w + obj_leg;

	module added(){

        union() {
            translate([0, 0, w2/2 - 15])
            rotate([90, 0, 0])
            extention_base(w2, support=false);

            translate([0, w2/2 - 15, 0])
            extention_base(w2, support=false);

            translate([w2/2 - 15, 0, 0])
            rotate([0, 0, 90])
            extention_base(w2, support=false);

            if (extra_stiff) {
                w = 7;

                //translate([15, -15 + w/2, 20])
                rotate([0, 45, 0])
                translate([0, -15 + w/2,25])
                hull() {
                    translate([0, 0, 20/2 - 1/2])
                    cube([40, w, 1], center=true);

                    translate([0, 0,-20/2 + 1/2])
                    cube([10, w, 1], center=true);
                }

                rotate([-45, 0, 0])
                translate([-15 + w/2, 0, 25])
                hull() {
                    translate([0, 0, 20/2 - 1/2])
                    cube([w, 40, 1], center=true);

                    translate([0, 0, -20/2 + 1/2])
                    cube([w, 10, 1], center=true);
                }

                rotate([0, 0, -45])
                translate([0, 25, -15 + w/2])
                hull() {
                    translate([0, 20/2 - 1/2, 0])
                    cube([40, 1, w], center=true);

                    translate([0, -20/2 + 1/2, 0])
                    cube([10, 1, w], center=true);
                }

                //translate([15, 15, 15])
                //sphere(d=15, $fn=40);

                hull() {
                    translate([15, 15 - w/2, 15])
                    rotate([0, 45, 0])
                    cube([10, w, 10], center=true);

                    translate([15 - w/2, 15, 15])
                    rotate([-45, 0, 0])
                    cube([w, 10, 10], center=true);

                    translate([15, 15, 15 - w/2])
                    rotate([0, 0, -45])
                    cube([10, 10, w], center=true);
                }
            }
        }
	}

	module taken(){
		cylinder(d=8.5, h=obj_leg*5, center=true);

		rotate([0, 90, 0])
        cylinder(d=8.5, h=obj_leg*5, center=true);

		rotate([90, 0, 0])
        cylinder(d=8.5, h=obj_leg*5, center=true);

		cylinder(d=23, h=28, center=true);

        rotate([0, 90, 0])
        cylinder(d=23, h=28, center=true);

		rotate([90, 0, 0])
        cylinder(d=23, h=28, center=true);

		module wrap(){
			translate([0, -15.005, 0])
            male_dovetail(height=50);

			rotate([0, 0, 90])
            translate([0, -15.005, -15])
            male_dovetail(height=65);

			rotate([0, 0, 180])
            translate([0, -15.005, -15])
            male_dovetail(height=65);

			rotate([0, 0, -90])
            translate([0, -15.005, -15])
            male_dovetail(height=65);
		}

        wrap();

        rotate([0, 90, 0])
        wrap();

        rotate([-90, 90, 0])
        wrap();
	}

	module corner() {
		difference(){
			added();
			taken();
		}
	};
    //added();
	rotate([45, 0, 0])
    corner();
};

module full_corner(
    w=obj_leg, support=false,
    extra_stiff=false, side_support=false
) {

	module support_pillars(){
		translate([48 - slot_translate/2, 3, 0])
        cylinder(h=11, d=4);

		translate([48 - slot_translate/2, -3, 0])
        cylinder(h=11, d=4);

		translate([39 - slot_translate/2, 18, 24])
        rotate([0, -40, 0])
        cylinder(h=5.2, d=4);

		translate([39 - slot_translate/2, -18, 24])
        rotate([0, -40, 0])
        cylinder(h=5.2, d=4);

        // Secondary center support pillar
        translate([2.5, 4, 0])
        cylinder(h=14.85, d=4);
	}

	module supports() {
		support_pillars();

		rotate([0, 0, (360/3)*2])
        support_pillars();

		rotate([0, 0, (360/3)*1])
        support_pillars();

        //center support
        difference() {
            cylinder(h=17.4, d1=12, d2=2);

            cylinder(h=16.4, d1=11, d2=1);
        }
	}

    module side_support() {
        w = 0.5;

        for (i = [0:2]) {
            rotate([0, 0, i*360/3]) {

                hull() {
                    translate([18/2 + 15.4, -12.35, 0.1/2])
                    cube([18, w, 0.1], center=true);

                    translate([1/2 + 42, -12.35, 18.4])
                    cube([1, w, 1], center=true);
                }

                hull() {
                    translate([18/2 + 15.4, 12.35, 0.1/2])
                    cube([18, w, 0.1], center=true);

                    translate([1/2 + 42, 12.35, 18.4])
                    cube([1, w, 1], center=true);
                }

                hull() {
                    translate([8/2 + 35.8, 0, 0.1/2])
                    cube([8, w, 0.1], center=true);

                    translate([1/2 + 43.95, 0, 5.4])
                    cube([1, w, 1], center=true);
                }
            }
        }
    }

    // wonky math
    ry = atan(1/sqrt(2));
    
	difference() {
        union() {
            translate([0, 0, 0])
            rotate([0, -ry, 0])
            basic_corner(w, extra_stiff=extra_stiff);

            if (support) {
                supports();
            }

            if (side_support) {
                side_support();
            }
        
        }

		union(){
			//cylinder(h=50, d=15);
			//translate([-20,0,0]) cylinder(h=50, d=7);
			//translate([10,17,0]) cylinder(h=50, d=7);
			//translate([10,-17,0]) cylinder(h=50, d=7);
			translate([0, 0, -25])
            cube([200, 200, 50], center=true);
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
            rotate([0, 45, 0])
            translate([
                30/2 - 17, 0,
                (parts*30)/2 - 23 - get_diff(diff)
            ])
            extention(parts);

            translate([0, -40/2, 0])
            cube([100, 40, 100]);
        }
    }
    
    module stiffener(length) {
        //cube([length, 7, 10], center=true);
        rotate([0, 90, 0])
        chamfered_cube_side(
            10, 7, length, 3, center=true
        );
    }

    difference() {
        s_h = sqrt((corner_len*corner_len)/2);
        s_l = 2*s_h-7;
        union() {
            extention_rotated();

            mirror([1, 0, 0])
            extention_rotated();

            if (extra_stiff) {
                translate([0, 30/2 - 7/2, s_h + 15])
                stiffener(s_l);

                translate([0, -30/2 + 7/2, s_h + 15])
                stiffener(s_l);

                if (s_h > 30) {
                    h2 = s_h-5;
                    translate([0, -30/2 + 7/2,22 + h2/2])
                    chamfered_cube_side(
                        10, 7, h2, 3, center=true
                    );
                    
                    translate([0, 30/2 - 7/2, 22 + h2/2])
                    chamfered_cube_side(
                        10, 7, h2, 3, center=true
                    );
                }
            }
        }
        
        if (extra_stiff) {
            translate([0, -30/2 + 7/2, s_h + 15 + 2])
            cube([s_l + 10, 0.1, 0.4], center=true);

            translate([0, -30/2 + 7/2, s_h + 15])
            cube([s_l + 12, 0.1, 0.4], center=true);

            translate([0, -30/2 + 7/2, s_h + 15 - 2])
            cube([s_l + 20, 0.1, 0.4], center=true);

            translate([0, 30/2 - 7/2, s_h + 15 + 2])
            cube([s_l + 10, 0.1, 0.4], center=true);

            translate([0, 30/2 - 7/2, s_h + 15])
            cube([s_l + 12, 0.1, 0.4], center=true);

            translate([0, 30/2 - 7/2, s_h + 15 - 2])
            cube([s_l + 20, 0.1, 0.4], center=true);
        }

        rotate([0, 45, 0])
        translate([-2, 0, 0])
        cylinder(d=23, h=34, $fn=30, center=true);

        rotate([0, -45, 0])
        translate([2, 0, 0])
        cylinder(d=23, h=34, $fn=30, center=true);

        translate([13, 30/2 + 0.01, -10])
        rotate([0, 45, 180])
        male_dovetail(20);

        translate([-13, 30/2 + 0.01, -10])
        rotate([0, -45, 180])
        male_dovetail(20);

        translate([-12.83, -30/2, -10])
        rotate([0, 45, 0])
        male_dovetail(20);

        translate([12.83, -30/2, -10])
        rotate([0, -45, 0])
        male_dovetail(20);

        translate([12.83, 0, -10])
        rotate([0, -45, 0])
        rotate([0, 0, 180])
        cylinder(d=metal_rod_size, h=20, $fn=15);

        translate([-12.83, 0, -10])
        rotate([0, 45, 0])
        cylinder(d=metal_rod_size, h=20, $fn=15);

        translate([0, 0, 16])
        hull() {
            translate([0, 0, 5])
            cube([6, 6, 0.1], center=true);

            cube([5, 13, 0.1], center=true);
        }
    }

    // supports
    if (support==true)
    {
        translate([0, 30/2, 0])
        cylinder(d=4, h=7.5);

        translate([0, -30/2, 0])
        cylinder(d=4, h=7.5);
    }
    %rotate([0, 45, 0])
    translate([-2, 0, 11.8])
    M8_nut(cone=false);

    %rotate([0, -45, 0])
    translate([2, 0, 11.8])
    M8_nut(cone=false);
}

module debug_90() {
    intersection() {
        corner_90();

        translate([0, -31, 0])
        cube([60, 40, 50]);
    }
}
