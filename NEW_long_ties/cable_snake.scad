// wire holder thing - 7mm gripper

$fn=100;

module holder(){
rotate([0,50,0])difference() {
cube([30,19,4]);
translate([10,10,0])cylinder(d=4.5,h=11);

} // end diff
} // end mod

module snake(){
translate([0,0,10]) rotate([180,0,0])union() {
difference() {
hull() {
translate([20,10,5]) rotate([0,90,0]) cylinder(d=11,h=150);
translate([19,0,0]) cube([1,20,4]);
} // end hull 
translate([45,10,3]) rotate([0,90,0]) resize([9,0,0])cylinder(d=7,h=130);

for (i = [0:10]) translate([25+(i*14),20,10]) rotate([90,0,0]) cylinder(d=4,h=20);
for (i = [0:10]) translate([25+(i*14),20-i*0.4,0]) rotate([0,0,0]) cylinder(d=4,h=20);
for (i = [0:10]) translate([25+(i*14),0+i*0.4,0]) rotate([0,0,0]) cylinder(d=4,h=20);

translate([0,-3,9]) cube([200,25,2]);
} // end difference
} // end union
} //end module 


snake();
translate([0,-19.5,30]) holder();