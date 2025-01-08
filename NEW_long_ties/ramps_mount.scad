include <globals.scad>;
include <include.scad>;
use <adapters.scad>;
use <long_tie.scad>;
use <long_bow_tie.scad>;
use <mockups.scad>;


////// VARIABLES //////
box_width = 83;
box_length = 123;

$fn=30;

arduino_width = 53.7;
arduino_length = 101.6;
arduino_thickness = 2;

ramps_mount_w = arduino_width + 5;
ramps_mount_l = arduino_length;

ramps_w = 60.5;
ramps_l = 123;

raspberry_pi_3b_w = 56.1;
raspberry_pi_3b_l = 85;

raspi_mount_w = raspberry_pi_3b_w + 4;
raspi_mount_l = raspberry_pi_3b_l + 1;


////// VIEW //////
//debug();
//debug_ramps_enclosure();
//debug_ramps_hole_positions();
//debug_raspberry_pi_3b_mount();
//debug_atx_connector_mount();
debug_atx_connector_small_mount();

//ramps_mount_light();

//ramps_enclosure();
//ramps_enclosure_lid();
//ramps_enclosure_mount();

//raspberry_pi_3b_mount_ties();
//raspberry_pi_3b_mount();

//atx_connector_mount();
//atx_connector_small_mount();

//fan_mount_60mm();

//frame_clip();
//frame_clip2(65);
//frame_clip2(80);
//frame_clip2_mirrored(65);
//frame_clip2_mirrored(80);
//frame_clip3(65);
//frame_clip3_mirrored(65);


////// MODULES //////
module _stripe() {
    x = arduino_width/4;
    y = x/2;
    hull() {
        translate([-x,y,0]) cylinder(d=4, h=5,$fn=20);
        translate([x,-y,0]) cylinder(d=4, h=5,$fn=20);
    }
}

module _notch(w=2,l=10) {
    notch_h = sqrt(w*w*2);
    rotate([0,45,0])
    cube([w, l, w], center=true);

    translate([0, 0, -arduino_thickness - notch_h/1.8])
    rotate([0, 45, 0])
    cube([w, l, w], center=true);
}

module ramps_mount_light() {

    module bow_ear() {
        difference() {
            cube([22,15,8]);
            translate([15,22,0]) rotate([90,0,0]) male_dovetail(25);
        }
    }

    // bottom thickness + arduino clearance + arduino mount height
    h = 2.5 + 2 + arduino_thickness + 4;
    h2 = h - 2.5;

    union() {
        difference() {
            translate([0,0,h/2])
            cube([ramps_mount_w, arduino_length, h], center=true);

            translate([0,2,h2/2+(h-h2)])
            cube([arduino_width, arduino_length, h2], center=true);

            translate([0,-1,h2/2+(h-h2)+2])
            cube([arduino_width-3, arduino_length, h2], center=true);

            for(i = [0:8]) {
                translate([0,-arduino_length/3+i*8,0])
                _stripe();
            }
        }

        translate([arduino_width/2,arduino_length/2-10,h-1.4])
        _notch();

        translate([arduino_width/2,-arduino_length/2+10,h-1.4])
        _notch();

        translate([-arduino_width/2,arduino_length/2-10,h-1.4])
        _notch();

        translate([-arduino_width/2,-arduino_length/2+10,h-1.4])
        _notch();

        translate([ramps_mount_w/2-0.01,arduino_length/2-15,0])
        rotate([0,0,180])
        long_tie_half(20);

        translate([ramps_mount_w/2-0.01,-arduino_length/2+15,0])
        rotate([0,0,180])
        long_tie_half(20);

        translate([0,-ramps_mount_l/2+0.01,0])
        rotate([0,0,90])
        long_tie_half(20);

        translate([-ramps_mount_w/2+0.01,arduino_length/2-15,0])
        long_tie_half(20);

        translate([-ramps_mount_w/2+0.01,-arduino_length/2+15,0])
        long_tie_half(20);
        
        translate([0,ramps_mount_l/2-0.01,0])
        rotate([0,0,-90])
        long_tie_half(20);
    }
}

