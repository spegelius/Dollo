include <globals.scad>;
include <include.scad>;

psu_height = 50;
psu_width = 114;

psu_cover_width = 119+2*slop;
psu_cover_height = 55+2*slop;

thickness = 7;

bolt_hole_down = 11.5;
bolt_hole_up = 13;

frame_mockup();

%translate([-32+2*slop, -110, -152.5 ]) cube([psu_width, 220, psu_height]);

module front() {
    difference() {
        cube([psu_cover_width+10, thickness, psu_cover_height+10], center=true);
        cube([psu_cover_width, thickness+1, psu_cover_height], center=true);
    }
    difference() {
        translate([-psu_cover_width/2, -thickness+thickness/2, psu_cover_height/2]) cube([25,10,25]);
        translate([-psu_cover_width/2+25,thickness/2+(10-thickness), psu_cover_height/2+15]) #rotate([0,90,180]) male_dovetail(25);
    }
    difference() {
        translate([psu_cover_width/2-25,-thickness+thickness/2, psu_cover_height/2]) cube([25,10,25]);
        translate([psu_cover_width/2,thickness/2+(10-thickness), psu_cover_height/2+15]) #rotate([0,90,180]) male_dovetail(26);
    }
}

module back() {
    difference() {
        cube([psu_width+10, thickness, psu_height+10], center=true);
        cube([psu_width, thickness+1, psu_height], center=true);
    }
    difference() {
        translate([psu_width/2-2.5+2*slop,-thickness/2,25]) cube([10,15,25]);
        translate([psu_width/2+7.5+2*slop,-thickness/2-1, psu_height/2+17.5]) #rotate([0,90,90]) male_dovetail(17);
    }
}

module view_proper() {
    translate([psu_width/2-32+2*slop,180/2-(thickness/2+(10-thickness)),psu_cover_height/2-155-2*slop]) front();
    translate([psu_width/2-32+2*slop,-180/3-(thickness/2+(10-thickness)),psu_height/2-152.5])back();
}

module view_print() {
    translate([0,psu_cover_height,0]) rotate([90,0,0]) front();
    translate([0,-psu_height/2-7,0]) rotate([90,0,0]) back();

}

//view_proper();
view_print();