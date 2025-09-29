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
h_base = h_iwall -b;

h_cone = (h_wall-h_base)/2;
d_cone = 45;

// --- wall   ----------------------------------------------------------------

module wall() {
  // base (inner-wall)
  tube(h=h_base,od=d_bottom,id=d_bottom-2*w2, anchor=BOTTOM+CENTER);
  // cone
  zmove(h_base-fuzz)
    zflip_copy(0,h_cone)
      tube(h=h_cone, od1=d_bottom,id1=d_bottom-2*w2,
                     od2=d_cone,id2=d_cone-2*w2,
                     anchor=BOTTOM+CENTER);
}

// --- final shape   ---------------------------------------------------------

wall();