module _ramps_hole_positions() {

    translate([-10.2,-39.12,0])
    children();

    translate([-10.2,35.82,0])
    children();

    translate([38.05,-40.38,0])
    children();

    translate([38.05,42.18,0])
    children();
}

module ramps_enclosure() {
    
    wall = 1.5;
    h = 50;
    w = 90;
    l = 120;

    module _mount_stud() {
        difference() {
            cylinder(d=6, h=4.5, $fn=30);
            cylinder(d=2.9, h=5, $fn=30);
        }
    }

    module lid_connector() {
        translate([7/2, 7/2, 0])
        hull() {
            translate([0, 0, 7])
            cylinder(d=7, h=7, $fn=50);

            translate([-2, -2, 0])
            cylinder(d=0.5, h=0.5);
        }
    }

    module wire_strain_relief() {
        difference() {
            hull() {
                cube([5, 0.1, 12], center=true);

                translate([0, 4.5/2, 0])
                cube([5, 4.5, 6], center=true);
            }
            translate([0, 3/2, 0])
            cube([2, 3, 12], center=true);
        }
    }

    union() {
        difference() {
            translate([0, 0, h/2])
            rounded_cube_side(w, l, h, 6, center=true);

            translate([0, 0, wall + h/2])
            difference() {
                rounded_cube_side(
                    w - 2*wall, l - 2*wall, h,
                    6 - 2*wall, center=true
                );

                // lid mount connectors
                translate([-w/2, -l/2, h/2 - 15.5])
                lid_connector();

                translate([w/2, -l/2, h/2 - 15.5])
                rotate([0, 0, 90])
                lid_connector();

                translate([w/2, l/2, h/2 - 15.5])
                rotate([0, 0, 180])
                lid_connector();

                translate([-w/2, l/2, h/2 - 15.5])
                rotate([0, 0, -90])
                lid_connector();

                // reset tunnel
                translate([w/2, -17.1, -h/2 + 22.8 - wall])
                rotate([0, 90, 0])
                cylinder(d=8, h=39, center=true, $fn=20);

                // cable arches
                translate([
                    w/2 - 3/2 - wall, -17.1, -h/2 + 40/2
                ])
                cube([3, 2, 40], center=true);

                translate([
                    w/2 - 39/2 + 3/2, -17.1, -h/2 + 40/2
                ])
                cube([3, 2, 40], center=true);

                translate([w/2, -17.1, -h/2 + 40 + 4/2])
                cube([39, 2, 4], center=true);

                translate([w/2, 8, -h/2 + 40 + 4/2])
                cube([41, 2, 4], center=true);

                translate([w/2, 8, -h/2 + 16 + 4/2])
                cube([41, 2, 4], center=true);

                translate([w/2 - 4/2 - wall, 8, -h/2 + 40/2])
                cube([4, 2, 40], center=true);

                translate([w/2 - 41/2 + 4/2, 8, -h/2 + 40/2])
                cube([4, 2, 40], center=true);

                translate([w/2, 33, -h/2 + 40 + 4/2])
                cube([41, 2, 4], center=true);

                translate([w/2, 33, -h/2 + 16 + 4/2])
                cube([41, 2, 4], center=true);

                translate([w/2 - 4/2 - wall, 33, -h/2 + 40/2])
                cube([4, 2, 40], center=true);

                translate([w/2 - 41/2 + 4/2, 33, -h/2 + 40/2])
                cube([4, 2, 40], center=true);
            }

            // usb hole
            translate([-22.5, -l/2, 12/2 +6])
            cube([15, 19, 12], center=true);

            // dc hole
            translate([7.4, -l/2, 10/2 + 8])
            cube([10, 19, 10], center=true);

            // 12v hole
            translate([9.8, -l/2, 18/2 + 18])
            cube([25, 19, 18], center=true);

            // display cable hole
            translate([-11.5, l/2, 50/2 + 30])
            cube([45, 19, 50], center=true);

            // heatbed wire hole
            translate([32, l/2, 10])
            rotate([90, 0, 0])
            cylinder(d=15, h=10, $fn=30);

            // wire hole
            translate([32, l/2, 30])
            rotate([90, 0, 0])
            cylinder(d=15, h=10, $fn=30);

            // reset hole
            translate([w/2, -17.1, 22.8])
            rotate([0, 90, 0])
            cylinder(d=5, h=45, center=true, $fn=20);

            // lid screw holes
            translate([-w/2 + 7/2, l/2 - 7/2, h - 9])
            cylinder(d=2.8, h=9, $fn=30);

            translate([w/2 - 7/2, l/2 - 7/2, h - 9])
            cylinder(d=2.8, h=9, $fn=30);

            translate([-w/2 + 7/2, -l/2 + 7/2, h - 9])
            cylinder(d=2.8, h=9, $fn=30);

            translate([w/2 - 7/2, -l/2 + 7/2, h - 9])
            cylinder(d=2.8, h=9, $fn=30);

            // mount holes
            translate([-65/2, l/2 - 10, 0])
            cylinder(d=3.3, h=8, center=true, $fn=40);

            translate([65/2, l/2 - 10, 0])
            cylinder(d=3.3, h=8, center=true, $fn=40);

            translate([-65/2, -l/2 + 10, 0])
            cylinder(d=3.3, h=8, center=true, $fn=40);

            translate([65/2, -l/2 + 10, 0])
            cylinder(d=3.3, h=8, center=true, $fn=40);

            // side grills
            difference() {
                for(i = [0:12]) {
                    translate([-w/2, -30 + i*5, h/2])
                    cube([5, 2.5, 28], center=true);

                    translate([w/2, -30 + i*5, h/2])
                    cube([5, 2.5, 28], center=true);
                }
                translate([w/2, -17.1, 22.8])
                rotate([0, 90, 0])
                cylinder(d=8, h=41, center=true, $fn=20);
            }

            // end grills
            difference() {
                for(i = [0:7]) {
                    translate([-w/2 + 15 + i*5, l/2, h/2 - 8])
                    cube([2.5, 5, 18], center=true);
                }
            }
        }
        translate([-25, 2, 0])
        _ramps_hole_positions()
        _mount_stud();

