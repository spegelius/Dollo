
include <include.scad>;
include <globals.scad>;
use <long_tie.scad>;
use <mockups.scad>;

$fn=30;

module _frame_clip(h=20) {
    intersection() {
        union() {
            difference() {
                translate([0,-11.5,0])
                cube([35,23,h],center=true);

                cube([30,30,60],center=true);

                translate([0,-15,-30])
                rotate([0,0,180])
                male_dovetail();
            }
            translate([15,0,0])
            rotate([0,0,5])
            cube([4,5,h],center=true);

            translate([-15,0,0])
            rotate([0,0,-5])
            cube([4,4.8,h],center=true);
        }
        translate([0,-11.5])
        chamfered_cube(35,23,20,1,center=true);
    }
}

module adapter_mks_sbase_box() {
    
    h = 20;

    difference() {
        union() {
            _frame_clip(h);

            translate([-80,-18,-10])
            rotate([90,0,0])
            chamfered_cube_side(70,10,5,3);

            translate([-24,-20,-10])
            hull() {
                rotate([0,0,35])
                cube([10,1,5]);

                translate([7.5,1/2,0])
                cylinder(d=1,h=5);
            }
        }
        translate([-10,-24,-5])
        rotate([-90,0,0])
        cylinder(d=2.8,h=8,$fn=20);

        translate([-75,-24,-5])
        rotate([-90,0,0])
        cylinder(d=2.8,h=8,$fn=20);
    }
}

module adapter_titan() {
    
    module _titan_body() {
        hull() {
            translate([-46.5/2+1/2,-4/2,30/2])
            cube([1.5,40.5,30],center=true);

            translate([-46.5/2+1/2+4,0,30/2])
            cube([1.5,44.5,30],center=true);

            translate([46.5/2-1/2,10/2,30/2])
            cube([1.5,34.5,30],center=true);

            translate([46.5/2-16/2,-44/2+16/2,0])
            cylinder(d=16.5,h=30,$fn=80);
        }
        translate([-46.5/2+7+27/2,44/2-7-27/2,0]) {
            for(i=[0:3]) {
                rotate([0,0,360/4*i])
                translate([motor_bolt_hole_distance/2,
                       -motor_bolt_hole_distance/2,
                       0])
                cylinder(d=3.5,h=100,center=true,$fn=30);
            }
            cylinder(d=27,h=100,center=true,$fn=40);
        }
    }

    module _mount() {
        difference() {
            union() {
                hull() {
                    cube([32,32,6]);
                
                    translate([41,5,0])
                    rotate([0,0,5])
                    cube([50,48,6]);
                }
                cube([32,32,20]);

                hull() {
                    translate([35,36,0])
                    cube([6,10,1]);

                    translate([32-6,32-6,20-1])
                    cube([6,6,1]);

                }
            }

            translate([-1,-1,-1])
            cube([32-8+1,32-8+1,22]);

            translate([32-8,32-8-15,0])
            rotate([0,0,-90])
            male_dovetail(height=80);

            translate([32-8-15,32-8,0])
            rotate([0,0,0]) male_dovetail(height=80);

            translate([64,31,33])
            rotate([0,180,5])
            _titan_body();

            translate([88,52,-1])
            rotate([0,0,45+5])
            cube([10,10,10]);
        }
    }

    _mount();

    %translate([64,31,33])
    rotate([0,180,5])
    mock_titan();
}

module ramps_mount_adapter() {
    module ear() {
        hull() {
            translate([0,0,0])
            cube([5,15,0.1]);

            translate([20,7.5,0])
            cylinder(d=15,h=0.1);

            translate([0,3.5,3.9])
            cube([5,8,0.1]);

            translate([20,7.5,3.9])
            cylinder(d=8,h=0.1);
        }
    }

