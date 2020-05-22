include <include.scad>;
include <globals.scad>;

support = true;
//min number of units is 2
//unit size is 30mm
//max is however large your printer can print
units = 4;
center_d = metal_rod_size;

// for side support
tip_size = 1.2;

module extention_base(length, support=true){
	
	module added(){
		translate([0,0,0])
        cube([30,length,30]);
	}

	module subtracted(){
        translate([15,0,15])
        rotate([0,45,0])
        tie_end();

        translate([15,length,15])
        rotate([0,45,0])
        rotate([0,0,180])
        tie_end();

        translate([15,-1,15])
        rotate([-90,0,0])
        cylinder(h=length+2, d=center_d,$fn=15);

        translate([15,-0.01,15])
        rotate([-90,0,0])
        cylinder(d1=center_d+1,d2=center_d,h=0.5,$fn=15);

        translate([15,length+0.01,15])
        rotate([90,0,0])
        cylinder(d1=center_d+1,d2=center_d,h=0.5,$fn=15);

        translate([15, -1, 15]){
            for (r = [0:4]) // two iterations, z = -1, z = 1
            {
                rotate([0,r*90,0])
                translate([0,0,15])
                rotate([-90,0,0])
                male_dovetail(height=length+2);
            }
        }
    } //subtracted

    module infill() {
        rotate([-90,0,0])
        translate([30/2,-30/2,0]) {
            for(i = [0:3]) {
                rotate([0,0,360/4*i])
                translate([5,30/2-2,0])
                cylinder(d=0.1,h=7);

                rotate([0,0,360/4*i])
                translate([-5,30/2-2,0])
                cylinder(d=0.1,h=7);
            }
        }
    }

	difference(){
		added();
		subtracted();
        translate([0,-1,0])
        infill();

        translate([0,length-6,0])
        infill();
	}
    //support
    if (support==true)
    {
        rotate([-90,0,0]) {
            translate([0,0,5/2])
            cylinder(h=5, d=6, center=true);

            translate([30,0,5/2])
            cylinder(h=5, d=6, center=true);

            translate([0,-30,5/2])
            cylinder(h=5, d=6, center=true);

            translate([30,-30,5/2])
            cylinder(h=5, d=6, center=true);
        }
    }
} //module extention



module extention(units=units, support=support){
    rotate([90,0,0])
    extention_base(units*30, support=support);
}

module extention_side(units=units, supports=support) {

    union() {
        difference() {
            extention_base(units*30, support=false);

            translate([30/2,0,5+0.2/2])
            cube([male_dove_max_width,units*30,0.2],center=true);
        }

        if (supports) {
            reduce = 4/units;
            for(i=[0:units]) {
                translate([tip_size/2,i*30+4/2-i*reduce,20/2])
                cube([tip_size,4,20],center=true);

                translate([30-tip_size/2,i*30+4/2-i*reduce,20/2])
                cube([tip_size,4,20],center=true);
            }
            translate([0,0,30/2-3])
            cube([0.5,units*30,7]);

            translate([30-0.5,0,30/2-3])
            cube([0.5,units*30,7]);
        }
    }
}

module extention_center(length=120, stopper_position=60) {
    wall = 0.8;
    d = center_d-slop;
    l = length - 1;

    module _star() {
        union() {
            rotate([72/2,0,0])
            cube([l,wall,d], center=true);

            rotate([-72/2,0,0])
            cube([l,wall,d], center=true);

            cube([l,d,wall], center=true);
        }
    }

    module _form() {
        intersection() {
            _star();
            rotate([0,90,0])
            cylinder(d=d,h=l,center=true,$fn=15);
        }
    }

    module _shell(wall=wall) {
        scaling = (d-2*wall)/d;
        difference() {
            hull()
            _form();

            scale([1,scaling,scaling])
            hull()
            _form();
        }
    }

    module stopper() {
        translate([-l/2+stopper_position,0,0])
        intersection() {
            rotate([0,90,0])
            cube_donut(d,0.7,rotation=45,$fn=15);

            scale([1,4,1])
            hull()
            _form();
        }
    }

    union() {
        _form();
        _shell();
        scale([1,0.6,0.6]) _shell(0.6*1/0.6);
        stopper();
    }
}

module extention_t(units1=4, units2=2, _offset=0, supports=support) {
    h = units1 * 30;

    union() {
        translate([-30/2,-units*30/2,0])
        extention_side(units=units, supports=supports);

        translate([-30/2,30/2+_offset,30-6])
        rotate([90,0,0])
        extention_base(units2*30+6, support=false);

        translate([-30/2,-30/2,0])
        cube([30,30,6]);
    }
}

// 60cm extention
//extention(2);
//extention_center(length=60,stopper_position=60/2);

// 90cm extention
extention(3);
//extention_center(length=90,stopper_position=90/2);

// 120cm extention
//extention();
//extention_center();

// 150cm extention
//extention(5);
//extention_center(length=150,stopper_position=150/2);

// 180cm extention
//extention(6);
//extention_center(length=180,stopper_position=180/2);

// centers for corner
//extention_center(length=90/2+30,stopper_position=30);
//extention_center(length=120/2+30,stopper_position=30);
//extention_center(length=150/2+30,stopper_position=30);
//extention_center(length=180/2+30,stopper_position=30);

// center 120cm / 60cm
//extention_center(length=180/2+60,stopper_position=60);

//extention_side(units=units, supports=support);

//extention_t();
