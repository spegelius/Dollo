    include <globals.scad>;
use <include.scad>;
use <mockups.scad>;

use <bed_carriage.scad>;
use <leg.scad>;
use <z_motor_mount.scad>;
use <stabilizer.scad>;
use <ramps_mount.scad>;
use <psu_holder.scad>;
use <adapters.scad>;
use <rack.scad>;
use <motor_mount_small.scad>;
use <cable_chain.scad>;
use <x_spacer.scad>;


corner_side = 60;
unit = 120;


//_frame_to_stl(240, 240, 570);
//_frame_to_stl(240, 240, 240);
//_frame_to_stl(360, 360, 670);
//_stabilizers_to_stl(240, 240, 570, 120);
//_stabilizers_to_stl(360, 360, 670, 150);


dollo3d();
//dollo3d_2();


module _side(length) {
    render()
    difference() {
        cube([30, 30, length]);

        translate([15, -0.01, 0])
        male_dovetail(length + 1);

        translate([-0.01, 15, 0])
        rotate([0, 0, -90])
        male_dovetail(length + 1);

        translate([15, 30.01, 0])
        rotate([0, 0, 180])
        male_dovetail(length + 1);

        translate([30.01, 15, 0])
        rotate([0, 0, 90])
        male_dovetail(length + 1);
    }
}

module _frame_to_stl(
    unit_len_x, unit_len_y, unit_len_z
) {

    z = 2*corner_side + unit_len_z - 30;

    module corner() {
        translate([15, 15, 15])
        rotate([-45, 0, 0])
        rotate([0, atan(1/sqrt(2)), 0])
        import("STL/corner_extra_stiff.stl", convexity=10);
    }



    // bottom corners
    translate([
        -corner_side - unit_len_x/2,
        -corner_side - unit_len_y/2, 0
    ])
    corner();

    mirror([1, 0, 0])
    translate([
        -corner_side - unit_len_x/2,
        -corner_side - unit_len_y/2, 0
    ])
    corner();

    mirror([0, 1, 0])
    translate([
        -corner_side - unit_len_x/2,
        -corner_side - unit_len_y/2, 0
    ])
    corner();

    mirror([0, 1, 0])
    mirror([1, 0, 0])
    translate([
        -corner_side - unit_len_x/2,
        -corner_side - unit_len_y/2, 0
    ])
    corner();

    // top corners
    translate([0, 0, 2*corner_side + unit_len_z])
    mirror([0, 0, 1]) {
        translate([
            -corner_side - unit_len_x/2,
            -corner_side - unit_len_y/2, 0
        ])
        corner();

        mirror([1, 0, 0])
        translate([
            -corner_side - unit_len_x/2,
            -corner_side - unit_len_y/2, 0
        ])
        corner();

        mirror([0, 1, 0])
        translate([
            -corner_side - unit_len_x/2,
            -corner_side - unit_len_y/2, 0
        ])
        corner();

        mirror([0, 1, 0])
        mirror([1, 0, 0])
        translate([
            -corner_side - unit_len_x/2,
            -corner_side - unit_len_y/2, 0
        ])
        corner();
    }

    // sides
    translate([
        -corner_side - unit_len_x/2,
        unit_len_y/2, 0
    ])
    rotate([90, 0, 0])
    _side(unit_len_y);

    translate([
        -corner_side - unit_len_x/2,
        (unit_len_y + 60)/2, 90
    ])
    rotate([90, 0, 0])
    _side(unit_len_y + 60);

    mirror([1, 0, 0])
    translate([
        -corner_side - unit_len_x/2,
        unit_len_y/2, 0
    ])
    rotate([90, 0, 0])
    _side(unit_len_y);

    mirror([1, 0, 0])
    translate([
        -corner_side - unit_len_x/2,
        (unit_len_y + 60)/2, 90
    ])
    rotate([90, 0, 0])
    _side(unit_len_y + 60);

    rotate([0, 0, 90])
    translate([
        -corner_side - unit_len_y/2,
        unit_len_x/2, 0
    ])
    rotate([90, 0, 0])
    _side(unit_len_x);

    mirror([0, 1, 0])
    rotate([0, 0, 90])
    translate([
        -corner_side - unit_len_y/2,
        unit_len_x/2, 0
    ])
    rotate([90, 0, 0])
    _side(unit_len_x);

    // top sides
    translate([
        -corner_side - unit_len_x/2,
        unit_len_y/2, z
    ])
    rotate([90, 0, 0])
    _side(unit_len_y);

    mirror([1, 0, 0])
    translate([
        -corner_side - unit_len_x/2,
        unit_len_y/2, z
    ])
    rotate([90, 0, 0])
    _side(unit_len_y);

    rotate([0, 0, 90])
    translate([
        -corner_side - unit_len_y/2,
        unit_len_x/2, z
    ])
    rotate([90, 0, 0])
    _side(unit_len_x);

    mirror([0, 1, 0])
    rotate([0, 0, 90])
    translate([
        -corner_side - unit_len_y/2,
        unit_len_x/2, z
    ])
    rotate([90, 0, 0])
    _side(unit_len_x);

    // z sides
    translate([
        -corner_side - unit_len_x/2,
        -corner_side - unit_len_y/2,
        corner_side
    ])
    _side(unit_len_z);

    mirror([1, 0, 0])
    translate([
        -corner_side - unit_len_x/2,
        -corner_side - unit_len_y/2,
        corner_side
    ])
    _side(unit_len_z);

    mirror([0, 1, 0])
    translate([
        -corner_side - unit_len_x/2,
        -corner_side - unit_len_y/2,
        corner_side
    ])
    _side(unit_len_z);

    mirror([0, 1, 0])
    mirror([1, 0, 0])
    translate([
        -corner_side - unit_len_x/2,
        -corner_side - unit_len_y/2,
        corner_side
    ])
    _side(unit_len_z);
}

