include <globals.scad>;
use <include.scad>;

include <mockups.scad>;

use <bed_carriage.scad>;
use <z_motor_mount.scad>;

//z_units = 3+110/120;
//z_units = 3+80/120;
z_units = 3+100/120;
//z_units = 4;

frame_mockup(units_x=3, units_y=3, units_z=z_units);

translate([-180-16,0,-5+27]) cylinder(d=10,h=505);
//translate([-180-16,0,-5+40]) cylinder(d=10,h=505);

translate([-15.5-180,-32.5,-5]) rotate([-90,0,0])  z_motor_mount();

//translate([-180-45,-30,32]) bed_rail_short();
//translate([-180-45,30,32]) bed_rail_short();
//translate([-180-45,-30,88]) bed_rail();
//translate([-180-45,30,88]) bed_rail();
//translate([-180-45,-30,88+120]) bed_rail();
//translate([-180-45,30,88+120]) bed_rail();
//translate([-180-45,-30,88+240]) bed_rail();
//translate([-180-45,30,88+240]) bed_rail();
//translate([-180-45,-30,88+360]) bed_rail_short();
//translate([-180-45,30,88+360]) bed_rail_short();

translate([-180-45,-30,30]) cylinder(d=25,h=520,$fn=6);

%translate([-180-16,0,540]) {
    rotate([180,0,180]) bed_screw_housing(render_threads=false);
    translate([-30,-30,-40]) cylinder(d=30,h=50,$fn=6);
}