        translate([22.5, l/2, 10])
        wire_strain_relief();

        translate([22.5, l/2, 30])
        wire_strain_relief();
    }
}

module ramps_enclosure_lid() {

    wall = 1.5;
    w = 90;
    l = 120;
    wall_offset = (wall*2 + 0.5)/2;

    module lid_screw_hole() {
        translate([0, 0, wall])
        cylinder(d=7.5, 20, $fn=30);

        hull() {
            cylinder(d=5.2, h=0.1, $fn=30);
            translate([0, 0, 0.9])

            cylinder(d=3.2, h=0.1, $fn=30);
        }
        translate([0, 0, 1])
        cylinder(d=3.2, h=2, $fn=30);
    }

    difference() {
        union() {
            translate([0, 0, wall/2])
            rounded_cube_side(w, l, wall, 6, center=true);

            difference() {
                translate([0, 0, wall])
                rounded_cube_side(
                    w - wall_offset*2,
                    l - wall_offset*2,
                    3,
                    6 - wall_offset*2,
                    center=true
                );

                translate([0, 0, 4/2])
                rounded_cube_side(
                    w - 10, l - 15, 4 ,3 ,center=true
                );
            }

            // fan screw studs
            for(i = [0:3]) {
                rotate([0, 0, 360/4*i])
                translate([25, 25, 0])
                cylinder(d=6, h=5, $fn=20);
            }
        }

        // screw holes
        translate([-w/2 + 7/2, -l/2 + 7/2, 0])
        lid_screw_hole();

        translate([w/2 - 7/2, -l/2 + 7/2, 0])
        lid_screw_hole();

        translate([w/2 - 7/2, l/2 - 7/2, 0])
        lid_screw_hole();

        translate([-w/2 + 7/2, l/2 - 7/2, 0])
        lid_screw_hole();

        // fan hole
        difference() {
            cylinder(d=60, h=4, center=true, $fn=50);
            cylinder(d=18, h=4, center=true, $fn=50);

            tube(34, 3, wall, $fn=60);
            tube(48, 3, wall, $fn=60);

            cube([60, wall, 8], center=true);
            cube([wall, 60, 8], center=true);
        }

        // fan screw holes
        for(i = [0:3]) {
            rotate([0, 0, 360/4*i])
            translate([25, 25, 0])
            cylinder(d=2.8, h=11, center=true, $fn=20);
        }
    }
}