module _stabilizers_to_stl(
    unit_len_x, unit_len_y, unit_len_z, size
) {

    module _side_stabilizers() {
        translate([
            corner_side + unit_len_x/2 + 5,
            corner_side + unit_len_y/2 - 15,
            15
        ])
        rotate([-90, 135, 90])
        corner_stabilizer_z_left(size);

        translate([
            corner_side + unit_len_x/2 + 5,
            -corner_side - unit_len_y/2 + 15,
            15
        ])
        rotate([-90, -135, 90])
        corner_stabilizer_z_right(size);

        translate([
            corner_side + unit_len_x/2 + 5,
            corner_side + unit_len_y/2 - 15,
            unit_len_z + corner_side*2 - 15
        ])
        rotate([-90, 45, 90])
        corner_stabilizer(size);

        translate([
            corner_side + unit_len_x/2 + 5,
            -corner_side - unit_len_y/2 + 15,
            unit_len_z + corner_side*2 - 15
        ])
        rotate([-90, -45, 90])
        corner_stabilizer(size);
    }

    module _front_stabilizers() {
        translate([
            corner_side + unit_len_x/2 - 15,
            -corner_side - unit_len_y/2 - 5,
            15
        ])
        rotate([-90, 135, 0])
        corner_stabilizer(size);

        translate([
            -corner_side - unit_len_x/2 + 15,
            -corner_side - unit_len_y/2 - 5,
            15
        ])
        rotate([-90, -135, 0])
        corner_stabilizer(size);

        translate([
            corner_side + unit_len_x/2 - 15,
            -corner_side - unit_len_y/2 - 5,
            unit_len_z + corner_side*2 - 15
        ])
        rotate([-90, 45, 0])
        corner_stabilizer(size);

        translate([
            -corner_side - unit_len_x/2 + 15,
            -corner_side - unit_len_y/2 + 5,
            unit_len_z + corner_side*2 - 15
        ])
        rotate([-90, -45, 0])
        corner_stabilizer(size);
    }

    _side_stabilizers();

    mirror([1, 0, 0])
    _side_stabilizers();

    _front_stabilizers();

    mirror([0, 1, 0])
    _front_stabilizers();
    
    translate([
        unit_len_x/2 + 30, -unit_len_y/2 - 30, 15
    ])
    rotate([180, 0, -135])
    corner_stabilizer_inner(size);

    translate([
        -unit_len_x/2 - 30, -unit_len_y/2 - 30, 15
    ])
    rotate([180, 0, 135])
    corner_stabilizer_inner(size);

    translate([
        -unit_len_x/2 - 30, unit_len_y/2 + 30, 15
    ])
    rotate([180, 0, 45])
    corner_stabilizer_inner(size);

    translate([
        unit_len_x/2 + 30, unit_len_y/2 + 30, 15
    ])
    rotate([180, 0, -45])
    corner_stabilizer_inner(size);
}

