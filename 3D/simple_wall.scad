// -----------------------------------------------------------------------------
// 3D-Model (OpenSCAD): A minimal version of the pyramid (wall).
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/christmas-pyramid
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <simple_shared.scad>
include <motor_dims.scad>
include <pcb_holder.scad>

h_wall = z_support + 1 + z1_shaft + z2_shaft + z3_shaft;
h_base = 1.5*(h_iwall - b);

h_ring = 10;
h_cone = (h_wall-2*h_ring-2*h_base)/2;
d_cone = 60;

x_cutout = 22 + gap;
z_cutout = 2* h_base;

// --- wall   ----------------------------------------------------------------

module wall() {
  zflip_copy(0,h_wall/2-fuzz) {
    // base (inner-wall)
    tube(h=h_base,od=d_bottom,id=d_bottom-2*w2, anchor=BOTTOM+CENTER);
    // cone
    zmove(h_base-fuzz)
      tube(h=h_cone, od1=d_bottom,id1=d_bottom-2*w2,
                     od2=d_cone,id2=d_cone-2*w2,
                     anchor=BOTTOM+CENTER);
    zmove(h_base+h_cone-fuzz)
      tube(h=h_ring,od=d_cone,id=d_cone-2*w2, anchor=BOTTOM+CENTER);
  }
}

// --- final shape   ---------------------------------------------------------

difference() {
  wall();
  zmove(-fuzz) ymove(d_bottom/2-w2)
    cuboid([x_cutout,3*w2,z_cutout], anchor=BOTTOM+CENTER);
}
