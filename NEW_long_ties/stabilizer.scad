$fn=40;

module master(){
    
    // tower
	hull(){
		translate([-23.75,-1,26]) sphere(r=7);
		translate([-23.75,-1,16]) sphere(r=7);
        translate([-23.75,-1,0]) cylinder(r=4);
        translate([-28,-1,0]) cylinder(d=12);
	}
    translate([-35,-5,0]) cube([10,43,5]);
    
	difference(){
		translate([-25,20,0]) cube([25,18,5]);
		hull(){
			translate([-5.5,25,0]) cylinder(h=11, d=3.5, center=true, $fn=20);
            translate([-5.5,31,0]) cylinder(h=11, d=3.5, center=true, $fn=20);
		}
	}
}

mirror([1,0,0]) master();
master();
