include <include.scad>;
include <globals.scad>;

support = true;
//min number of units is 2
//unit size is 30mm
//max is however large your printer can print
units = 4;

module extention_base(length, support=true){
	
	module added(){
			translate([0,0,0]) cube([30,length,30]);
	}

	module subtracted(){
        translate([15,0,15]) rotate([0,45,0]) tie_end();
        translate([15,length,15]) rotate([0,45,0]) rotate([0,0,180]) tie_end();
        translate([15,-1,15]) rotate([-90,0,0]) cylinder(h=length+2, d=metal_rod_size,$fn=15);
        translate([15,-0.01,15]) rotate([-90,0,0]) cylinder(d1=metal_rod_size+1,d2=metal_rod_size,h=0.5,$fn=15);
        translate([15,length+0.01,15]) rotate([90,0,0]) cylinder(d1=metal_rod_size+1,d2=metal_rod_size,h=0.5,$fn=15);

        translate([15, -1, 15]){
            for (r = [0:4]) // two iterations, z = -1, z = 1
            {
                rotate([0,r*90,0]) translate([0,0,15]) rotate([-90,0,0])male_dovetail(height=length+2);
            }
        }

	} //subtracted
	difference(){
		added();
		subtracted();
	}
    //support
    if (support==true)
    {
        rotate([-90,0,0]) {
            translate([0,0,5/2]) cylinder(h=5, d=6, center=true);
            translate([30,0,5/2]) cylinder(h=5, d=6, center=true);
            translate([0,-30,5/2]) cylinder(h=5, d=6, center=true);
            translate([30,-30,5/2]) cylinder(h=5, d=6, center=true);
        }
    }
} //module extention



module extention(units=units, support=support){
    rotate([90,0,0]) extention_base(units*30, support=support);
}

module extention_center(length=120, stopper_position=60) {
    // leave a bit of gap
    l = length - 1;
    sp = stopper_position - 0.5;
    difference() {
        union() {
            intersection() {
                ridged_cylinder(d=metal_rod_size-0.1, h=l, r=2, $fn=15);
                chamfered_cylinder(metal_rod_size,l,1,$fn=15);
            }
            hull() {
                translate([0,0,sp]) cube_donut(metal_rod_size,0.5,rotation=45,$fn=15);
            }
        }
        cylinder(d=1,h=l,$fn=10);
    }
}

// 60cm extention
//extention(2);
//extention_center(length=60,stopper_position=60/2);

// 90cm extention
//extention(3);
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

