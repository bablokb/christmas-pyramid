// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Holder for LED-strip (glued on).
//                      Print in PETG for thermal reasons.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/christmas-pyramid
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <shared.scad>

d_holder = 43;           // inner diameter of holder
h_holder = z_support;
h_base   = 0.6;

x_cutout = 10;
y_cutout = d_holder + 10;
z_cutout = 5;

// --- holder   --------------------------------------------------------------

module holder() {
  // base
  difference() {
    cyl(h=h_base,d=d_holder+w2,anchor=BOTTOM+CENTER);
    move([-ox_support,0,-fuzz])
      cyl(h=h_base+2*fuzz,d=do_support+gap,anchor=BOTTOM+CENTER);
    move([+ox_support,0,-fuzz])
      cyl(h=h_base+2*fuzz,d=do_support+gap,anchor=BOTTOM+CENTER);
  }
  // tube
    tube(h=h_holder, id=d_holder,wall=w2, anchor=BOTTOM+CENTER);
}

// --- final object   ---------------------------------------------------------

module main() {
  difference() {
    holder();
    // cutouts for wires
    zmove(-fuzz) zrot(-45)
      cuboid([x_cutout,y_cutout,z_cutout], anchor=BOTTOM+CENTER);
    zmove(-fuzz) zrot(+45)
      cuboid([x_cutout,y_cutout,z_cutout], anchor=BOTTOM+CENTER);
  }
}

main();
