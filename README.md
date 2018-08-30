# Dollo3D
A (almost) fully printed 3D printer, that scales.

# Goals in order of priority

1) Make a 3D printer that can make as many of its own parts as possible

2) Have it so the machine can scale with little to no throwing away of old parts

3) Make it easy to assemble

4) Use no more than a single 1KG spool of plastic to make. (not happening)

5) Make it as low cost as possible.

6) use parts that are easy to find.

7) make it durable (since it can print its own parts this isn't super high priority)

8) hope people stop asking "what if you could 3D print a 3D printer" because of course you can and its not that unique of an idea

# Part count and list for smallest viable Dollo, with around 21x21x12cm print volume. Smaller frame can be built, but the z-axis parts aren't tested in any way with that kind of setup

* 25 -- extention.stl
* 4 -- extention_90_bend.stl (or extention_90_bend_extra_stiff.stl)
* 8 -- corner.stl (or corner_extra_stiff.stl)
* 192+ -- bow_tie.stl but extra never hurts (or bow_tie_with_brim.stl)
* 132+ —- long_tie.stl (or long_tie_split.stl, more forgiving on the tolerances)
* 10+ -- long_tie_half.stl
* 50+ -- long_bow_tie.stl (or long_bow_tie_split.stl, more forgiving on the tolerances)
* 2 -- x_spacer.stl
* 6 -- rack_5.stl
* 6 -- rack_dove_pin.stl 
* 1 -- bed_carriage_endstop_screw.stl
* 1 -- bed_carriage_endstop_screw_mount.stl
* 1 -- bed_carriage_endstop_screw_nut.stl
* 4 -- bed_carriage_rail.stl
* 4 -- bed_carriage_rail_short.stl
* 4 -- bed_carriage_rail_center.stl
* 2 -- bed_carriage_rail_frame_mount.stl
* 2 -- bed_carriage_rail_frame_mount_top.stl
* 4 -- bed_carriage_rail_slide.stl
* 2 -- bed_screw_housing.stl
* 2 -- bed_screw_housing_coupler.stl
* 2 -- bed_screw_housing_top.stl
* 10+ -- cable_clip_large.stl/cable_clip_small.stl
* 1 -- cable_shroud_frame_mount.stl (if using cable shroud)
* 1 -- hot_end_mount.stl
* 1 -- hot_end_mount_clamp.stl (or hot_end_mount_clamp_shroud_mount.stl if using cable shroud)
* 1 -- hot_end_mount_fan_duct.stl
* 1 -- hot_end_mount_prox_sensor_clamp.stl (if using proximity sensor)
* 4 -- leg.stl
* 4 -- leg_foot.stl OR following 3 items.
* 4 -- leg_foot_adjustable.stl
* 4 -- leg_foot_adjustable_core.stl
* 4 -- leg_foot_dampener.stl (print with flex material)
* 3 -- motor_gear.stl (or motor_gear_slop_0.1.stl)
* 6 -- motor_mount_small.stl
* 1 -- psu_holder.stl OR following 3 parts if using ATX psu
* 1 -- psu_holder_atx_psu_cover.stl
* 1 -- psu_holder_back_atx.stl
* 1 -- psu_holder_front_atx.stl
* 1 -- psu_holder_clip_extension.stl
* 2 -- xy_endstop_rackend.stl OR
* 2 -- xy_endstop_racktop.stl (I prefer this, easier to adjust position)
* 1 -- z_endstop.stl
* 2 -- z_screw_120.stl
* 2 -- z_screw_center_coupler.stl
* 2 -- z_screw_motor_coupler_flex.stl
* 2 -- z_coupler_flexible_coupler_nut_hex.stl
* 2 -- z_coupler_flexible_coupler_tube.stl (print with flex material)
* 2 -- z_coupler_motor_shaft_adapter.stl
* 6 -- z_screw_housing_bolt_side.stl
* 6 -- z_screw_side_roller.stl
* 6 -- z_screw_side_roller_axle.stl
* 6 -- z_screw_side_roller_axle_washer.stl
* 1 -- ramps_mount.stl
* 2 -- ramps_mount_fan_mount_60mm.stl
* 3 -- ramps_mount_frame_clip.stl
* 2 -- tools/rail_jig.stl
* 2 -- tools/rail_jig_clip.stl
* 1 -- tools/z_screw_jig.stl
* 2 -- tools/z_screw_jig_clip.stl

# Metal parts we might get rid of in the future

* 9 -- M3x40  for the motor mounts
* 8 -- M3x10  for the z motors

# Electronics and other

* 1 - main controller board. Frame mount parts for RAMPS are available. Also for Raspi3
* 3 - end stop switches
* 5 - motors steppers, no need for very beefy motors
* 1 - hotend or whatever tool tip you want really. E3Dv6 is tested
* 1 - hobbed thing, gear or bolt. Actually whole extruder. Buy or pick one to print from thingiverse. This is good: https://www.thingiverse.com/thing:2243325
* 1 - heated bed (21x21cm)
* 1 - glass/aluminum that fits on the bed (depends if the bed needs one)
* 4 - springs and screw for leveling your bed.
* some glue for joining the bed_carriage_rail and z_screw parts together

