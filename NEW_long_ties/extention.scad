include <include.scad>;
include <globals.scad>;

support = true;
//min number of units is 2
//unit size is 30mm
//max is however large your printer can print
units = 4;

module extention_base(length){
	
	module added(){
			translate([0,0,0]) cube([30,length,30]);
	}

	module subtracted(){
        translate([15,0,15]) rotate([0,45,0]) tie_end();
        translate([15,length,15]) rotate([0,45,0]) rotate([0,0,180]) tie_end();
        translate([15,15,15]) rotate([90,0,0]) cylinder(h=5000, d= metal_rod_size, center=true,$fn=15);

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
} //module extention



module extention(units=units, support=support){
    rotate([90,0,0]) extention_base(units*30);

    //support
    if (support==true)
    {
        translate([0,0,5/2]) cylinder(h=5, d=6, center=true);
        translate([30,0,5/2]) cylinder(h=5, d=6, center=true);
        translate([0,-30,5/2]) cylinder(h=5, d=6, center=true);
        translate([30,-30,5/2]) cylinder(h=5, d=6, center=true);
    }
}

module extention_90_bend() {
    
    module extention_rotated() {
        intersection() {
            rotate([0,45,0]) translate([-15,0,-25]) extention(2);
            translate([0,-35,0]) cube([100,40,100]);
        }
    }
    extention_rotated();
    mirror([1,0,0]) extention_rotated();
}

// 120cm extention
extention();

// 150cm extention
//extention(5);

// 90cm extention
//extention(3);

//extention_90_bend();