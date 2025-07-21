// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Turntable plate (rotated for printing).
//
// Included from level1.scad
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/christmas-pyramid
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <shared.scad>

z_moconn  = z2_shaft + z3_shaft;
d1_moconn = 1.5*d2_shaft;
d2_moconn = 20;
rd_moconn = -5;

// --- shaft (used for cutout)   ---------------------------------------------

module shaft() {
  zmove(z2_shaft-fuzz) intersection() {
    cylinder(h=z3_shaft+2*fuzz,d=d2_shaft, anchor=BOTTOM+CENTER);
    move([0,-fuzz,-fuzz])
     cuboid([d3_shaft,d2_shaft+2*fuzz,z3_shaft+3*fuzz], anchor=BOTTOM+CENTER);
  }
  cylinder(h=z2_shaft,d=d2_shaft, anchor=BOTTOM+CENTER);
}

// --- motor-connector   -----------------------------------------------------

module motor_connector() {
 zmove(z_moconn) yrot(180) difference() {
    cyl(h=z_moconn,d1=d1_moconn, d2=d2_moconn,
        rounding2=rd_moconn, anchor=BOTTOM+CENTER);
    zmove(-fuzz) shaft();
  }
}

// --- turntable plate   -----------------------------------------------------

module tt_plate(h_add=0,r_add=0,connector=true) {
  cyl(h_add+h_bottom, r_add+r_ttable, anchor=BOTTOM+CENTER);
  if (connector) {
    zmove(b-fuzz)
      motor_connector();
  }
}