    module ears() {
        difference() {
            hull() {
                ear();

                mirror([1,0,0])
                ear();
            }
            translate([20,7.5,0])
            cylinder(d=bolt_hole_dia,h=7);

            translate([20,7.5,1.8])
            M3_nut();

            translate([-20,7.5,0])
            cylinder(d=bolt_hole_dia,h=7);

            translate([-20,7.5,1.8])
            M3_nut();
        }
    }

    // for thing: https://www.thingiverse.com/thing:861360
    // drill holes to the box and use 3mm screws & nuts
    difference() {
        union() {
            translate([0,3.5,0])
            cube([20, box_length-27, 7.5]);

            translate([10, box_length-20-15, 0])
            ears();

            translate([10, 0, 0])
            ears();
        }
        translate([10, 0, 7.5])
        rotate([-90,0,0])
        male_dovetail(box_length);
    }
}

module adapter_dove_m3_28() {
    difference() {
        translate([0,0,0]) long_tie(34);
        translate([0,0,5/2+0.6]) cube([2.5,35,5],center=true);
        translate([0,28/2,0]) cylinder(d=2.8,h=5,$fn=20);
        translate([0,-28/2,0]) cylinder(d=2.8,h=5,$fn=20);
        
    }
}

module adapter_dove_m3_15() {
    difference() {
        translate([0,0,0]) long_tie(15);
        translate([0,0,5/2+0.6]) cube([2.5,16,5],center=true);
        cylinder(d=2.8,h=5,$fn=20);
    }
}


module adapter_shy_rockabilly() {

    // adapter for this extruder: https://www.thingiverse.com/thing:1223730

    module fixing_plate() {
        union () {
            translate([8/2,5,20/2])
            cube([8,36,20], center = true);

            translate([23/2+8,15+8/2,20/2])
            cube([23, 8, 20], center=true);

            translate([10,45,0])
            rotate([0,0,-20])
            difference() {
                hull() {
                    translate([-15/2,0,5/2])
                    cube([15, 46, 5], center=true);

                    translate([13,-20,5/2])
                    rotate([0,0,20])
                    cube([25, 1, 5], center=true);
                }
                translate([-10,-15,0])
                cylinder(d=m4_bolt_hole_dia, h=20);

                translate([-10,14,0])
                cylinder(d=m4_bolt_hole_dia, h=20);

                translate([-24,-22,0])
                rotate([0,0,45])
                cube([30,30,30]);
            }
        }
    }
    difference() {
        fixing_plate();
        translate([8,0,0])
        rotate([0,0,90]) male_dovetail(height=80);

        translate([8+15,15,0])
        rotate([0,0,0]) male_dovetail(height=80);
    }
}

module adapter_shy_rockabilly2() {

    // adapter for this extruder: https://www.thingiverse.com/thing:1223730
    
    // different angle

    module fixing_plate() {
        union () {
            translate([8/2,5,20/2])
            cube([8,36,20], center = true);

            translate([23/2+8,15+8/2,20/2])
            cube([23, 8, 20], center=true);

            translate([10,27,0])
            rotate([0,0,-45])
            difference() {
                hull() {
                    translate([-16/2,0,7/2])
                    cube([16, 44, 7], center=true);

                    #translate([8,1,7/2])
                    rotate([0,0,45])
                    cube([25, 1, 7], center=true);
                }
                translate([-10,-14.5,0]) {
                    translate([0,0,3.4])
                    cylinder(d=m4_bolt_hole_dia, h=20);
                    rotate([0,0,360/6/2])
                    M4_nut(cone=false);
                }

                translate([-10,14.5,0]) {
                    translate([0,0,3.4])
                    cylinder(d=m4_bolt_hole_dia, h=20);
                    rotate([0,0,360/6/2])
                    M4_nut(cone=false);
                }

                translate([-26,-22,0])
                rotate([0,0,45])
                cube([30,30,30]);
            }
        }
    }
    difference() {
        fixing_plate();
        translate([8,0,0])
        rotate([0,0,90]) male_dovetail(height=80);

        translate([8+15,15,0])
        rotate([0,0,0]) male_dovetail(height=80);
    }
}

