use <../z_screw.scad>;

// center part for salvaging badly joined screw parts. Drill 100m hole inside the
// old center and use this
module qnd_center_hotfix(h=70, pos1=6.5, pos2=-6) {
    module quide() {
        hull() {
            cylinder(d=4,h=h);
            translate([pos1,0,0]) cylinder(d=0.5,h=h);
            translate([pos2,0,0]) cylinder(d=0.5,h=h);
        }
    }
    union() {
        cylinder(d=10,h=h,$fn=30);
        quide();
    }
}

module qnd_center_hotfix_joiner() {
    union() {
        intersection() {
            z_screw_center();
            cylinder(d=30,h=58.5);
        }
        translate([0,0,58.49]) rotate([0,0,45]) qnd_center_hotfix(35);
    }
}

module qnd_center_hotfix_joiner2() {
    union() {
        intersection() {
            z_screw_center();
            cylinder(d=30,h=58.5);
        }
        translate([0,0,58.49]) rotate([0,0,0]) qnd_center_hotfix(35, 6,1);
    }
}

//qnd_center_hotfix_joiner();
qnd_center_hotfix_joiner2();