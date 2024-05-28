include <include.scad>;
include <globals.scad>;

////// VARIABLES //////
support = true;
//min number of units is 2
//unit size is 30mm
//max is however large your printer can print
units = 4;
center_d = metal_rod_size;

// for side support
tip_size = 1.2;

////// VIEW //////

// 50cm extention
//extention(50/30);
//extention(50/30, tie_ends=false);
//extention_center(length=50, stopper_position=50/2);

// 60cm extention
//extention(2);
//extention_center(length=60, stopper_position=60/2);

// 90cm extention
//extention(3);
//extention_center(length=90, stopper_position=90/2);

// 120cm extention
extention();
//extention_center();

// 140cm extention
//extention(140/30);
//extention_center(length=140, stopper_position=140/2);

// 150cm extention
//extention(5);
//extention_center(length=150, stopper_position=150/2);

// 180cm extention
//extention(6);
//extention_center(length=180, stopper_position=180/2);

// centers for corner
//extention_center(
//    length=90/2 + 30, stopper_position=30
//);

//extention_center(
//    length=120/2 + 30, stopper_position=30
//);

//extention_center(
//    length=140/2 + 30, stopper_position=30
//);

//extention_center(
//    length=150/2 + 30, stopper_position=30
//);

//extention_center(
//    length=180/2 + 30, stopper_position=30
//);

// center 120cm / 60cm
//extention_center(length=180/2 + 60, stopper_position=60);

// 120mm side extention
//extention_side(units=units, supports=support);

//extention_t();

//extention_glue_peg();



////// MODULES //////
module extention_base(length, support=true, tie_ends=true) {

    function bridge_extra() = support ? 0.2 : 0;

	module added(){
        union() {
            cube([30, length, 30], center=true);

            if (!tie_ends) {
                for(i = [0:3]) {
                    rotate([0, i*90, 0])
                    translate([
                        30/2 - 4.5, length/2, 30/2 - 4.5
                    ])
                    cube([4.9, 2, 4.9], center=true);
                }
            }
        }
	}

	module subtracted(){
        if (tie_ends) {
            translate([0, -length/2, 0])
            rotate([0, 45, 0])
            tie_end(30, bridge_extra());

            translate([0, length/2, 0])
            rotate([0, 45, 0])
            rotate([0, 0, 180])
            tie_end(30, bridge_extra());
        } else {
            for(i = [0:3]) {
                rotate([0, i*90, 0]) {
                    translate([
                        30/2 - 4, -length/2, 30/2 - 4
                    ])
                    hull() {
                        cube([4, 10, 4], center=true);
                        cube(
                            [0.1, 14, 0.1],
                            center=true
                        );
                    }

                    translate([
                        30/2 - 4.5, -length/2, 30/2 - 4.5
                    ])
                    hull() {
                        cube([5, 2.4, 5], center=true);
                        cube([0.1, 5, 0.1], center=true);
                    }

                    translate([
                        30/2 - 4, length/2, 30/2 - 4
                    ])
                    hull() {
                        cube([4, 10, 4], center=true);
                        cube(
                            [0.1, 14, 0.1],
                            center=true
                        );
                    }
                }
            }
        }

        translate([0, -length/2 - 1, 0])
        rotate([-90, 0, 0])
        cylinder(h=length + 2, d=center_d, $fn=15);

        translate([0, -length/2 - 0.01, 0])
        rotate([-90, 0, 0])
        cylinder(d1=center_d + 1, d2=center_d, h=0.5, $fn=15);

        translate([0, length/2 + 0.01, 0])
        rotate([90, 0, 0])
        cylinder(d1=center_d + 1, d2=center_d, h=0.5, $fn=15);

        translate([0, -1, 0]){
            // two iterations, z = -1, z = 1
            for (r = [0:3]) {
                rotate([0, r*90, 0])
                translate([0, -length/2, 15.01])
                rotate([-90, 0, 0])
                male_dovetail(height=length + 2);
            }
        }
    } //subtracted

    // custom infill to fortify the tie ends
    module infill() {
        if (tie_ends) {
            rotate([-90, 0, 0])
            for(i = [0:3]) {
                rotate([0, 0, 360/4 * i])
                translate([5, 30/2 - 2, 0])
                cylinder(d=0.1, h=8);

                rotate([0, 0, 360/4 * i])
                translate([-5, 30/2 - 2, 0])
                cylinder(d=0.1, h=8);
            }
        }
    }
    
    difference(){
        added();
        subtracted();

        translate([0, -length/2 - 1, 0])
        infill();

        translate([0, length/2 - 7, 0])
        infill();
    }

    //support
    if ((support==true) && (tie_ends==true)) {
        translate([0, -length/2, 0])
        bow_support();
    }
} //module extention


module extention(
    units=units, support=support, tie_ends=true) {

    rotate([90, 0, 0])
    extention_base(
        units*30, support=support, tie_ends=tie_ends
    );
}

