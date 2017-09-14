
prox_sensor_dia = 18;
prox_sensor_washer_dia = 30;

// LJ18A3-8-Z/BX
module proximity_sensor(nut_position=30, nut_gap=10) {
    
    module mount_nut() {
        color("Silver") difference() {
            cylinder(d=23.7, h=3.5, $fn=6);
            cylinder(d=17.9, h=3.6, $fn=50);
        }
    }
    
    color("Orange") cylinder(d=16.32, h=8.9, $fn=50);
    translate([0,0,8.9]) color("Silver") cylinder(d=prox_sensor_dia, h=47.1, $fn=50);
    translate([0,0,8.9+47.1]) color("LightGrey") cylinder(d=17, h=13.8, $fn=50);
    
    translate([0,0,nut_position]) mount_nut();
    color("LightGrey") translate([0,0,nut_position+3]) cylinder(d=prox_sensor_washer_dia,h=1.5);
    
    translate([0,0,nut_position+3+1.5+1.5+nut_gap]) mount_nut();
    color("LightGrey") translate([0,0,nut_position+3+1.5+nut_gap]) cylinder(d=prox_sensor_washer_dia,h=1.5);
    
    
}

module e3dv6() {
    
    module nozzle() {
        hull() {
            cylinder(d=1, h=1, $fn=30);
            translate([0,0,2]) cylinder(d=3, h=1, $fn=30);
        }
        translate([0,0,2]) cylinder(d=7,h=2.5, $fn=6);
        translate([0,0,4.5]) cylinder(d=4,h=2, $fn=30);
    }
    
    module heater_block() {
        color("LightGrey") {
            translate([-8, -8, 0]) cube([16,23,11.5]);
            cylinder(d=5,h=15, $fn=30);
        }
    }
    
    module heatsink() {
        color("LightGrey") {
            cylinder(d=10,h=28, $fn=50);
            for (i = [0:9]) {
                translate([0,0,i*2.5]) cylinder(r=11.2, h=1, $fn=50);
            }
            translate([0,0,25]) cylinder(d=16,h=1, $fn=50);
        }
    }
    
    module neck() {
        color("LightGrey") {
            $fn=50;
            cylinder(d=16, h=3);
            translate([0,0,3]) cylinder(d=12, h=6);
            translate([0,0,9]) cylinder(d=16, h=3.7);
        }
    }
    nozzle();
    translate([0,0,5]) heater_block(); 
    translate([0,0,18]) heatsink();
    translate([0,0,62.3-16.7]) neck();
}

module prometheus() {

    module nozzle() {
        hull() {
            cylinder(d=1, h=1, $fn=30);
            translate([0,0,2]) cylinder(d=3, h=1, $fn=30);
        }
        translate([0,0,2]) cylinder(d=7,h=2.5, $fn=6);
        translate([0,0,4.5]) cylinder(d=4,h=2, $fn=30);
    }

    module heater_block() {
        color("LightGrey") {
            translate([-8, -8, 0]) cube([16,23,11.5]);
            cylinder(d=5,h=15, $fn=30);
        }
    }
    
    module heatsink() {
        intersection() {
            color("LightGrey") {
                cylinder(d=10,h=28, $fn=50);
                for (i = [0:9]) {
                    translate([0,0,i*2.5]) cylinder(r=15, h=1, $fn=50);
                }
                translate([0,0,25]) cylinder(d=16,h=1, $fn=50);
            }
            translate([0,0,40/2]) cube([30,20,40], center=true);
        }
    }
    
    module neck() {
        color("LightGrey") {
            $fn=50;
            cylinder(d=16, h=3);
            translate([0,0,3]) cylinder(d=12, h=6);
            translate([0,0,9]) cylinder(d=16, h=3.7);
        }
    }
    nozzle();
    translate([0,0,5]) heater_block();
    translate([0,0,18]) heatsink();
    translate([0,0,62.3-16.7]) neck();
}

//proximity_sensor();

//e3dv6();
//prometheus();