module ramps_enclosure_mount() {
    l = 120;

    difference() {
        translate([0, 0, 6/2])
        union() {
            cube([67, l - 18, 6], center=true);

            translate([-65/2, l/2 - 10, 0])
            cylinder(d=8, h=6, center=true, $fn=40);

            translate([65/2, l/2 - 10, 0])
            cylinder(d=8, h=6, center=true, $fn=40);

            translate([-65/2, -l/2 + 10, 0])
            cylinder(d=8, h=6, center=true, $fn=40);

            translate([65/2, -l/2 + 10, 0])
            cylinder(d=8, h=6, center=true, $fn=40);
        }

        intersection() {
            difference() {
                cube([67 - 7, l - 18 - 7, 20], center=true);

                translate([5.65, 32, 0])
                cylinder(d=14, h=30, center=true, $fn=30);

                translate([-5.65, -26.5, 0])
                cylinder(d=14, h=30, center=true, $fn=30);
            }

            translate([-219.55, -228, 0])
            for(j = [0:39]) {
                translate([0, j*13])
                rotate([0, 0, -60])
                for (i = [0:39]) {
                    translate([0, i*13])
                    cylinder(
                        d=13, h=60,
                        center=true, $fn=6
                    );
                }
            }
        }

        translate([-65/2, l/2 - 10, 0])
        cylinder(d=2.8, h=20, center=true, $fn=40);

        translate([65/2, l/2 - 10, 0])
        cylinder(d=2.8, h=20, center=true, $fn=40);

        translate([-65/2, -l/2 + 10, 0])
        cylinder(d=2.8, h=20, center=true, $fn=40);

        translate([65/2, -l/2 + 10, 0])
        cylinder(d=2.8, h=20, center=true, $fn=40);

        translate([5.65, 32, -1])
        _adapter_mount_thread();

        translate([-5.65, -26.5, -1])
        _adapter_mount_thread();
    }
}

module _raspberry_pi_3b_mount(h=11, stripes=true) {
    // download: https://www.thingiverse.com/thing:1701186
    %translate([-29.5, 45, h/2 - 5])
    rotate([0, 0, -90])
    import(
    "../../_downloaded/Raspberry_pi_3_reference/Raspberry_Pi_3_Light_Version.STL"
    );

    union() {
        difference() {
            cube([raspi_mount_w, raspi_mount_l, h], center=true);

            translate([0, 0, 2.5])
            cube([
                raspberry_pi_3b_w, raspi_mount_l + 1, h
            ], center=true);

            if (stripes) {
                for(i = [0:7]) {
                    translate([0, i*7 - raspi_mount_l/3.4, -h/2])
                    _stripe();
                }
            }

            translate([-raspi_mount_w/2 - 1, 27, h/2 - 2.1])
            cube([9.8, 9, 4]);

            translate([-raspi_mount_w/2 - 1, 2.4, h/2 - 2.1])
            cube([10, 16, 4]);

            translate([-raspi_mount_w/2 - 1, -11.2, h/2 + 1])
            rotate([0, 90, 0])
            cylinder(d=8, h=5, $fn=20);
        }

        translate([
            raspberry_pi_3b_w/2, raspi_mount_l/2 - 3.75, h/2 - 1
        ])
        _notch(w=1.5, l=7.5);

        translate([
            raspberry_pi_3b_w/2, -raspi_mount_l/2 + 21, h/2 - 1
        ])
        _notch(w=1.5);

        translate([
            -raspberry_pi_3b_w/2, raspi_mount_l/2 - 3.5, h/2 - 1
        ])
        _notch(w=1.5, l=7);