module _frame_mockup(
    units_x=1, units_y=1, units_z=1, x_pos=0, bed_angle=45,
    stabilizers=120
) {


    unit_len_x = units_x*unit;
    unit_len_y = units_y*unit;
    unit_len_z = units_z*unit;
    z = 2*corner_side + unit_len_z - 30;

    echo("X:", unit_len_x);
    echo("Y:", unit_len_y);
    echo("Z:", unit_len_z);


    f_fname = 
        str(
            "frame_", unit_len_x, "_", unit_len_y,
            "_", unit_len_z, ".stl"
        );

    %import(
        str("mockup_stl/", f_fname), convexity=10
    );

    s_fname = 
        str(
            "stabilizers_", unit_len_x, "_", unit_len_y,
            "_", unit_len_z, "_", stabilizers, ".stl"
        );

    %import(
        str("mockup_stl/", s_fname), convexity=10
    );
    //_stabilizers_to_stl(unit_len_x, unit_len_y, unit_len_z, 150);

    // X beam
    translate([-unit_len_x/2, x_pos, z + 30 + 43.5])
    rotate([0, 90, 0])
    _side(unit_len_x);
    
    module _z_stuff() {
        import(
            "STL/z_motor_mount_no_supports.stl",
            convexity=10
        );

        translate([0, 42.3/2, -20])
        rotate([90, 0, 0])
        mock_stepper_motor();

        translate([0, 0, -60])
        render()
        z_motor_support_base();

        translate([0, 0, -46])
        render()
        z_motor_support_nut();

        render()
        translate([-29, 0, unit_len_z - 90])
        rotate([180, 0, 0])
        bed_screw_housing(render_threads=false);

        translate([0, 0, unit_len_z])
        rotate([0, 180, 0])
        render()
        bed_rail_frame_mount_top();
    }

    translate([-unit_len_x/2 - 45, 0, 90])
    rotate([0, 0, 180])
    _z_stuff();

    translate([unit_len_x/2 + 45, 0, 90])
    _z_stuff();

    translate([0, -unit_len_y/2 - corner_side + 37, unit_len_z/2])
    rotate([90, 0, 0])
    render()
    middle_panel(unit_len_y + 2*corner_side);

    translate([
        -unit_len_x/2 - corner_side,
        unit_len_y/2 + corner_side
    ])
    rotate([180, 0, 0])
    render()
    leg_small_adjustable();
}

module _y_motors(unit_len_x, unit_len_z) {
    rotate([0, -135, 90])
    mock_stepper_motor(geared=false, center=true); 

    render()
    translate([
        unit_len_x/2 + 45,
        25, unit_len_z + 124
    ])
    rotate([0, 0, -90])
    do_rack();

    render()
    translate([
        unit_len_x/2 + 45,
        25, unit_len_z + 124
    ])
    rotate([0, 0, -90])
    assembly_motor_mount();
}

module dollo3d() {
    units_x = 3;
    units_y = 3;
    units_z = 670/unit;

    unit_len_x = units_x*unit;
    unit_len_y = units_y*unit;
    unit_len_z = units_z*unit;
    z = 2*corner_side + unit_len_z - 30;

    _frame_mockup(
        units_x, units_y, units_z, x_pos=10, bed_angle=0,
        stabilizers=150
    );

    // X
    translate([0, 25, 837.5])
    rotate([0, 0, 180])
    assembly_rack();

    translate([0, -25, 837.5 + 12.7])
    rotate([90, -45, 0])
    chain_motor_mount_y_right();

    render()
    translate([
        unit_len_x/2, 25,
        unit_len_z + 124 + 24.5
    ])
    rotate([90, 0, 90])
    x_spacer(supports=false);

    render()
    translate([210, -23.75, unit_len_z + 124 + 10.2])
    rotate([0, 0, 90])
    assembly_chainlink(15);

