////// INCLUDES //////
include <globals.scad>;
include <include.scad>;

use <long_bow_tie.scad>;
use <mockups.scad>;

////// VARIABLES //////
psu_height = 50;
psu_width = 114;

psu_cover_width = 119+2*slop;
psu_cover_height = 55+2*slop;

atx_psu_width = 150+2*slop;
atx_psu_height = 86+2*slop;

atx_psu_cover_width = atx_psu_width+5+2*slop;
atx_psu_cover_height = atx_psu_height+2+slop;

thickness = 8;

bolt_hole_down = 11.5;
bolt_hole_up = 13;

////// VIEW //////
//view_proper();
//view_proper_atx();
//view_proper_side_mount();

// old vers
//psu_clips();
//clip();

// ATX
//atx_psu_cover();
//rotate([90,0,0]) front_atx();
//rotate([90,0,0]) back_atx();
clip_extension();

// new
//side_clip1();
//side_clip2();

////// MODULES //////
module mock_psu() {
    cube([psu_width, 220, psu_height]);
}

module mock_atx_psu(holes=true, slop=0) {
    w = atx_psu_width;
    h = atx_psu_height;

    color("grey") {
        if (holes) {
            minus_atx_psu_holes() {
                translate([-w/2,0.01,0])
                cube([w, 140, h]);
            }
        } else {
            translate([-w/2,0,0])
            cube([w, 140, h]);
        }
    }
}

module minus_atx_psu_holes(hole=3.2) {
    difference() {
        children();
        translate([-138/2,0,6])
        rotate([-90,0,0])
        cylinder(d=hole, h=5, $fn=30);

        translate([138/2,0,6])
        rotate([-90,0,0])
        cylinder(d=hole, h=5, $fn=30);

        translate([138/2,0,6+64])
        rotate([-90,0,0])
        cylinder(d=hole, h=5, $fn=30);

        translate([-150/2+30,0,atx_psu_height-6])
        rotate([-90,0,0])
        cylinder(d=hole, h=5, $fn=30);
    }
}

module _front(w, h, dove_pos=26) {
    difference() {
        cube([w+12, thickness, h+12], center=true);
        cube([w, thickness+1, h], center=true);
    }
    difference() {
        translate([-w/2+25/2,0,h/2+(dove_pos+8)/2])
        hull() {
            cube([25,8,dove_pos+8],center=true);

            translate([0,0,-(dove_pos+8)/2+1/2])
            cube([33,8,1],center=true);
        }

        translate([-w/2+27,thickness/2, h/2+dove_pos])
        rotate([0,90,180])
        male_dovetail(30);
    }
    difference() {
        translate([w/2-25/2,0,h/2+(dove_pos+8)/2])
        hull() {
            cube([25,8,dove_pos+8],center=true);

            translate([0,0,-(dove_pos+8)/2+1/2])
            cube([33,8,1],center=true);
        }

        translate([w/2+2,thickness/2, h/2+dove_pos])
        rotate([0,90,180])
        male_dovetail(30);
    }
}

module front() {
    _front(psu_cover_width, psu_cover_height);
}

module front_atx() {
    _front(atx_psu_cover_width, atx_psu_height+0.4, 18);
}

module _back(w,h) {
    difference() {
        cube([w+12, thickness, h+12], center=true);
        cube([w, thickness+1, h], center=true);
    }
}

module back() {
    union() {
        _back(psu_width, psu_height);
        difference() {
            translate([psu_width/2-0.5+2*slop,-thickness/2,psu_height/2]) cube([8,15,35]);
            translate([psu_width/2+7.5+2*slop,-thickness/2-1,psu_height/2+28.5]) rotate([0,90,90]) male_dovetail(17);
        }
    }
}

module back_atx() {
    union() {
        _back(atx_psu_width, atx_psu_height);

        difference() {
            translate([atx_psu_width/2-2,
                    -thickness/2,atx_psu_height/2])
            cube([8,15,27]);

            translate([atx_psu_width/2+7.5+2*slop,
                    -thickness/2-1,atx_psu_height/2+18])
            rotate([0,90,90])
            male_dovetail(17);
        }
    }
}

// unused
module clip() {
    c_len = 20;
    rotate([-90,0,0]) difference() {
        union() { 
            translate([0,-c_len/2,-scaled_male_dove_depth()]) long_bow_tie_split(c_len);
            translate([11,-c_len/2,-5-scaled_male_dove_depth()]) long_bow_tie_split(c_len);
            translate([-2.5,-c_len,-scaled_male_dove_depth()]) cube([16,c_len,scaled_male_dove_depth()]);
            translate([8.9,-c_len,-scaled_male_dove_depth()-5]) cube([3,c_len,scaled_male_dove_depth()]);
        }
        translate([11-slop,-c_len-1,-10]) cube([5,c_len+2,11]);
    }
}

module atx_psu_cover() {
    l = 45;
    nob_y = l/2-2;

    module _stopper(l=12) {
        hull() {
            cube([1,4,l],center=true);

            translate([1.5,0,0])
            cube([1,2,l-3],center=true);
        }
    }