        translate([
            -raspberry_pi_3b_w/2, -raspi_mount_l/2 + 22, h/2 - 1
        ])
        _notch(w=1.5, l=10);
    }
}

module raspberry_pi_3b_mount_ties() {
    
    h = 11;

    union() {
        _raspberry_pi_3b_mount(h=h);

        translate([
            -raspi_mount_w/2 + 0.01, raspi_mount_l/2 - 15, -h/2
        ])
        long_tie_half(20);

        translate([
            -raspi_mount_w/2 + 0.01, -raspi_mount_l/2 + 15, -h/2
        ])
        long_tie_half(20);

        translate([
            raspi_mount_w/2 - 0.01, raspi_mount_l/2 - 15, -h/2
        ])
        rotate([0, 0, 180])
        long_tie_half(20);

        translate([
            raspi_mount_w/2 - 0.01, -raspi_mount_l/2 + 15, -h/2
        ])
        rotate([0, 0, 180])
        long_tie_half(20);

        translate([0, -raspi_mount_l/2 + 0.01, -h/2])
        rotate([0, 0, 90])
        long_tie_half(20);

        translate([0, raspi_mount_l/2 - 0.01, -h/2])
        rotate([0, 0, -90])
        long_tie_half(20);
    }
}

module raspberry_pi_3b_mount() {
    h = 14;

    difference() {
        union() {
            translate([0, 0, h/2])
            _raspberry_pi_3b_mount(h=h, stripes=false);

            translate([0, 0, 6/2])
            cube([raspi_mount_w, raspi_mount_l, 6], center=true);
        }

        intersection() {
            difference() {
                cube([
                    raspi_mount_w - 7,
                    raspi_mount_l - 7, 20
                ], center=true);

                translate([-6.55, 26, 0])
                cylinder(d=14, h=30, center=true, $fn=30);

                translate([4.7, -32.5, 0])
                cylinder(d=14, h=30, center=true, $fn=30);
            }

            translate([-220.45, -227.5, 0])
            for(j = [0:39]) {
                translate([0, j*13])
                rotate([0, 0, -60])
                for (i = [0:39]) {
                    translate([0, i*13])
                    cylinder(
                        d=13, h=60,
                        center=true, $fn=6
                    );
                }
            }
        }

        translate([-6.55, 26, -1])
        _adapter_mount_thread();

        translate([4.7, -32.5, -1])
        _adapter_mount_thread();
    }
}

module _atx_connector_mount(
    inner_w=79.35, l=70, h=14, stripes=true
) {
    // for the connector parts, see: https://github.com/spegelius/3DModels/blob/master/PrinterParts/ATX_Connector_Mount.scad

    wall = 3;
    outer_w = inner_w + 2*wall;

    notch_w = 2;

    union() {
        difference() {
            translate([0, 0, h/2])
            cube([outer_w, l, h], center=true);

            translate([0, 2, h/2 + wall])
            cube([inner_w, l + 1, h], center=true);

            translate([0, 0, h/2 + wall + 1.5])
            cube([inner_w - 3, l + 1, h], center=true);

            if (stripes) {
                for(i = [0:5]) {
                    translate([0, i*8 - l/3.6, -0.01])
                    _stripe();
                }
            }
        }

        translate([inner_w/2, l/2 - 3.75, h - 1.3])
        _notch(w=notch_w, l=7.5);

        translate([inner_w/2, -2, h - 1.3])
        _notch(w=notch_w, l=15);

        translate([inner_w/2, -l/2 + 5, h - 1.3])
        _notch(w=notch_w, l=7.5);

        translate([-inner_w/2, l/2 - 3.75, h - 1.3])
        _notch(w=notch_w, l=7.5);

        translate([-inner_w/2, -2, h - 1.3])
        _notch(w=notch_w, l=15);

        translate([-inner_w/2, -l/2 + 5, h - 1.3])
        _notch(w=notch_w, l=7.5);
    }
}