# Options for a larger printer

* the default expansion length in each direction is 12cm (default extention part length).
* the frame can be extended in any direction, just print enough extention.stl parts and ties. If extending in z-direction, also print enough bed_carriage_rail, bed_carriage_rail_center, z_screw_120, z_screw_center
* the default 12cm expansion length can be adjusted to suit ones need, just modify the scad files and export different length models (make sure all updated models are same length)
* the frame will become somewhat wobbly after certain z-height (25+cm). There are stabilizer parts designed, but not for the current Dollo iteration. WIP currently

# Print settings
1. I use PLA for most of the parts, except PETG for rack_5, all _tie-parts and z_screw_side_roller. Flexible material (FilaFlex or similar) for few models (see BOM). Nylon for the part cooling (hotend) fan
2. For most parts, 2x perimeter, 20% infill, 0.2mm layer height, outer perimeter first and no supports. Some models do need supports, but those should be easy to spot.
3. Motor_gear: 4+ perimeters, 90% infill
4. bed_carriage_rails, centers, z_screws: 3 perimeters, 25+% infill
5. All _tie parts: print only after printing at least 1 extention. Print few of each _tie part and see how they fit. Most likely you'll need to use scaling in slicer sw to get them fit.

# How to assemble (mostly old info, needs update)
1) start with the basic frame, take a single corner and butt joint all 3 extension pieces to it with all 4 bow_tie slots. then on the end of each of those add corner pieces then extension pieces again until you have built out a full cube shape.

2) put on the racks. first you need to decide what side you want to be up, this really doesn't matter since it should be the same on all sides. Once you have figured that out, you can start putting your slots on the top of your printer with more bow ties add racks on parallel sides and to the top of your remaining extension piece. each should have 3 racks on it.

3) mounting your motors. first you will need to put a gear.scad on your motor shaft, then you can take a motor and put the motor_mount_small on it and screw in the single counter sunk screw on the bottom using a M3x10 and then put it on your printer rack and make sure the gear aligned with the rack teeth. once it does you can keep it on the rack and screw in your other motor_mount_small to the other side. (make sure to do this on the printer because if you don't it wont go on after) do this for all 3 racks and make sure the motor faces out.

4) mounting the x axis. grab your x_spacer and put them on the end of what you already have assembled on the left over extention piece and then slide that into the motor mount on each side of the printer.

5) Get the frame ready for the bed. first you need to prep you printer by taking the crazy looking twist_corner pieces and bow tie them to the inside of the printers frame mirroring each other but keep the bottom one out on each side.

6) now take a motor and mount put the gear_one on it and mount that to your bed, then take your middle_gear and put those next to the motor and then put your large_gear and large_twist together, and put those next in line. 

7) putting the bed in. This can be kind of tricky, but you have to twist your bed so it goes inside the frame sideways and the you should be-able to twist it to make it fit in the frame with the corners sticking out. and this is why we didn't put in the bottom corner_twists, because now your bed sits just under them and once you have the electronics set up it will be able to twist into those and once its in the teeth you will be able to add your last parts under it.

8) Electricity is fun. take all of your motor and put them into the correct stepper controllers making sure that your Y motors are plugged in opposite of each other. Plug in your electronics and make sure to upload the correct Dollo version of marlin. Once you have done this you should be able to move your motors and this is where you move your z motor in the negative direction (negative because that make the hotend and the bed closer) and once it is up at the top, you can put your last twist_corners on your printer.

9) hot ends and end stops. at the point of making this commit I do not yet have the end stops figured out. But the hotend should put in your hotend mount and should just slide and clip into your x motor mount. 

10) setting up the extruder. Not sure what extruder we are going to use yet, but if you have done 3D printing before you should know how all of that works and be able to get it going.

Z options) I do have the z axis all modeled for being fully printed and able to scale

# Extra cool facts

1) I came up with the original version of this when I was 16 and in high school and it was done in blender because thats all I knew how to use

2) This printer as it stands is under 1KG of printed parts 

3) We printed the first Dollo on 3 Prusa Mendal printer that were printer on other printers them selves and so on, all the way back to the start, so these machine have only open-source in their genealogy

4) I lived 300 miles from the printer that I used and did all of the printing over the internet using octopi to print the first Dollo

5) The Dollo can (if you want) have a metal core structure, we built it in just in case and it saved plastic so it was a win win.

6) The Dollo was made by a me and my dad, I didn't the modeling and he helped me come up with ideas on how to fix the issues I has on the way, and he test fit most of the pieces (the printers were at his house)

7) The Dollo has swappable tool heads so you can mill metal parts if you want!

8) We had no plans on how this was going to work before starting. We have gone through probably close to a 50 different ideas on how this thing should even work.

9) Half way though we almost gave up on the z and made the Dollo a Delta style printer (might still have something like that in the future)

10) We looked at a lot of other peoples printer before we could figure out how to do this one, we really could not have done it with out the community.