    rotate([90,0,0]) 
    minus_atx_psu_holes(3.7) {
        translate([0,45/2+0.01,atx_psu_cover_height/2])
        difference() {
            union() {
                cube([atx_psu_cover_width,l,atx_psu_cover_height],
                        center=true);

                translate([-atx_psu_cover_width/2,nob_y,0])
                mirror([1,0,0])
                _stopper();

                translate([-atx_psu_cover_width/2,nob_y-thickness-4,0])
                mirror([1,0,0])
                _stopper(20);

                translate([atx_psu_cover_width/2,nob_y,0])
                _stopper();

                translate([atx_psu_cover_width/2,nob_y-thickness-4,0])
                _stopper(20);
            }
            translate([0,2.5,0])
            cube([atx_psu_width, l,atx_psu_cover_height+1],center=true);

            translate([-atx_psu_cover_width,-15,atx_psu_cover_height/2])
            rotate([-45,0,0])
            cube([atx_psu_cover_width*2,60,60]);

            translate([-atx_psu_cover_width,-15,-atx_psu_cover_height/2])
            rotate([-45,0,0])
            cube([atx_psu_cover_width*2,60,60]);

            translate([-11/2+1,-1,-1])
            cube([atx_psu_width-11,l,atx_psu_cover_height-21 ],center=true);

            translate([1,-1,-6])
            cube([atx_psu_width-4,l,atx_psu_cover_height-32],center=true);

            translate([0,-1,-13])
            cube([atx_psu_width-20,l,atx_psu_cover_height-32],center=true);

            translate([12,-1,13])
            cube([atx_psu_width-44,l,atx_psu_cover_height-32],center=true);
        }
    }
}

module side_clip1() {
    difference() {
        union() {
            cube([14,8,25]);
            cube([20,5,15]);
            translate([14-5,0,0]) cube([5,58.5,15]);
            translate([14-5,55.5,0]) cube([10,3,15]);
            hull() {
                cube([14,4,2]);
                translate([14-5,57,0]) cube([5,1,2]);
            }
        }
        translate([7,0,-0.001]) male_dovetail(26);
    }
}

module side_clip2() {
    difference() {
        union() {
            hull() {
                cube([114,15,5]);
                translate([114-25,25,0]) cube([25,14,5]);
            }
            translate([114-25,39,0]) cube([25,14,8]);
            translate([-14,-10,0]) cube([14,25,8]);
            //translate([-3,0,0]) cube([3,15,20]);
            //translate([114,0,0]) cube([3,15,20]);
        }
        translate([-7,15,-0.001]) rotate([90,0,0]) male_dovetail(26, bridge_extra=0.3);
        translate([114-25.1,39+7,-0.001]) rotate([90,0,90]) male_dovetail(26, bridge_extra=0.3);
        //translate([0,15/2,11+5]) rotate([0,90,0]) cylinder(d=4.3,h=15,center=true,$fn=30);
        //translate([114,15/2,11+5]) rotate([0,90,0]) cylinder(d=4.3,h=15,center=true,$fn=30);
        translate([31.5,9/2,-0.2]) {
            translate([0,0,2.2]) cylinder(d=4.3,h=15,$fn=30);
            cylinder(d=7.5,h=2,$fn=30);
        }
        translate([114-31.5,9/2,-0.2]) {
            translate([0,0,2.2]) cylinder(d=4.3,h=15,$fn=30);
            cylinder(d=7.5,h=2,$fn=30);
        }

        translate([10,9,0]) {
            hull() {
                cube([0.1,0.1,11],center=true);
                translate([94,26/2,0]) cube([0.1,26,11],center=true);
            }
        }
    }
}

module psu_clips() {
    translate([0,psu_cover_height,0]) rotate([90,0,0]) front(psu_cover_width, psu_cover_height);
    translate([0,-psu_height/2-17,0]) rotate([90,0,0]) back(psu_width,psu_height);
}

module clip_extension() {
    rotate([0,10,0])
    difference() {
        intersection() {
            difference() {
                union() {
                    cube([46,25,30]);

                    hull() {
                        translate([27,0,0])
                        cube([1,25,30]);

                        translate([37,4,0])
                        cube([28,30,30]);
                    }
                }
                translate([42,-5,-1])
                cube([30,30,32]);

                translate([0,25-15,-1])
                rotate([0,0,-90])
                male_dovetail(35);

                translate([42,25-15,-1])
                rotate([0,0,90])
                male_dovetail(35);

                translate([42+15,25,-1])
                rotate([0,0,0])
                male_dovetail(35);


            }
            rotate([0,-10,0])
            cube([75,40,17]);
        }
    }
}

module view_proper() {
    translate([psu_width/2+28+2*slop,300/2-(thickness/2+(8-thickness)),psu_cover_height/2-66.5]) front();
    translate([psu_width/2+28+2*slop,-30-(thickness/2+(8-thickness)),psu_height/2-63.5]) back();

    frame_mockup(bed_angle=0, units_x=2, units_y=2, units_z=2);
    %translate([28+2*slop, -60, -63.5 ]) mock_psu();
}

module view_proper_atx() {
    translate([27,
            300/2-(thickness/2+(8-thickness)),
            atx_psu_height/2-89.5])
    front_atx();

    translate([27,
            60-(thickness/2+(8-thickness)),
            atx_psu_height/2-89.5])
    back_atx();

    frame_mockup(bed_angle=0, units_x=2, units_y=2, units_z=2);

    translate([27, 180, -89.5 ])
    rotate([0,0,180])
    mock_atx_psu();
    
    translate([27, 183, -89.5 ])
    rotate([90,180,0])
    atx_psu_cover();

    translate([108,50,24])
    rotate([-90,0,10])
    clip_extension();
}

module view_proper_side_mount() {
    %translate([0,-24.5,5]) mock_PSU_360W();
    translate([-14,25,0]) rotate([90,0,0]) side_clip1();
    translate([0,153,0]) side_clip2();
}