module atx_connector_mount_ties() {
    wall = 3;
    inner_w = 79.35;
    outer_w = inner_w + 2*wall;
    l = 70;
    h = 14;

    notch_w = 2;

    union() {
        _atx_connector_mount();

        translate([-outer_w/2 + 0.01, l/2 - 15, 0])
        long_tie_half(20);

        translate([-outer_w/2 + 0.01, -l/2 + 15, 0])
        long_tie_half(20);

        translate([outer_w/2 - 0.01, l/2 - 15, 0])
        rotate([0, 0, 180])
        long_tie_half(20);

        translate([outer_w/2 - 0.01, -l/2 + 15, 0])
        rotate([0, 0, 180])
        long_tie_half(20);

        translate([0, -l/2 + 0.01, 0])
        rotate([0, 0, 90])
        long_tie_half(20);
    }
}

module atx_connector_mount() {
    wall = 3;
    inner_w = 79.35;
    outer_w = inner_w + 2*wall;
    l = 70;
    h = 14;

    notch_w = 2;

    difference() {
        union() {
            translate([0, 0, 4])
            _atx_connector_mount(stripes=false);

            translate([0, 0, 5/2])
            cube([outer_w, l, 5], center=true);
        }

        intersection() {
            difference() {
                cube([
                    outer_w - 7, l - 7, 20
                ], center=true);

                translate([28.2, -13.5, 0])
                cylinder(d=14, h=30, center=true, $fn=30);

                translate([-28.05, 19, 0])
                cylinder(d=14, h=30, center=true, $fn=30);

            }

            translate([-219.45, -221.5, 0])
            for(j = [0:39]) {
                translate([0, j*13])
                rotate([0, 0, -60])
                for (i = [0:39]) {
                    translate([0, i*13])
                    cylinder(
                        d=13, h=60,
                        center=true, $fn=6
                    );
                }
            }
        }

        translate([28.2, -13.5, -1])
        _adapter_mount_thread();

        translate([-28.05, 19, -1])
        _adapter_mount_thread();

    }
}

module atx_connector_small_mount() {
    wall = 3;
    inner_w = 32.15;
    outer_w = inner_w + 2*wall;
    l = 81;
    h = 16;

    notch_w = 2;

    difference() {
        union() {
            translate([0, 0, 4])
            _atx_connector_mount(
                inner_w=inner_w, l=l, h=h, stripes=false
            );

            translate([0, 0, 5/2])
            cube([outer_w, l, 5], center=true);
        }

        intersection() {
            difference() {
                cube([
                    outer_w - 7, l - 7, 20
                ], center=true);

                translate([-5.55, -20, 0])
                cylinder(d=14, h=30, center=true, $fn=30);

                translate([5.75, 25.5, 0])
                cylinder(d=14, h=30, center=true, $fn=30);

            }

            translate([-219.45, -221.5, 0])
            for(j = [0:39]) {
                translate([0, j*13])
                rotate([0, 0, -60])
                for (i = [0:39]) {
                    translate([0, i*13])
                    cylinder(
                        d=13, h=60,
                        center=true, $fn=6
                    );
                }
            }
        }

        translate([-5.55, -20, -1])
        _adapter_mount_thread();

        translate([5.75, 25.5, -1])
        _adapter_mount_thread();

    }
}

module fan_mount_60mm() {
    // inspired by: https://www.thingiverse.com/thing:145946
    h = 12;
    l = 50;
    wall = 3.5;
    inner_w = ramps_w-4;
    outer_w = inner_w + 2*wall;

    difference() {
        rounded_cube_side(outer_w,l,h,5, center=true);
        translate([0,wall,1.5])
        rounded_cube_side(inner_w,l,h+1, 4, center=true);

        translate([0,wall+10,0])
        cube([inner_w,l,h+1], center=true);

        translate([0,l/2-3,0])
        cube([ramps_w-1,2.2,20], center=true);

        translate([0,l/2-10,20/2])
        chamfered_cube(outer_w+20,l,20,7, center=true);

        translate([0,0,60/2-h/2+4])
        rotate([90,0,0]) {
            cylinder(d=60,h=100,$fn=60);

            translate([-25,-25,0])
            cylinder(d=2.8,h=100,$fn=20);

            translate([25,-25,0])
            cylinder(d=2.8,h=100,$fn=20);
        }

        mirror([1,0,0])
        translate([outer_w/2-5,-l/2+10,-h/2])
        rotate([0,0,180])
        linear_extrude(0.6)
        text(align="center", size=8, "RAMPS 1.4");
    }
}