module extention_side(units=units, supports=support) {

    l = units*30;

    union() {
        difference() {
            extention_base(l, support=false);

            // dove grooves tuning
            translate([0, 0, -30/2 + 5 + 0.2/2])
            cube([
                male_dove_max_width, l + 1, 0.23
            ], center=true);

            translate([30/2, (l + 1)/2, 0.15])
            rotate([90, -90, 0])
            male_dovetail(l + 1);

            translate([-30/2, (l + 1)/2, 0.15])
            rotate([90, 90, 0])
            male_dovetail(l + 1);

        }

        if (supports) {
            support_unit =
                units/floor(units)*30 - 4/floor(units);

            x_off = 30/2 - tip_size/2;

            translate([0, -l/2, 0])
            for(i=[0:units]) {
                y_off = 4/2 + i*support_unit;

                #translate([-x_off, y_off, -30/2 + 20/2])
                cube([tip_size, 4, 20], center=true);

                #translate([x_off, y_off, -30/2 + 20/2])
                cube([tip_size, 4, 20], center=true);
            }
            translate([-30/2, -l/2, -3])
            cube([0.5, l, 7]);

            translate([30/2 - 0.5, -l/2, -3])
            cube([0.5, l, 7]);

            translate([-30/2 + 4/2, l/2 - 5/2, -30/2 + 0.2/2])
            cube([4, 5, 0.2], center=true);

            translate([30/2 - 4/2, l/2 - 5/2, -30/2 + 0.2/2])
            cube([4, 5, 0.2], center=true);

            translate([
                -30/2 + 4/2, -l/2 + 5/2, -30/2 + 0.2/2
            ])
            cube([4, 5, 0.2], center=true);

            translate([
                30/2 - 4/2, -l/2 + 5/2, -30/2 + 0.2/2
            ])
            cube([4, 5, 0.2], center=true);
        }
    }
}

module extention_center(length=120, stopper_position=60) {
    wall = 0.8;
    d = center_d - slop;
    l = length - 1;

    module _star() {
        union() {
            rotate([72/2, 0, 0])
            cube([l, wall, d], center=true);

            rotate([-72/2, 0, 0])
            cube([l, wall, d], center=true);

            cube([l, d, wall], center=true);
        }
    }

    module _form() {
        intersection() {
            _star();

            rotate([0, 90, 0])
            cylinder(d=d, h=l, center=true, $fn=15);
        }
    }

    module _shell(wall=wall) {
        scaling = (d - 2*wall)/d;
        difference() {
            hull()
            _form();

            scale([1, scaling, scaling])
            hull()
            _form();
        }
    }

    module stopper() {
        translate([-l/2 + stopper_position, 0, 0])
        intersection() {
            rotate([0, 90, 0])
            cube_donut(d, 0.7, rotation=45, $fn=15);

            scale([1, 4, 1])
            hull()
            _form();
        }
    }

    union() {
        _form();
        _shell();

        scale([1, 0.6, 0.6])
        _shell(0.6 * 1/0.6);

        stopper();
    }
}

module extention_t(
    units1=units, units2=2, _offset=0, supports=support
) {

    h = units1 * 30;

    union() {
        difference() {
            translate([0, 0, 30/2])
            extention_side(units=units1, supports=supports);

            translate([0, _offset, 23])
            cylinder(d=10, h=20, $fn=20);

            translate([0, _offset, 25 + 5.5/2])
            cube([30, 8, 5.5], center=true);

            translate([0, _offset, 25 + 5.5/2])
            cube([8, 30, 5.5], center=true);

            translate([0, _offset - 30/2, -1])
            male_dovetail(35);

            translate([0, _offset - 30/2, 5])
            hull() {
                male_dovetail(2);

                translate([0, 5/2, 0.2/2])
                cube([8, 5, 0.2], center=true);
            }

            translate([0, _offset + 30/2, -1])
            rotate([0, 0, 180])
            male_dovetail(35);

            translate([0, _offset + 30/2, 5])
            rotate([0, 0, 180])
            hull() {
                male_dovetail(2);

                translate([0, 5/2, 0.2/2])
                cube([8, 5, 0.2], center=true);
            }

        }

        translate([
            0, _offset, (units2*30 + 7)/2 + 30 - 7
        ])
        difference() {
            rotate([90, 0, 0])
            extention_base(
                units2*30 + 7, support=false
            );

            translate([
                0, -16, -(units2*30 + 7)/2 + 7
            ])
            rotate([-90, 0, 0])
            male_dovetail(6);

            translate([
                0, 10, -(units2*30 + 7)/2 + 7
            ])
            rotate([-90, 0, 0])
            male_dovetail(6);
        }
    }
}

module extention_glue_peg() {
    cube([4 - slop, 10, 4 - 0.2], center=true);
}