module adapter_shy_rockabilly3() {

    // adapter for this extruder: https://www.thingiverse.com/thing:1223730
    
    // different angle

    module fixing_plate() {
        union () {
            translate([8/2,5,20/2])
            cube([8,36,20], center = true);

            translate([23/2+8,15+8/2,20/2])
            cube([23, 8, 20], center=true);

            translate([22,23,0])
            rotate([0,0,-90])
            difference() {
                hull() {
                    translate([-16/2,0,7/2])
                    cube([16, 44, 7], center=true);

                    translate([2,-7,7/2])
                    rotate([0,0,90])
                    cube([25, 1, 7], center=true);
                }
                translate([-10,-14.5,0]) {
                    translate([0,0,3.4])
                    cylinder(d=m4_bolt_hole_dia, h=20);
                    rotate([0,0,360/6/2])
                    M4_nut(cone=false);
                }

                translate([-10,14.5,0]) {
                    translate([0,0,3.4])
                    cylinder(d=m4_bolt_hole_dia, h=20);
                    rotate([0,0,360/6/2])
                    M4_nut(cone=false);
                }

                translate([-26,-22,0])
                rotate([0,0,45])
                cube([30,30,30]);
            }
        }
    }
    difference() {
        fixing_plate();
        translate([8,0,0])
        rotate([0,0,90]) male_dovetail(height=80);

        translate([8+15,15,0])
        rotate([0,0,0]) male_dovetail(height=80);
    }
}

module airtrippers_fixing_pin(pin_size=6.4) {
    difference() {
        union() {
            cylinder(3, r=pin_size/2);
            hull() {
                translate([0,0,3]) cylinder(0.5, r=pin_size/2);
                translate([0,0,3.5]) cylinder(1, r=pin_size/2+0.5);
                translate([0,0,4.5]) cylinder(1, r=2);
            }
        }
        cube([8,1,12], center=true);
    }
}

module airtrippers_fixing_plate(pin_distance, pin_size) {
    difference() {
        union () {
            translate([-14.5,0,10]) cube([7,74,20], center = true);
            translate([-14.5,-74/2+20/2,10]) cube([7,20,50], center = true);
        }
		union() {
			// fixing plate cutout
			translate([-16,36,0]) rotate([45,0,0]) cube([16,16,7], center = true);
			translate([-16,-35,-16]) rotate([135,0,0]) cube([16,16,7], center = true);
			translate([-16,36,20]) rotate([135,0,0]) cube([16,16,7], center = true);
			translate([-16,-19,-16]) rotate([45,0,0]) cube([16,16,7], center = true);
            
            translate([-16,-19,36]) rotate([135,0,0]) cube([16,16,7], center = true);
            translate([-16,-35,36]) rotate([45,0,0]) cube([16,16,7], center = true);
		}
	}
	translate([-18,-pin_distance/2,10]) rotate([0,270,0]) airtrippers_fixing_pin(pin_size);
	translate([-18,pin_distance/2,10]) rotate([0,270,0]) airtrippers_fixing_pin(pin_size);

}

module adapter_airtrippers_bowden_extruder(pin_distance=61, pin_size=6.4) {
    difference() {
        translate([0,0,-11]) rotate([0,90,0]) airtrippers_fixing_plate(pin_distance, pin_size);
        translate([10,40,0]) rotate([90,0,0]) male_dovetail(height=80);
        translate([40,-27,0]) rotate([90,0,-90]) male_dovetail(height=80);
    }
}

//adapter_mks_sbase_box();
adapter_titan();
//ramps_mount_adapter();
//adapter_dove_m3_28();
//adapter_dove_m3_15();
//adapter_shy_rockabilly();
//adapter_shy_rockabilly2();
//adapter_shy_rockabilly3();
//adapter_airtrippers_bowden_extruder();