    %translate([20, -38, unit_len_z + 124 + 10.4])
    rotate([-90 + 25, 0, 0])
    cable_chain_support(340, arms=3);

    translate([22.5, 10, unit_len_z + 124 + 6.4])
    rotate([90, 0, -90])
    cable_chain_support_arm();

    // Y
    translate([
        unit_len_x/2 + 45,
        25, unit_len_z + 124
    ])
    rotate([0, 0, -90])
    assembly_rack();

    translate([
        unit_len_x/2 + 85,
        25, unit_len_z + 124 + 12.7
    ])
    rotate([90, 0, -90])
    chain_motor_mount_y_left();

    translate([0, 20, unit_len_z])
    rotate([0, 0, 180])
    debug_bed_frame_340_300();

//    translate([
//        -unit_len_x/2 + 120,
//        -unit_len_y/2 - corner_side + 23,
//        unit_len_z/2
//    ])
//    rotate([90, 0, 0])
//    render()
//    raspberry_pi_3b_mount();

//    translate([
//        unit_len_x/2 - 40,
//        -unit_len_y/2 - corner_side + 23,
//        unit_len_z/2
//    ])
//    rotate([90, 0, 0])
//    render()
//    adapter_mks_sbase_box();

//    translate([
//        unit_len_x/2 - 100,
//        -unit_len_y/2 - corner_side + 23,
//        unit_len_z/2
//    ])
//    rotate([90, 0, 0])
//    render()
//    adapter_tl_smoother();

//    translate([
//        unit_len_x/2 - 140,
//        -unit_len_y/2 - corner_side + 23,
//        unit_len_z/2
//    ])
//    rotate([90, 0, 0])
//    render()
//    adapter_tl_smoother();

//    translate([25, -unit_len_y/2 - corner_side + 7, 149])
//    rotate([0, 90, 90]) {
//        render()
//        mock_PSU_360W();
//
//        translate([57, 182, -6/2])
//        rotate([0, 0, 180])
//        psu_inner_mount_360();
//    }

//    translate([
//        -unit_len_x/2 + 120,
//        -unit_len_y/2 - corner_side + 13.5, 24.75
//    ])
//    rotate([90, 0, 90])
//    psu_support_clip_360();

//    translate([
//        unit_len_x/2 - 180,
//        -unit_len_y/2 - corner_side + 23,
//        unit_len_z/2
//    ])
//    rotate([90, 0, 0])
//    render()
//    atx_connector_small_mount();
}

module dollo3d_2() {
    units_x = 2;
    units_y = 2;
    units_z = 570/unit;

    unit_len_x = units_x*unit;
    unit_len_y = units_y*unit;
    unit_len_z = units_z*unit;
    z = 2*corner_side + unit_len_z - 30;

    _frame_mockup(
        units_x, units_y, units_z, x_pos=10, bed_angle=0
    );

    //translate([0, -unit_len_y/2, 17])
    //mock_atx_psu();

    translate([
        -20, -unit_len_y/2 - corner_side,
        210
    ])
    rotate([90, 0, 0])
    render()
    atx_connector_mount();

    translate([
        unit_len_x/2 - 20, -unit_len_y/2 - corner_side - 6,
        220
    ])
    rotate([90, 0, 0])
    render()
    ramps_enclosure();

    translate([
        unit_len_x/2 - 13.5, -unit_len_y/2 - corner_side,
        221         
    ])
    rotate([90, 0, 0])
    render()
    ramps_enclosure_mount();

    translate([
        -unit_len_x/2 + 2, -unit_len_y/2 - corner_side - 10,
        221
    ])
    rotate([90, 0, 0])
    render()
    raspberry_pi_3b_mount();

    // TODO
    //render()
    translate([-68.5, -unit_len_y/2 - 70, 136.3])
    rotate([90, 90, 0])
    mock_PSU_240W();

    translate([118.5, -unit_len_y/2 - 67.5, 83])
    rotate([90, -90, 0])
    psu_stabilizer_mount_240();

    translate([
        -unit_len_x/2 + 120,
        -unit_len_y/2 - corner_side + 13.5, 24.75
    ])
    rotate([90, 0, -90])
    psu_support_clip_240();
}