module _male_dove_half(h) {
    intersection() {
        scale([1.08,1.02,1])
        male_dovetail(h);

        translate([-5,0,0])
        cube([5,5,h]);
    }
}

module frame_clip() {
    difference() {
        union() {
            _frame_clip();

            translate([-11.5,-23,0])
            chamfered_cube(12,5,20,1,center=true);
        }

        translate([-17.5,-19,21/2])
        rotate([180,0,90])
        _male_dove_half(21);

        translate([-17.5,-21,0])
        cube([14,0.2,30],center=true);
    }
}

module frame_clip2(length=50) {
    difference() {
        union() {
            _frame_clip();

            translate([(length+5)/2+11.5,-21,-10/2])
            chamfered_cube(length+5,8,10,1,center=true);
        }

        translate([length+17.5,-19,-20/2+10])
        rotate([-90,0,90])
        _male_dove_half(length);

        translate([length/2+17.5,-20.5,-20/2+10])
        cube([length,0.2,14],center=true);
    }
}

module frame_clip2_mirrored(length=50) {
    mirror([1,0,0])
    frame_clip2(length=length);
}

module frame_clip3(length=50) {
    difference() {
        union() {
            _frame_clip();

            translate([19,-(length+5)/2-16.5,-10/2])
            intersection() {
                chamfered_cube(8,length+5,10,1,center=true);

                translate([0,-1,0])
                cube([10,length+5,10],center=true);
            }

            translate([15,-25,-10/2])
            rotate([0,0,35])
            chamfered_cube(7,15,10,1,center=true);

            translate([16.65,-14.5,-10/2])
            intersection() {
                rotate([0,0,35])
                chamfered_cube(7,18,10,1,center=true);

                translate([3,2,0])
                cube([7,10,10,],center=true);
            }
        }

        translate([17,-23,-20/2+10])
        rotate([-90,0,180])
        _male_dove_half(length);

        translate([19,-length/2-23,-20/2+10])
        cube([0.2,length,14],center=true);
    }
}

module frame_clip3_mirrored(length=50) {
    mirror([1,0,0])
    frame_clip3(length=length);
}

module debug() {
    frame_mockup(units_x=2, units_y=2);
    translate([120.65,-180,80.8]) rotate([90,0,0]) ramps_mount();
}

module debug_ramps_enclosure() {
    %translate([-25,2,3])
    rotate([0,0,90])
    import("../../_downloaded/RAMPS_1.4/RAMPS1_4.STL");

    intersection() {
        ramps_enclosure();

        translate([-100,-200/2,0])
        cube([100,200,100]);
    }

    translate([0,0,50+1.55])
    rotate([0,180,0])
    ramps_enclosure_lid();
    
}

module debug_ramps_hole_positions() {
    %intersection() {
        rotate([0,0,90])
        import("../../_downloaded/RAMPS_1.4/RAMPS1_4.STL", convexity=5);

        cube([200,200,8],center=true);
    }
    _ramps_hole_positions()
    cylinder(d=3,h=1,$fn=40);
}

module debug_atx_connector_mount() {
    atx_connector_mount();

    translate([42.7,-52.6,-19])
    rotate([-90,0,90])
    frame_clip2(65);

    translate([-42.7,-57.6,-17])
    rotate([180,-90])
    frame_clip3(65);
}

module debug_raspberry_pi_3b_mount() {
    raspberry_pi_3b_mount();

    translate([30,-60.6,-24.5])
    rotate([-90,0,90])
    frame_clip2(80);
}

module debug_atx_connector_small_mount() {
    atx_connector_small_mount();

}